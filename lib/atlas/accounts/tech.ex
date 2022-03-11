defmodule Atlas.Accounts.Tech do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tech" do
    field :user_id, :id
    field :name, :string

    timestamps()
  end

  def registration_changeset(tech, attrs) do
    tech
    |> cast(attrs, [:name, :user_id])
  end

end
