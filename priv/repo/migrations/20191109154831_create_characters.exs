defmodule RickMortyPet.Repo.Migrations.CreateCharacters do
  use Ecto.Migration

  def change do
    create table(:characters) do
      add :name, :string
      add :status, :string
      add :species, :string
      add :type, :string
      add :gender, :string

      timestamps()
    end

  end
end
