defmodule RickMortyPet.RickMorty do
  @moduledoc """
  The RickMorty context.
  """

  import Ecto.Query, warn: false
  alias RickMortyPet.Repo

  alias RickMortyPet.RickMorty.Character

  def list_characters do
    Repo.all(Character |> order_by(asc: :id))
    |> Repo.preload(:origin)
  end

  def get_character!(id), do: Repo.get!(Character, id)

  def create_character(attrs \\ %{}) do
    %Character{}
    |> Character.changeset(attrs)
    |> Repo.insert()
  end

  def update_character(%Character{} = character, attrs) do
    character
    |> Character.changeset(attrs)
    |> Repo.update()
  end

  def delete_character(%Character{} = character) do
    Repo.delete(character)
  end

  def change_character(%Character{} = character) do
    Character.changeset(character, %{})
  end

  def find_character_by_name(name) do
    case Repo.get_by(Character, name: name) |> Repo.preload(:origin) do
      %Character{} = character -> character
      nil -> nil
    end
  end

  def insert_or_update_character_by_name(character_params) do
    case find_character_by_name(character_params["name"]) do
        %Character{} = character ->
          update_character(character,%{type: character_params["type"],
                                      status: character_params["status"],
                                      gender: character_params["gender"],
                                      origin: %{name: character_params["origin"]["name"]},
                                      species: character_params["species"]})
        nil -> create_character(%{name: character_params["name"],
                                    type: character_params["type"],
                                    status: character_params["status"],
                                    gender: character_params["gender"],
                                    origin: %{name: character_params["origin"]["name"]},
                                    species: character_params["species"]})
    end
  end

  alias RickMortyPet.RickMorty.Location

  def list_locations do
    Repo.all(Location)
  end

  def get_location!(id), do: Repo.get!(Location, id)

  def create_location(attrs \\ %{}) do
    %Location{}
    |> Location.changeset(attrs)
    |> Repo.insert()
  end

  def update_location(%Location{} = location, attrs) do
    location
    |> Location.changeset(attrs)
    |> Repo.update()
  end

  def delete_location(%Location{} = location) do
    Repo.delete(location)
  end

  def change_location(%Location{} = location) do
    Location.changeset(location, %{})
  end

  def find_location_by_name(name) do
    case Repo.get_by(Location, name: name) do
      %Location{} = location -> location
      nil -> nil
    end
  end

  def insert_or_update_location_by_name(location_params) do
    case find_location_by_name(location_params["name"]) do
        %Location{} = location -> update_location(location,%{type: location_params["type"],
                                     dimension: location_params["dimension"]})
        nil -> create_location(%{name: location_params["name"],
                                 type: location_params["type"],
                                 dimension: location_params["dimension"]})
    end
  end

end
