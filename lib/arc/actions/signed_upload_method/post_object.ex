defmodule Arc.Actions.SignedUploadMethod.PostObject do
  @behaviour Arc.Actions.SignedUploadMethod

  @default_expiration 60*5

  alias Arc.FileObject
  alias Arc.OSSFileObject
  alias Arc.Utils

  def run(definition, %OSSFileObject{key: key, file_and_scope: {%FileObject{mime_type: content_type}, _scope}} = file_object, options) do
    policy = post_object_policy(definition, file_object, options)
    url = post_object_url(definition, file_object)

    %{
      "url": url,
      "key": key,
      "Content-Type": content_type,
      "policy": policy
    }
    |> definition.__storage().post_object_auth_data(policy, options)
  end

  #
  # Private
  #

  defp post_object_policy(definition, file_object, options) do
    post_object_policy_expiration = post_object_policy_expiration(options)

    %{
      "expiration": post_object_policy_expiration,
      "conditions": post_object_policy_conditions(definition, file_object, options)
    }
    |> Poison.encode!()
    |> Base.encode64()
  end

  defp post_object_policy_expiration(options) do
    expiration_duration =
      options
      |> Keyword.get(:expiration, @default_expiration)
      |> Timex.Duration.from_seconds()

    "GMT"
    |> Timex.now()
    |> Timex.add(expiration_duration)
    |> Utils.iso_8601_extended_time()
  end

  defp post_object_policy_conditions(definition, %OSSFileObject{bucket: bucket, key: key, file_and_scope: {%FileObject{mime_type: content_type}, _scope}}, options) do
    content_length_range = options[:content_length_range] || definition.content_length_range()

    basic_conditions =
      [
        %{"bucket": bucket},
        %{"key": key},
        %{"Content-Type": content_type}
        | case content_length_range do
          {0, 0} -> []
          {min, max} -> [["content-length-range", min, max]]
        end
      ]

    definition.__storage().post_object_policy_conditions(definition, basic_conditions, options)
  end

  defp post_object_url(definition, file_object) do
    definition.__storage().post_object_url(file_object)
  end
end
