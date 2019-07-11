defmodule Arc.FileObject do
  @moduledoc """
  `FileObject` provides a common abstraction of a file.
  """

  @enforce_keys [:name]
  defstruct [
    # https://github.com/stavro/arc/blob/v0.11.0/lib/arc/definition/versioning.ex#L16
    :file_name,
    :size,
    :mime_type,
    :path
  ]

  alias Arc.Utils

  def new(%{mime_type: mime_type} = attrs) when not is_nil(mime_type) do
    struct(__MODULE__, attrs)
  end

  def new(%{file_name: file_name} = attrs) do
    attrs
    |> Map.put(:mime_type, Utils.mime_type(file_name))
    |> new()
  end
end
