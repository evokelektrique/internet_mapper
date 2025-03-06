defmodule IPMapper.MixProject do
  use Mix.Project

  def project do
    [
      app: :inetnet_mapper,
      version: "0.1.0",
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


  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:mint, "~> 1.4"},
      {:gen_stage, "~> 1.1"}
    ]
  end
end
