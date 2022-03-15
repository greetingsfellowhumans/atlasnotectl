defmodule AtlasWeb.Live.Pages.LocationProfile do
  use AtlasWeb, :live_view
  alias Atlas.Repo
  alias Atlas.SorceryStorage
  alias Atlas.Customers.{Location, Unit, ServiceCall}
  alias AtlasWeb.Live.Forms.{CreateCall}
  alias AtlasWeb.Live.Lists.{Calls}
  import Atlas.Queries.Main
  #alias Sorcery.Src
  #import Interceptors.IncUnit


  def mount(%{"location_number" => loc_num_str}, _session, socket) do
    location_number = String.to_integer(loc_num_str)
    #locations = Repo.all(Location)
    location = Repo.get_by!(Location, location_number: location_number)
    calls = all_by!(ServiceCall, location_number: location_number)
    units = Repo.all(Unit)

    SorceryStorage.add_entities(:location, [location], %{})
    SorceryStorage.add_entities(:service_call, calls, %{})
    SorceryStorage.add_entities(:unit, units, %{})

    portal = %{tk: :location, guards: [{:==, :location_number, location_number}], indices: [:location_number]}
    loc_portal_ref = SorceryStorage.create_portal(socket, portal, %{})

    unit_portal = %{tk: :unit, guards: [{:in, :location_number, {loc_portal_ref, :location_number}}]}
    SorceryStorage.create_portal(socket, unit_portal, %{})

    call_portal = %{tk: :service_call, guards: [{:in, :location_number, {loc_portal_ref, :location_number}}]}
    SorceryStorage.create_portal(socket, call_portal, %{})

    socket = assign_portals(socket)
             |> assign(:location_number, location_number)
             |> assign(:location_id, location.id)
    

    {:ok, socket}
  end


  def render(assigns) do
    ~H"""
    <div>
      <%= render_top_data(assigns) %>

      <.live_component module={Calls} id="list_calls" calls={@portals.service_call} />
      <.live_component module={CreateCall} location_number={@location_number} id="create_call" />
    </div>
    """
  end

  def render_top_data(assigns) do
    location = assigns.portals.location[assigns.location_id]
    ~H"""
    <div>
      <%= location.name %>
    </div>
    """
  end

end
