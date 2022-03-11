defmodule AtlasWeb.Live.Forms.EditNote do
  use AtlasWeb, :component
  alias Atlas.Customers.TechNote, as: Note


  def render(assigns) do
    note = struct(Note, assigns.note)
    call = assigns.portals.service_call[assigns.call_id]
    ~H"""
    <div>
      <.form 
        for={Note.create_changeset(note, %{})}
        let={f} 
        phx_submit={"edit-unit-note:#{@note.id}"}>

      <%= label f, :refusal %>
      <%= checkbox f, :refusal %>
      <%= error_tag f, :refusal %>

      <%= for k <- [:note, :trap_locations] do %>
        <%= if Map.get(call, k) do %>
          <%= label f, k %>
          <%= textarea f, k %>
          <%= error_tag f, k %>
        <% end %>

      <% end %>



      <%= for k <- [:num_roaches_reported, 
                    :num_roaches_seen, 
                    :num_mice_seen, 
                    :num_mice_reported, 
                    :num_ants_seen, 
                    :num_ants_reported, 
                    :sanitation, 
                    :feeding] do %>

        <%= if Map.get(call, k) do %>
          <%= label f, k %>
          <%= text_input f, k %>
          <%= error_tag f, k %>
        <% end %>

      <% end %>


      <%= submit "Save Note" %>

      </.form>

      <button phx-click={"delete-note:#{@note.id}"}>Delete</button>
    </div>
    """
  end
end
