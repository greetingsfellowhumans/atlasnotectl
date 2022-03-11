defmodule Atlas.Repo.Migrations.Locations do
  use Ecto.Migration

  def change do

    create table(:location) do
      add :location_number, :integer, null: false
      add :name, :string, null: false
    end

    create unique_index(:location, [:location_number])

  end
end
