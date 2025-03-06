defmodule InternetMapper.MixProject do
  use Mix.Project

  def project do
    [
      app: :internet_mapper,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :mnesia],
      mod: {InternetMapper.Application, []}
    ]
  end

  defp deps do
    [
      {:finch, "~> 0.10"},
      {:flow, "~> 1.2"},
      {:memento, "~> 0.5"}
    ]
  end
end
