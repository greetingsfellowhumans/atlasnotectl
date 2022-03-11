defmodule AtlasWeb.Live.Handlers.EditNote do
  alias Atlas.Repo
  alias Atlas.Customers.TechNote, as: Note
  #import Phoenix.LiveView, only: [assign: 3]



  defmacro __using__(_) do
    quote do

      def handle_event("delete-note:" <> note_id_str, _params, socket) do
        note_id = String.to_integer(note_id_str)
        src = %Sorcery.Src{
          deletes: [{:tech_note, note_id}]
        }

        src_push!(src)

        {:noreply, socket}
      end
      def handle_event("open-unit-note:" <> note_id_str, params, socket) do
        note_id = String.to_integer(note_id_str)
        old_note = socket.assigns.portals.tech_note[note_id]
        note = Map.put(old_note, :complete, false)
        src = %Sorcery.Src{
          changes_db: %{tech_note: %{note_id => note }}
        }

        src_push!(src)

        {:noreply, socket}
      end

      def handle_event("edit-unit-note:" <> note_id_str, params, socket) do
        note_id = String.to_integer(note_id_str)
        old_note = socket.assigns.portals.tech_note[note_id]

        note = params["tech_note"]
               |> Map.put("complete", true)
               |> Map.put("call_id", old_note.call_id)
               |> Map.put("unit_id", old_note.unit_id)
               |> Map.put("tech_id", old_note.tech_id)


        src = %Sorcery.Src{
          original_db: %{tech_note: %{note_id => old_note }},
          changes_db: %{tech_note: %{note_id => note }}
        }

        src_push!(src)

        {:noreply, socket}
      end

    end
  end

end
