defmodule AtlasWeb.Live.Forms.EditCall do
  use AtlasWeb, :component
  alias Atlas.Customers.ServiceCall, as: Call

  @moduledoc """
  This is the list of checkboxes determining what form items you want to fill out in each unit.

  This is NOT the form for filling out those items. You want EditNote
  """

  @keys  [:note,
          :trap_locations,
          :num_roaches_reported, 
          :num_roaches_seen, 
          :num_mice_seen, 
          :num_mice_reported, 
          :num_ants_seen, 
          :num_ants_reported, 
          :sanitation, 
          :feeding]

  defp click(call), do: "toggle_call_key:#{call.id}"

  def render(%{call_id: call_id, portals: portals} = assigns) do
    call = struct(Call, portals.service_call[call_id])
    keys = @keys
    ~H"""
    <.form
      let={f}
      phx_change={click(call)}
      for={Call.sorcery_update(call, %{})}>

    <%= for k <- keys do %>

      <%= label f, k %>
      <%= checkbox f, k %>
      <%= error_tag f, k %>

    <% end %>

    </.form>
    """
  end
end
