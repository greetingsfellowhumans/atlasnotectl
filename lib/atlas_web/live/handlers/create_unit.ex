defmodule AtlasWeb.Live.Handlers.CreateUnit do


  defmacro __using__(_) do
    quote do
      def handle_event("create_unit_submit", %{"unit" => %{"unit_number" => unit_number}}, socket) do
        location_number = socket.assigns.location_number
        src = %Sorcery.Src{
          changes_db: %{
            unit: %{
              "$sorcery:unit:1" => %{
                unit_number: unit_number,
                location_number: location_number
              }
            }
          }
        }

        src_push!(src)

        {:noreply, socket}
      end


    end
  end

end
