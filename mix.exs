defmodule ExArc.MixProject do
  use Mix.Project

  @project_host "https://github.com/GreenNerd-Labs/ex_arc"
  @version "0.0.4"

  def project do
    [
      app: :ex_arc,
      version: @version,
      source_url: @project_host,
      homepage_url: @project_host,
      description: description(),
      package: package(),
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    []
  end

  defp deps do
    [
      {:arc, "~> 0.11.0"},
      {:mime, "~> 1.3"},
      {:poison, "~> 3.1"},
      {:timex, "~> 3.3"}
    ]
  end

  defp description do
    "Extended Arc for remote object-storage service"
  end

  defp package do
    [
      name: :ex_arc,
      files: ["lib", "mix.exs", "README.md", "MIT-LICENSE"],
      maintainers: ["CptBreeza"],
      licenses: ["MIT"],
      links: %{"GitHub" => @project_host}
    ]
  end
end
