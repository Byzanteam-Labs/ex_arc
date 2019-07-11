defmodule Arc.Actions.StorageCommon do
  alias Arc.FileObject

  defmacro __using__(_) do
    quote do
      def storage_bucket(), do: Arc.Actions.StorageCommon.storage_bucket(__MODULE__)
      def storage_key(version, file_and_scope), do: Arc.Actions.StorageCommon.storage_key(__MODULE__, version, file_and_scope)
    end
  end

  def storage_bucket(definition) do
    case definition.bucket() do
      {:system, env_var} when is_binary(env_var) -> System.get_env(env_var)
      name -> name
    end
  end

  def storage_key(definition, version, {%FileObject{file_name: file_name}, _scope} = file_and_scope) do
    Path.join([
      definition.storage_dir(version, file_and_scope),
      definition.filename(version, file_and_scope)
    ]) <> Path.extname(file_name)
  end
end
