defmodule AtlasWeb.Live.SandboxLive do
  use AtlasWeb, :live_view
  alias Atlas.Repo
  alias Atlas.SorceryStorage
  alias Atlas.Customers.{Location, Unit}
  alias AtlasWeb.Live.Forms.{CreateLocation, CreateUnit}
  alias AtlasWeb.Live.Lists.{Locations, Units}
  alias Sorcery.Src
  import Interceptors.IncUnit


  def mount(_params, session, socket) do
    locations = Repo.all(Location)
    units = Repo.all(Unit)
    SorceryStorage.add_entities(:location, locations, %{})
    SorceryStorage.add_entities(:unit, units, %{})

    portal = %{tk: :location, guards: [{:==, :id, 1}], indices: [:location_number]}
    loc_portal_ref = SorceryStorage.create_portal(socket, portal, %{})

    unit_guard = %{tk: :unit, guards: [{:in, :location_number, {loc_portal_ref, :location_number}}]}
    unit_portal_ref = SorceryStorage.create_portal(socket, unit_guard, %{})

    socket = assign_portals(socket)
    
    {:ok, socket}
  end


  def handle_event("inc-unit-number:" <> id_str, _, socket) do
    id = String.to_integer(id_str)

    src = Src.new(socket.assigns.portals, %{unit_id: id})
          |> inc_unit()

    #SorceryStorage.push_src!(src)
    src_push!(src)

    {:noreply, socket}
  end
  def handle_event("delete-unit:" <> id_str, _, socket) do
    id = String.to_integer(id_str)

    src = %Sorcery.Src{
      deletes: [unit: id]
    }

    #SorceryStorage.push_src!(src)
    src_push!(src)

    {:noreply, socket}
  end


  def render(assigns) do
    ~H"""
    <div>
      ya
      <.live_component module={Locations} id="list_location" locations={@portals.location} />
      <.live_component module={Units} id="list_units" units={@portals.unit} />
      <.live_component module={CreateLocation} id="create_location" />
      <.live_component module={CreateUnit} id="create_unit" />
    </div>
    """
  end


end
