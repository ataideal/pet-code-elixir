defmodule RickMortyPet.Repo.Migrations.AddPictureToCharacter do
  use Ecto.Migration

  def change do
    alter table("characters") do
      add :picture, :string
    end
  end
end
