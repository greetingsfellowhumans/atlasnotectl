defmodule AtlasWeb.Live.Pages.Locations do
  use AtlasWeb, :live_view
  alias Atlas.Repo
  alias Atlas.SorceryStorage
  alias Atlas.Customers.{Location, Unit}
  alias AtlasWeb.Live.Forms.{CreateLocation, CreateUnit}
  alias AtlasWeb.Live.Lists.{Locations, Units}
  alias Sorcery.Src
  import Interceptors.IncUnit
  use AtlasWeb.Live.Handlers.CreateUnit
  use AtlasWeb.Live.Handlers.CreateLocation


  def mount(_params, _session, socket) do
    locations = Repo.all(Location)
    SorceryStorage.add_entities(:location, locations, %{})
    portal = %{tk: :location, guards: [{:>=, :id, 0}], indices: [:location_number]}
    SorceryStorage.create_portal(socket, portal, %{})
    socket = assign_portals(socket)
             |> assign(:creating?, false)
    
    {:ok, socket}
  end

  def handle_event("toggle_creating", _, socket) do
    creating = socket.assigns.creating?
    {:noreply, assign(socket, :creating?, !creating)}
  end

  def render(assigns) do
    ~H"""
    <div>
      <.live_component module={Locations} id="list_location" locations={@portals.location} />
      <div style="margin-top: 2rem;">
        <%= if @creating? do %>
          <CreateLocation.render id="create_location" portals={@portals} />
          <button phx-click="toggle_creating">Cancel</button>
        <% else %>
          <button phx-click="toggle_creating">New</button>
        <% end %>
      </div>
    </div>
    """
  end


end

