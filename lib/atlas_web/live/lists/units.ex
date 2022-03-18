defmodule AtlasWeb.Live.Lists.Units do
  use AtlasWeb, :component
  alias AtlasWeb.Live.Lists.Notes

  def render(assigns) do
    ~H"""
    <div>
      <.render_pending portals={@portals} call_id={@call_id} tech_id={@tech_id} />
      <.render_complete portals={@portals} call_id={@call_id} tech_id={@tech_id} />
    </div>
    """
  end

  ### PENDING ####
  defp render_pending(assigns) do
    ~H"""
      <% pending_units = units_in_progress(assigns) %>
      <%= if !Enum.empty?(pending_units) do %>
        <h1>In Progress</h1>
        <%= for unit <- sort_units(pending_units) do %>
          <.render_unit portals={@portals} call_id={@call_id} tech_id={@tech_id} unit={unit} />
        <% end %>
      <% end %>
    """
  end

  defp units_in_progress(%{call_id: call_id, portals: portals}) do
    Enum.reduce(portals.unit, [], fn {id, unit}, acc -> 
      if !is_complete?(call_id, id, portals), do: [unit | acc], else: acc
    end)
  end
  ################
  
  defp sort_units(units) do
    Enum.sort_by(units, fn c ->
      case Integer.parse(c.unit_number) do
        {int, _} -> int
        _ -> 0
      end
    end)
  end
  
  ### COMPLETED ###
  defp render_complete(assigns) do
    ~H"""
      <% completed_units = units_not_in_progress(assigns) %>
      <%= if !Enum.empty?(completed_units) do %>
        <hr />
        <h1>Complete</h1>
        <%= for unit <- sort_units(completed_units) do %>
          <.render_unit portals={@portals} call_id={@call_id} tech_id={@tech_id} unit={unit} />
        <% end %>
      <% end %>
    """
  end

  defp units_not_in_progress(%{call_id: call_id, portals: portals}) do
    Enum.reduce(portals.unit, [], fn {id, unit}, acc -> 
      if is_complete?(call_id, id, portals), do: [unit | acc], else: acc
    end)
  end
  ##################



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

          Unit #<%= @unit.unit_number %><br /> 
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

