defmodule Atlas.Repo.Migrations.Techs do
  use Ecto.Migration

  def change do

    create table(:tech) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :name, :string, null: false
    timestamps()
    end

    create index(:tech, [:user_id])
    create unique_index(:tech, [:name])

  end
end
