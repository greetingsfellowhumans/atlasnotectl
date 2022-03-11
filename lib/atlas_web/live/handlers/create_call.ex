defmodule AtlasWeb.Live.Handlers.CreateCall do
  alias Atlas.Repo
  alias Atlas.Customers.ServiceCall
  #import Phoenix.LiveView, only: [assign: 3]
  use AtlasWeb, :live_view


  def change(%{"service_call" => attrs}, socket) do
    num = socket.assigns.location_number
    cs = ServiceCall.create_changeset(%ServiceCall{location_number: num}, attrs)
    socket = assign(socket, :changeset, cs)
    {:noreply, socket}
  end


  def submit(%{"service_call" => attrs}, socket) do
    num = socket.assigns.location_number
    cs = ServiceCall.create_changeset(%ServiceCall{location_number: num}, attrs)
    case Repo.insert(cs) do
      {:ok, service_call} ->
        empty_cs = ServiceCall.create_changeset(%ServiceCall{}, %{})
        socket = assign(socket, :changeset, empty_cs)
        src_push!(%Sorcery.Src{changes_db: %{service_call: %{service_call.id => service_call}}})
        {:noreply, socket}
      _nope ->
        {:noreply, socket}
    end
  end

  def render(assigns), do: ~H""

end
