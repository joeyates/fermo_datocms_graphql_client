defmodule Fermo.DatoCMS.GraphQLClient do
  alias DatoCMS.GraphQLClient.Backends.StandardClient
  alias DatoCMS.GraphQLClient.QueryMonitor
  alias Fermo.Live.Dependencies
  alias Fermo.Live.SocketRegistry

  def configure(opts \\ []) do
    StandardClient.configure(opts)
  end

  # Updates to queries called in this manner will cause a
  # reload of the project's config/0
  def query!(query, params \\ %{}) do
    if StandardClient.live? do
      {:ok, body} = QueryMonitor.subscribe!(query, params, fn ->
        handle_reload(nil)
      end)

      body
    else
      StandardClient.query!(query, params)
    end
  end

  # This function should only be called from **within**
  # a template or partial, so that when changes happen,
  # a reload will cause this function to be called again
  # obtaining updated data
  def query_for_path!(path, query, params \\ %{}) do
    if StandardClient.live? do
      {:ok, body} = QueryMonitor.subscribe!(query, params, fn ->
        handle_reload(path)
      end)

      body
    else
      StandardClient.query!(query, params)
    end
  end

  defp handle_reload(path) do
    if !path do
      # This query is not associated with a specific path.
      # We cannot know which pages (i.e. paths) it affects,
      # So we need to reload the Fermo config
      {:ok} = Dependencies.reinitialize()
    end
    {:ok} = SocketRegistry.reload(path)
  end
end
