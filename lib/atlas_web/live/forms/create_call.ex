defmodule AtlasWeb.Live.Forms.CreateCall do
  use AtlasWeb, :live_component
  alias Atlas.Customers.ServiceCall
  alias AtlasWeb.Live.Handlers.CreateCall, as: Handler

  def mount(socket) do
    cs = ServiceCall.create_changeset(%ServiceCall{location_number: 108429}, %{})
    socket = assign(socket, :changeset, cs)
    {:ok, socket}
  end

  def handle_event("change", params, socket), do: Handler.change(params, socket)
  def handle_event("submit", params, socket), do: Handler.submit(params, socket)

  def render(assigns) do
    ~H"""
    <div>
      <.form 
        phx_change="change"
        phx_submit="submit"
        phx_target={@myself}
        let={f} 
        for={@changeset}>

      <%= label f, :start_date %>
      <%= datetime_select f, :start_date, required: true %>
      <%= error_tag f, :start_date %>

      <%= label f, :end_date %>
      <%= datetime_select f, :end_date, required: true %>
      <%= error_tag f, :end_date %>

      <br />
      <%= submit "Create ServiceCall" %>

      </.form>

    </div>
    """
  end
end
