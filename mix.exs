defmodule Cogoli.MixProject do

  use Mix.Project

  def project do
    [
      app: :cogoli,
      version: "1.0.1",
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps(),
    ]
  end

  def application do
    [
      extra_applications: [:logger, :cgolam],
    ]
  end

  defp deps do
    [
      {:cgolam, "~> 1.0.1"},
      {:dialyxir, "~> 0.5.0", only: [:dev], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev},
    ]
  end

  defp package() do
    [
      name:  "cogoli",
      description: "COnway's Game Of LIfe (with variations)",
      licenses: ["MIT"],
      maintainers: [
        "Michael Wright <mjw@methodanalysis.com>"
      ],
      links: %{
        "Github" => "https://github.com/mwri/cogoli",
      }
    ]
  end

end
