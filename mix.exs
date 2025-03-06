defmodule InternetMapper.MixProject do
  use Mix.Project

  def project do
    [
      app: :inetnet_mapper,
      version: "0.2.0",
      elixir: "~> 1.10",
      description: "A tool to map IPs, perform HTTP requests, and do reverse DNS lookups",
      package: package(),
      deps: deps()
    ]
  end

  defp package do
    [
      maintainers: ["Majid"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/evokelektrique/inetnet_mapper"}
    ]
  end


  defp package do
    [
      maintainers: ["Majid"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/evokelektrique/inetnet_mapper"}
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
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:finch, "~> 0.10"},
      {:flow, "~> 1.2"},
      {:memento, "~> 0.5"}
    ]
  end
end
