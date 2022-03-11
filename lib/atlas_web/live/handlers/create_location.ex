defmodule AtlasWeb.Live.Handlers.CreateLocation do
  alias Atlas.Repo
  alias Atlas.Customers.Location
  import Phoenix.LiveView, only: [assign: 3]


  def change(%{"location" => attrs}, socket) do
    cs = Location.create_changeset(%Location{}, attrs)
    socket = assign(socket, :changeset, cs)
    {:noreply, socket}
  end


  def submit(%{"location" => attrs}, socket) do
    cs = Location.create_changeset(%Location{}, attrs)
    case Repo.insert(cs) do
      {:ok, _loc} ->
        empty_cs = Location.create_changeset(%Location{}, %{})
        socket = assign(socket, :changeset, empty_cs)
        {:noreply, socket}
      nope ->
        IO.inspect(nope, label: "nope")
        {:noreply, socket}
    end
  end


end
