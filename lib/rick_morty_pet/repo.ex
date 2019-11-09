defmodule RickMortyPet.Repo do
  use Ecto.Repo,
    otp_app: :rick_morty_pet,
    adapter: Ecto.Adapters.Postgres
end
