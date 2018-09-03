defmodule Arc.OSSFileObject do
  @moduledoc """
  `OSSFileObject` provides a common abstraction of file
  stored in object-storage service.
  """

  @enforce_keys [:bucket, :key, :name]
  defstruct [
    # OSS fields
    # {:bucket, :key} can uniquely determine a file
    :bucket,
    :key,

    :version,
    # file_and_scope = {%Arc.FileObject{}, scope = %{}}
    :file_and_scope
  ]

  alias Arc.FileObject

  def new(%{} = attrs) do
    struct(__MODULE__, attrs)
  end

  def new(%{} = attrs, version, {%FileObject{}, %{}} = file_and_scope) do
    attrs
    |> Map.merge(%{version: version, file_and_scope: file_and_scope})
    |> new()
  end

  def new(definition, version, {%FileObject{}, %{}} = file_and_scope) do
    %{
      bucket: definition.storage_bucket(),
      key: definition.storage_key(file_and_scope)
    }
    |> new(version, file_and_scope)
  end
end
