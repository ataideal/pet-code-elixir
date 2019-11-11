defmodule RickMortyPetWeb.Router do
  use RickMortyPetWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", RickMortyPetWeb do
    pipe_through :api
    get "/characters/ranking", CharacterController, :ranking
    resources "/characters", CharacterController, except: [:new, :edit]
    resources "/locations", LocationController, except: [:new, :edit]
  end
end
