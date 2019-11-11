defmodule RickMortyPetWeb.CharacterController do
  use RickMortyPetWeb, :controller

  alias RickMortyPet.RickMorty
  alias RickMortyPet.RickMorty.Character

  action_fallback RickMortyPetWeb.FallbackController

  def index(conn, params) do
    characters = RickMorty.list_characters(params)
    render(conn, "index.json", characters: characters)
  end

  def ranking(conn, _params) do
    ranking = RickMorty.generate_dopplegangers_ranking
    json(conn,ranking)
  end

  def create(conn, %{"character" => character_params}) do
    with {:ok, %Character{} = character} <- RickMorty.create_character(character_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.character_path(conn, :show, character))
      |> render("show.json", character: RickMorty.preload_character_assoc(character))
    end
  end

  def show(conn, %{"id" => id}) do
    character = RickMorty.get_character!(id)
    render(conn, "show.json", character: character)
  end

  def update(conn, %{"id" => id, "character" => character_params}) do
    character = RickMorty.get_character!(id)

    with {:ok, %Character{} = character} <- RickMorty.update_character(character, character_params) do
      render(conn, "show.json", character: character)
    end
  end

  def delete(conn, %{"id" => id}) do
    character = RickMorty.get_character!(id)

    with {:ok, %Character{}} <- RickMorty.delete_character(character) do
      send_resp(conn, :no_content, "")
    end
  end
end
