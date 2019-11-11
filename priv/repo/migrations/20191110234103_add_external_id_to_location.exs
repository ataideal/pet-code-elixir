defmodule RickMortyPet.Repo.Migrations.AddExternalIdToLocation do
  use Ecto.Migration

  def change do
    alter table("locations") do
      add :external_id, :integer
    end
  end
end
