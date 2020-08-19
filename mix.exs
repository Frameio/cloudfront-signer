defmodule CloudfrontSigner.MixProject do
  use Mix.Project

  def project do
    [
      app: :cloudfront_signer,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {CloudfrontSigner.Application, []}
    ]
  end

  defp deps do
    [
      {:jason, "~> 1.2"},
      {:timex, "~> 3.1"}
    ]
  end
end
