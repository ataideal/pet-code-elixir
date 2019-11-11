defmodule RickMortyPet.Repo.Migrations.AddExternalIdToCharacter do
  use Ecto.Migration

  def change do
    alter table("characters") do
      add :external_id, :integer
    end
  end
end
