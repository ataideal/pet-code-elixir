defmodule RickMortyPetWeb.LocationController do
  use RickMortyPetWeb, :controller

  alias RickMortyPet.RickMorty
  alias RickMortyPet.RickMorty.Location

  action_fallback RickMortyPetWeb.FallbackController

  def index(conn, _params) do
    locations = RickMorty.list_locations()
    render(conn, "index.json", locations: locations)
  end

  def create(conn, %{"location" => location_params}) do
    with {:ok, %Location{} = location} <- RickMorty.create_location(location_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.location_path(conn, :show, location))
      |> render("show.json", location: location)
    end
  end

  def show(conn, %{"id" => id}) do
    location = RickMorty.get_location!(id)
    render(conn, "show.json", location: location)
  end

  def update(conn, %{"id" => id, "location" => location_params}) do
    location = RickMorty.get_location!(id)

    with {:ok, %Location{} = location} <- RickMorty.update_location(location, location_params) do
      render(conn, "show.json", location: location)
    end
  end

  def delete(conn, %{"id" => id}) do
    location = RickMorty.get_location!(id)

    with {:ok, %Location{}} <- RickMorty.delete_location(location) do
      send_resp(conn, :no_content, "")
    end
  end
end
