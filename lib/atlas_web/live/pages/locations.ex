defmodule AtlasWeb.Live.Pages.Locations do
  use AtlasWeb, :live_view
  alias Atlas.Repo
  alias Atlas.SorceryStorage
  alias Atlas.Customers.{Location, Unit}
  alias AtlasWeb.Live.Forms.{CreateLocation, CreateUnit}
  alias AtlasWeb.Live.Lists.{Locations, Units}
  alias Sorcery.Src
  import Interceptors.IncUnit


  def mount(_params, _session, socket) do
    locations = Repo.all(Location)
    SorceryStorage.add_entities(:location, locations, %{})
    portal = %{tk: :location, guards: [{:==, :id, 1}], indices: [:location_number]}
    loc_portal_ref = SorceryStorage.create_portal(socket, portal, %{})
    socket = assign_portals(socket)
    
    {:ok, socket}
  end


  def render(assigns) do
    ~H"""
    <div>
      <.live_component module={Locations} id="list_location" locations={@portals.location} />
    </div>
    """
  end


end
