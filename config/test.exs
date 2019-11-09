use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :rick_morty_pet, RickMortyPetWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :rick_morty_pet, RickMortyPet.Repo,
  username: "d0zero",
  password: "",
  database: "rick_morty_pet_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
