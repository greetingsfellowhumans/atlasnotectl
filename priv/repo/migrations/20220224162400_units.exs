defmodule Atlas.Repo.Migrations.Units do
  use Ecto.Migration

  def change do

    create table(:unit) do
      add :location_number, references(:location, on_delete: :delete_all, column: :location_number), null: false
      add :unit_number, :string, null: false # String because it could be "14B" or "TH" or something
    end
    create index(:unit, [:location_number])


  end
end
