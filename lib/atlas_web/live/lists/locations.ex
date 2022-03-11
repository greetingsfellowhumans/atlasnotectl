defmodule AtlasWeb.Live.Lists.Locations do
  use AtlasWeb, :live_component
  alias Atlas.Customers.{Location, Unit}


  def handle_event("make_unit", %{"location_id" => loc_id_str}, socket) do
    loc_id = String.to_integer(loc_id_str)
    loc_no = socket.assigns.locations[loc_id].location_number
    src = %Sorcery.Src{
      changes_db: %{unit: %{"$sorcery:1" => %{location_number: loc_no, unit_number: "101"}}}
    }
    src_push!(src)
    {:noreply, socket}
  end

  def handle_event("inc_num", %{"location_id" => loc_id_str}, socket) do
    #locations = socket.assigns.locations
    #loc_id = String.to_integer(loc_id_str)
    #location = Enum.find(socket.assigns.locations, &(Map.get(&1, :id) == loc_id))
    #new_num = location.location_number + 1
    #cs = Location.number_changeset(location, %{location_number: new_num})
    #case Atlas.Repo.update(cs) do
    #  {:ok, loc} -> 
    #    socket = assign(socket, :locations, [loc | locations])
    #    {:noreply, socket}
    #  _ -> 
    #    {:noreply, socket}
    #end
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <%= for {_, loc} <- @locations do %>
        <div>
          <a href={"/location/#{loc.location_number}"}>
          [<%= loc.location_number %>]
          <%= loc.name %>
          </a>
          <!-- button phx-click="inc_num", phx-value-location_id={loc.id} phx-target={@myself}>Inc Number</button>
          <button phx-click="make_unit", phx-value-location_id={loc.id} phx-target={@myself}>Make Unit</button -->
        </div>
      <% end %>
    </div>
    """
  end
end

