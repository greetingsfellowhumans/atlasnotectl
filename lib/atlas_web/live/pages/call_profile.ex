defmodule AtlasWeb.Live.Pages.CallProfile do
  use AtlasWeb, :live_view
  alias Atlas.Repo
  alias Atlas.SorceryStorage
  alias Atlas.Accounts.Tech
  alias Atlas.Customers.{Location, Unit, ServiceCall, TechNote}
  alias AtlasWeb.Live.Forms.{CreateNote, CreateUnit, EditNote, EditCall}
  alias AtlasWeb.Live.Lists.{Calls, Units}
  import Atlas.Queries.Main
  use AtlasWeb.Live.Handlers.IncUnitNum
  use AtlasWeb.Live.Handlers.DeleteUnit
  use AtlasWeb.Live.Handlers.CreateNote
  use AtlasWeb.Live.Handlers.EditNote
  use AtlasWeb.Live.Handlers.EditCall
  use AtlasWeb.Live.Handlers.CreateUnit


  def mount(%{"location_number" => loc_num_str, "call_id" => call_id_str}, session, socket) do
    tech = get_current_tech!(session)
    techs = Repo.all(Tech) # This should be filtered in production. But whatevs...

    location_number = String.to_integer(loc_num_str)
    call_id = String.to_integer(call_id_str)

    call = Repo.get_by!(ServiceCall, id: call_id)
    location = Repo.get_by!(Location, location_number: location_number)
    units = all_by!(Unit, location_number: location_number)
    notes = all_by!(TechNote, call_id: call_id)

    SorceryStorage.add_entities(:tech, techs, %{})
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

    tech_portal = %{tk: :tech, guards: [{:>, :id, 0}]}
    SorceryStorage.create_portal(socket, tech_portal, %{})

    socket = assign_portals(socket)
             |> assign(:location_number, location_number)
             |> assign(:location_id, location.id)
             |> assign(:call_id, call_id)
             |> assign(:tech_id, tech.id)
             |> assign(:editing_call, false)
    

    {:ok, socket}
  end


  def render(assigns) do
    note_id = get_current_note_id(assigns)
    note = assigns.portals.tech_note[note_id]
    ~H"""
    <div>
      <%= render_top_data(assigns) %>

      <%= if !note_id do %>
        <CreateUnit.render id="create_unit" portals={@portals} call_id={@call_id} />
        <hr />
        <Units.render id="list_units" portals={@portals} tech_id={@tech_id} call_id={@call_id} />
      <% else %>
        <EditNote.render id="edit_note" note={note} tech_id={@tech_id} call_id={@call_id} portals={@portals} />
      <% end %>

    </div>
    """
  end
      #<.live_component module={Units} id="list_units" units={@portals.unit} />

  def render_top_data(assigns) do
    location = assigns.portals.location[assigns.location_id]
    #call = assigns.portals.service_call[assigns.call_id]
    ~H"""
    <div>

        <div style="display: flex; justify-content: space-between;">

          <button 
            phx-click="toggle_call_edit_mode">change fields</button>

          <% url = "/location/#{@location_number}/call/#{@call_id}/print" %>
          <%= button("View All Notes", to: url, method: :get) %>

        </div>
        <br />

      <h2><%= location.name %> </h2>




      <%= if @editing_call do %>
        <EditCall.render id="edit_call" portals={@portals} call_id={@call_id} />
      <% end %>
    </div>
    """
  end

  def get_current_note_id(assigns) do
    Enum.find(assigns.portals.tech_note, fn 
      {_, %{complete: false, tech_id: tid}} -> tid == Map.get(assigns, :tech_id)
      _ -> false
    end)
    |> case do
      {id, _} -> id
      nil -> nil
    end
  end

end
