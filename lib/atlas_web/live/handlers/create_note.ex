defmodule AtlasWeb.Live.Handlers.CreateNote do
  alias Atlas.Repo
  alias Atlas.Customers.TechNote, as: Note
  #import Phoenix.LiveView, only: [assign: 3]

  use AtlasWeb, :live_view


  defmacro __using__(_) do
    quote do

      def handle_event("create-unit-note:" <> id_str, params, socket) do
        unit_id = String.to_integer(id_str)
        tech_id = String.to_integer(params["tech_id"])
        call_id = String.to_integer(params["call_id"])

        src = %Sorcery.Src{
          changes_db: %{tech_note: %{"$sorcery:1" => %{
            call_id: call_id,
            unit_id: unit_id,
            tech_id: tech_id
          }}}
        }

        src_push!(src)

        {:noreply, socket}
      end

    end
  end

end
