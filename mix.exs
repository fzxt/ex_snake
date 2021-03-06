defmodule ExSnake.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_snake,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    if Mix.env() == :test do
      [
        extra_applications: [:logger]
      ]
    else
      # don't define the mod attribute for test env, screws up output
      [
        extra_applications: [:logger],
        mod: {ExSnake, []}
      ]
    end
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:credo, "~> 0.10.0", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.19", only: :dev, runtime: false}
    ]
  end

  defp escript do
    [main_module: ExSnake.CLI, emu_args: "-noinput -elixir ansi_enabled true"]
  end
end
