defmodule PhoenixU2F.MixProject do
  use Mix.Project

  def project do
    [
      app: :phoenix_u2f,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:credo, "~> 1.0", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0.0-rc.6", only: [:dev, :test], runtime: false},
      # Non-testing dependencies
      {:ecto, "~> 3.1.7"},
      {:phoenix, "~> 1.4.9"},
      {:u2f_ex, "~> 0.4.1"}
    ]
  end

  defp description do
    "An easy-to-use U2F library for Phoenix"
  end

  defp package do
    [
      name: "phoenix_u2f",
      files: ["lib", "mix.exs", "README.*", "LICENSE"],
      maintainers: ["Ian Lee Clark"],
      licenses: ["BSD"],
      links: %{"Github" => "https://github.com/ianleeclark/Paseto"}
    ]
  end
end
