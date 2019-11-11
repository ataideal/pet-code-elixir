defmodule RickMortyPet.Repo.Migrations.CreateLocations do
  use Ecto.Migration

  def change do
    create table(:locations) do
      add :name, :string
      add :type, :string
      add :dimension, :string

      timestamps()
    end

  end
end
