defmodule AtlasWeb.Live.Lists.Notes do
  use AtlasWeb, :live_component
  #alias Atlas.Customers.{Location, Note}


  def render(assigns) do
    %{call_id: call_id, tech_id: _tech_id, unit_id: unit_id} = assigns
    notes = Enum.map(assigns.portals.tech_note, fn {_, note} -> note end)
            |> Enum.filter(fn note -> note.call_id == call_id end)
            |> Enum.filter(fn note -> note.unit_id == unit_id end)
            |> Enum.group_by(&(&1.complete))
    ~H"""
    <div>

      <%= for note <- Map.get(notes, false, []) do %>
        <div>
          <.complete_status tech_id={@tech_id} portals={@portals} unit_id={unit_id} note={note} />
        </div>
      <% end %>


      <%= for note <- Map.get(notes, true, []) do %>
        <div>
          <.complete_status tech_id={@tech_id} portals={@portals} unit_id={unit_id} note={note} />
        </div>
      <% end %>

    </div>
    """
  end

  defp complete_status(assigns) do
    unit_num = assigns.portals.unit[assigns.unit_id].unit_number
    ~H"""
    <%= if @note.complete do %>
      <div style="margin: 1rem; padding: 1rem; background-color: #AEA">
        Unit # <%= unit_num %> <.author note={@note} portals={@portals} />
        <%= if @note.tech_id == @tech_id do %>
          <button 
            phx-value-complete={"false"} 
            phx-click={"open-unit-note:#{@note.id}"}>
              Edit
          </button>
        <% end %>
          
      </div>
    <% else %>
      <div style="margin: 1rem; padding: 1rem; background-color: #EAA">
        Unit # <%= unit_num %> <.author note={@note} portals={@portals} />
      </div>
    <% end %>
    """
  end

  defp author(assigns) do
    author = assigns.portals.tech[assigns.note.tech_id]
    ~H"""
      <%= author.name %>
    """
  end

  defp content(assigns) do
    ~H"""
      <code>
        <%= if @note.note do %>
          <%= for line <- String.split(@note.note, "\n") do %>
            <p><%= line %></p>
          <% end %>
        <% end %>
      </code>
    """
  end
end

