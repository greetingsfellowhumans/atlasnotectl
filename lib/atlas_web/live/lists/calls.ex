defmodule AtlasWeb.Live.Lists.Calls do
  use AtlasWeb, :live_component
  #alias Atlas.Customers.{Location, Call}


  def render(assigns) do
    ~H"""
    <div>
      <%= for {id, call} <- @calls do %>
        <div>
          <a href={"/location/#{call.location_number}/call/#{id}"}>Open Call <%= id %></a>
        </div>
      <% end %>
    </div>
    """
  end
end

