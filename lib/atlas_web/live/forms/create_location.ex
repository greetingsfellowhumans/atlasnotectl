defmodule AtlasWeb.Live.Forms.CreateLocation do
  use AtlasWeb, :live_component
  alias Atlas.Customers.Location
  alias AtlasWeb.Live.Handlers.CreateLocation, as: Handler


  def render(assigns) do
    ~H"""
    <div>
      <.form 
        phx_submit="create_location_submit"
        let={f} 
        for={Location.create_changeset(%Location{}, %{})}>

      <%= label f, :location_number %>
      <%= number_input f, :location_number, required: true %>
      <%= error_tag f, :location_number %>

      <%= label f, :name %>
      <%= text_input f, :name, required: true %>
      <%= error_tag f, :name %>

        <%= submit "Create Location" %>

      </.form>

    </div>
    """
  end
end
