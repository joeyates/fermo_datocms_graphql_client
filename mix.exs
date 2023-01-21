defmodule Fermo.DatoCMS.GraphqlClient.MixProject do
  use Mix.Project

  @version "0.14.5"
  @git_origin "https://github.com/leanpanda-com/fermo_datocms_graphql_client"

  def project do
    [
      app: :fermo_datocms_graphql_client,
      version: @version,
      elixir: "~> 1.9",
      description: "Handle real-time updates to DatoCMS GraphQL queries",
      package: package(),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: [
        extras: ["README.md"],
        homepage_url: @git_origin,
        main: "Fermo.DatoCMS.GraphQLClient",
        source_ref: "v#{@version}",
        source_url: @git_origin
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger, :httpoison]
    ]
  end

  defp package do
    %{
      licenses: ["MIT"],
      links: %{
        "GitHub" => @git_origin
      },
      maintainers: ["Joe Yates"]
    }
  end

  defp deps do
    [
      {:datocms_graphql_client, ">= 0.13.0"},
      {:fermo, ">= 0.16.5"},
      {:ex_doc, "~> 0.21.2", only: :dev}
    ]
  end
end
