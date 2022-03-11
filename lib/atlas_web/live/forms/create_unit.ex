defmodule AtlasWeb.Live.Forms.CreateUnit do
  use AtlasWeb, :component
  alias Atlas.Customers.Unit

  def render(assigns) do
    ~H"""
    <.form
      let={f}
      phx_submit="create_unit_submit"
      for={Unit.create_changeset(%Unit{}, %{})}>

      <%= label f, :unit_number %>
      <%= text_input f, :unit_number, required: true %>
      <%= error_tag f, :unit_number %>

      <%= submit "Create Unit" %>
    </.form>
    """
  end

  #use AtlasWeb, :live_component
  #alias Atlas.Customers.Unit
  #alias AtlasWeb.Live.Handlers.CreateUnit, as: Handler

  #def mount(socket) do
  #  cs = Unit.create_changeset(%Unit{}, %{})
  #  socket = assign(socket, :changeset, cs)
  #  {:ok, socket}
  #end

  #def handle_event("change", params, socket), do: Handler.change(params, socket)
  #def handle_event("submit", params, socket), do: Handler.submit(params, socket)

  #def render(assigns) do
  #  ~H"""
  #  <div>
  #    <.form 
  #      phx_change="change"
  #      phx_submit="submit"
  #      phx_target={@myself}
  #      let={f} 
  #      for={@changeset}>

  #    <%= label f, :unit_number %>
  #    <%= number_input f, :unit_number, required: true %>
  #    <%= error_tag f, :unit_number %>

  #    <%= label f, :location_number %>
  #    <%= text_input f, :location_number, required: true %>
  #    <%= error_tag f, :location_number %>

  #    <%= if @changeset.valid? do %>
  #      <%= submit "Create Unit" %>
  #    <% end %>

  #    </.form>

  #  </div>
  #  """
  #end
end
