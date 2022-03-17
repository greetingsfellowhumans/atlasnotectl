defmodule AtlasWeb.Live.Handlers.CreateLocation do
  alias Sorcery.Src
  alias Atlas.Repo
  alias Atlas.Customers.Location

  defmacro __using__(_) do
    quote do
      def handle_event("create_location_submit", %{"location" => location}, socket) do
        src = %Sorcery.Src{
          changes_db: %{
            location: %{
              "$sorcery:location:1" => location
            }
          }
        }

        src_push!(src)

        {:noreply, socket}
      end


    end
  end

end
