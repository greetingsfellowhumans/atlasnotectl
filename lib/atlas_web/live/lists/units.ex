defmodule AtlasWeb.Live.Lists.Units do
  #use AtlasWeb, :live_component
  use AtlasWeb, :component
  alias AtlasWeb.Live.Lists.Notes

  def render(assigns) do
    tech_id = Map.get(assigns, :tech_id)
    call_id = Map.get(assigns, :call_id)
    ~H"""
    <div>
      <h1>In Progress</h1>
      <%= for {id, unit} <- @portals.unit do %>
        <%= if !is_complete?(call_id, id, @portals) do %>
          <.render_unit portals={@portals} call_id={@call_id} tech_id={@tech_id} unit={unit} />
        <% end %>
      <% end %>


      <h1>Complete</h1>
      <%= for {id, unit} <- @portals.unit do %>
        <%= if is_complete?(call_id, id, @portals) do %>
          <.render_unit portals={@portals} call_id={@call_id} tech_id={@tech_id} unit={unit} />
        <% end %>
      <% end %>
    </div>
    """
  end

  defp render_unit(assigns) do
    ~H"""
    <div>

      <%= if @call_id do %>
        <%= if has_note?(@call_id, @unit.id, @portals) do %>

          <Notes.render 
            id="list_notes" 
            unit_id={@unit.id} 
            portals={@portals} 
            call_id={@call_id} 
            tech_id={@tech_id} />

        <% else %>

          Unit #<%= @unit.unit_number %> 
          <button 
            phx-value-tech_id={@tech_id}
            phx-value-call_id={@call_id}
            phx-click={"create-unit-note:#{@unit.id}"}>Create Note</button>
          <button phx-click={"delete-unit:#{@unit.id}"}>X</button>

        <% end %>
      <% end %>

    </div>
    """
  end

  defp has_note?(call_id, unit_id, portals) do
    Enum.any?(portals.tech_note, fn {_, note} ->
      note.call_id == call_id and note.unit_id == unit_id
    end)
  end

  defp is_complete?(call_id, unit_id, portals) do
    Enum.any?(portals.tech_note, fn {_, %{complete: complete, unit_id: unit, call_id: call}} -> 
      complete == true and call == call_id and unit == unit_id
    end)
  end

end

