defmodule AtlasWeb.Live.Forms.CreateLocation do
  use AtlasWeb, :live_component
  alias Atlas.Customers.Location
  alias AtlasWeb.Live.Handlers.CreateLocation, as: Handler

  def mount(socket) do
    cs = Location.create_changeset(%Location{}, %{})
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

      <%= label f, :location_number %>
      <%= number_input f, :location_number, required: true %>
      <%= error_tag f, :location_number %>

      <%= label f, :name %>
      <%= text_input f, :name, required: true %>
      <%= error_tag f, :name %>

      <%= if @changeset.valid? do %>
        <%= submit "Create Location" %>
      <% end %>

      </.form>

    </div>
    """
  end
end
