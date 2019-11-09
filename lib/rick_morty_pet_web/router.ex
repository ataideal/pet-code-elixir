defmodule RickMortyPetWeb.Router do
  use RickMortyPetWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", RickMortyPetWeb do
    pipe_through :api
  end
end
