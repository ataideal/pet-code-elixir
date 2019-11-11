defmodule RickMortyPet.Repo.Migrations.AddOriginLocationToCharacter do
  use Ecto.Migration

  def change do
    alter table("characters") do
      add :origin_id, references(:locations)
    end
  end
end
