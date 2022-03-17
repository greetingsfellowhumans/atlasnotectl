defmodule Atlas.Repo.Migrations.Call do
  use Ecto.Migration

  def change do
    create table(:service_call) do
      add :location_number, references(:location, on_delete: :delete_all, column: :location_number), null: false
      add :start_date, :naive_datetime, null: false
      add :end_date, :naive_datetime, null: false

      # Whether these forms should appear when you fill out a note
      add :num_roaches_seen,     :boolean, default: false
      add :num_roaches_reported, :boolean, default: false
      add :num_mice_seen,        :boolean, default: false
      add :num_mice_reported,    :boolean, default: false
      add :num_ants_seen,        :boolean, default: false
      add :num_ants_reported,    :boolean, default: false
      add :num_flies_seen,       :boolean, default: false
      add :num_flies_reported,   :boolean, default: false
      add :sanitation,           :boolean, default: false
      add :clutter,              :boolean, default: false
      add :trap_locations,       :boolean, default: false
      add :feeding,              :boolean, default: false
      add :refusal,              :boolean, default: true
      add :access,               :boolean, default: true
      add :note,                 :boolean, default: true

    end
    create index(:service_call, [:location_number])


    create table(:service_instruction) do
      add :call_id, references(:service_call, on_delete: :delete_all), null: false
      add :type, :text
      add :description, :text
    end
    create index(:service_instruction, [:call_id])

    create table(:tech_note) do
      add :call_id, references(:service_call, on_delete: :delete_all), null: false
      add :tech_id, references(:tech, on_delete: :nothing), null: true
      add :unit_id, references(:unit, on_delete: :delete_all), null: true
      add :complete,             :boolean, default: false

      add :num_roaches_seen,     :text, default: nil
      add :num_roaches_reported, :text, default: nil
      add :num_mice_seen,        :text, default: nil
      add :num_mice_reported,    :text, default: nil
      add :num_ants_seen,        :text, default: nil
      add :num_ants_reported,    :text, default: nil
      add :num_flies_seen,       :text, default: nil
      add :num_flies_reported,   :text, default: nil
      add :clutter,              :text, default: nil
      add :sanitation,           :text, default: nil
      add :trap_locations,       :text, default: nil
      add :feeding,              :text, default: nil
      add :refusal,              :boolean, default: false
      add :access,               :boolean, default: true
      add :note,                 :text, default: nil

      timestamps()
    end
  end


end
