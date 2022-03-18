defmodule AtlasWeb.Live.Pages.Print do
  use AtlasWeb, :live_view
  alias Atlas.Repo
  alias Atlas.SorceryStorage
  alias Atlas.Customers.{Location, Unit, ServiceCall, TechNote}
  import Atlas.Queries.Main
  use AtlasWeb.Live.Handlers.IncUnitNum
  use AtlasWeb.Live.Handlers.DeleteUnit
  use AtlasWeb.Live.Handlers.CreateNote
  use AtlasWeb.Live.Handlers.EditNote
  use AtlasWeb.Live.Handlers.EditCall
  use AtlasWeb.Live.Handlers.CreateUnit


  def mount(%{"location_number" => loc_num_str, "call_id" => call_id_str}, session, socket) do
    tech = get_current_tech!(session)

    location_number = String.to_integer(loc_num_str)
    call_id = String.to_integer(call_id_str)

    call = Repo.get_by!(ServiceCall, id: call_id)
    location = Repo.get_by!(Location, location_number: location_number)
    units = all_by!(Unit, location_number: location_number)
    notes = all_by!(TechNote, call_id: call_id)

    SorceryStorage.add_entities(:tech, [tech], %{})
    SorceryStorage.add_entities(:location, [location], %{})
    SorceryStorage.add_entities(:service_call, [call], %{})
    SorceryStorage.add_entities(:unit, units, %{})
    SorceryStorage.add_entities(:tech_note, notes, %{})

    portal = %{tk: :location, guards: [{:==, :location_number, location_number}], indices: [:location_number]}
    loc_portal_ref = SorceryStorage.create_portal(socket, portal, %{})

    unit_portal = %{tk: :unit, guards: [{:in, :location_number, {loc_portal_ref, :location_number}}]}
    SorceryStorage.create_portal(socket, unit_portal, %{})

    call_portal = %{tk: :service_call, guards: [{:==, :id, call_id}]}
    call_portal_ref = SorceryStorage.create_portal(socket, call_portal, %{})

    notes_portal = %{tk: :tech_note, guards: [{:in, :call_id, {call_portal_ref, :id}}]}
    SorceryStorage.create_portal(socket, notes_portal, %{})

    tech_portal = %{tk: :tech, guards: [{:==, :id, tech.id}]}
    SorceryStorage.create_portal(socket, tech_portal, %{})

    socket = assign_portals(socket)
             |> assign(:location_number, location_number)
             |> assign(:location_id, location.id)
             |> assign(:call_id, call_id)
             |> assign(:tech_id, tech.id)
             |> assign(:editing_call, false)
    

    {:ok, socket}
  end

  defp get_label(:num_roaches_seen), do: "Roaches Seen"
  defp get_label(:num_roaches_reported), do: "Roaches Reported"
  defp get_label(:num_mice_seen), do: "Mice Seen"
  defp get_label(:num_mice_reported), do: "Mice Reported"
  defp get_label(:num_flies_seen), do: "Flies Seen"
  defp get_label(:num_flies_reported), do: "Flies Reported"
  defp get_label(:num_ants_seen), do: "Ants Seen"
  defp get_label(:num_ants_reported), do: "Ants Reported"
  defp get_label(:sanitation), do: "Sanitation"
  defp get_label(:clutter), do: "Clutter"
  defp get_label(:trap_locations), do: "Trap Locations"
  defp get_label(:feeding), do: "Feeding"
  defp get_label(:refusal), do: "Refusal"
  defp get_label(:access), do: "Access"
  defp get_label(_), do: ""

  defp sort_units(units) do
    Enum.sort_by(units, fn {_, c} ->
      {int, _} = Integer.parse(c.unit_number)
      int
    end)
  end

  def render(assigns) do
    ~H"""
    <div>
      <%= for {_, unit} <- sort_units(@portals.unit) do %>
        <.render_unit portals={@portals} unit={unit} call_id={@call_id} />
      <% end %>
    </div>
    """
  end

  defp klist(call), do: Enum.filter(
  [:num_roaches_seen, :num_roaches_reported, :num_mice_seen, :num_mice_reported, :num_ants_seen, :num_ants_reported,
    :num_flies_seen, :num_flies_reported,
    :sanitation, :clutter, :trap_locations, :feeding], 
    fn k -> Map.get(call, k)
  end)

  defp render_unit(assigns) do
    call = assigns.portals.service_call[assigns.call_id]
    notes = Enum.reduce(assigns.portals.tech_note, [], fn {_, %{call_id: call_id, unit_id: unit_id} = note}, acc -> 
      if call_id == assigns.call_id and unit_id == assigns.unit.id do
        [note | acc]
      else
        acc
      end
    end)
    if Enum.empty?(notes) do
    ~H"""
    """
    else
    ~H"""
      <div>
      <span>Unit # <%= @unit.unit_number %></span><br />
      <%= for note <- notes do %>
        <%= cond do %>
          <% note.refusal -> %>
            Refusal<br />
          <% !note.access -> %>
            No Access<br />
            <% true -> %>
              <%= for k <- klist(call) do %>
                <.render_key note={note} k={k} />
              <% end %>
              <.render_note note={note} />
        <% end %>

      <% end %>
      <br />
      </div>
    """
    end
  end


  defp render_note(assigns) do
    ~H"""
      <.render_notetxt note={@note} />
    """
  end

  defp render_key(assigns) do
    ~H"""
      <% v = Map.get(@note, @k, "") %>
      <%= if v not in ["", nil]  do %>
        <%= get_label(@k) %>: <%= v %><br />
      <% end %>
    """
  end

  defp render_notetxt(assigns) do
    ~H"""
      <%= if @note.note do %>
        <%= for line <- String.split(@note.note, "\n") do %>
          <p><%= line %></p>
        <% end %>
      <% end %>
    """
  end
end

