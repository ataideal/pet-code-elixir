defmodule RickMortyPet.RickMorty do
  @moduledoc """
  The RickMorty context.
  """

  import Ecto.Query, warn: false
  alias RickMortyPet.Repo

  alias RickMortyPet.RickMorty.Character
  alias RickMortyPet.RickMorty.Location

  def list_characters do
    Repo.all(Character |> order_by(asc: :id))
    |> Repo.preload(:origin)
  end

  def list_characters(params) do
    query = from c in Character,
            select: c,
            order_by: [asc: ^filter_order_by(params["order"])]

    query = query |> filter_sort_by(params["sort"])

    query = case Map.fetch(params,"name") do
      {:ok,param} -> from c in query, where: like(c.name, ^("%#{param}%"))
      :error -> query
    end
    Repo.all(query)
    |> Repo.preload(:origin)
  end

  def filter_order_by(param) do
    case param do
      "name" -> :name
      "id" -> :id
      "status" -> :status
      "gender" -> :gender
      _ -> :name
    end
  end

  def filter_sort_by(query, param) do
    case param do
      "desc" -> reverse_order(query)
      _ -> query
    end
  end

  def get_character!(id), do: Repo.get!(Character, id) |> Repo.preload(:origin)

  def create_character(attrs \\ %{}) do
    %Character{}
    |> Character.changeset(attrs)
    |> Repo.insert()
  end

  def preload_character_assoc(character) do
    character
    |> Repo.preload(:origin)
  end

  def update_character(%Character{} = character, attrs) do
    character
    |> Character.changeset(attrs)
    |> Repo.update()
    |> case do
        {:ok, character} -> {:ok, Repo.preload(character, :origin)}
        error -> error
      end
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

  def find_character_by_external_id(id) do
    case Repo.get_by(Character, external_id: id) |> Repo.preload(:origin) do
      %Character{} = character -> character
      nil -> nil
    end
  end

  def insert_or_update_character_by_external_id(character_params) do
    case find_character_by_external_id(character_params["id"]) do
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
                                    external_id: character_params["id"],
                                    picture: character_params["image"],
                                    origin: %{name: character_params["origin"]["name"]},
                                    species: character_params["species"]})
    end
  end

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

  def find_location_by_external_id(id) do
    case Repo.get_by(Location, external_id: id) do
      %Location{} = location -> location
      nil -> nil
    end
  end

  def insert_or_update_location_by_external_id(location_params) do
    case find_location_by_external_id(location_params["id"]) do
        %Location{} = location -> update_location(location,%{type: location_params["type"],
                                     external_id: location_params["id"],
                                     dimension: location_params["dimension"]})
        nil -> create_location(%{name: location_params["name"],
                                 type: location_params["type"],
                                 external_id: location_params["id"],
                                 dimension: location_params["dimension"]})
    end
  end

  def find_location_by_name(name) do
    case Repo.get_by(Location, name: name) do
      %Location{} = location -> location
      nil -> nil
    end
  end

  def find_locations_by_dimension(dimension) do
    query = from l in Location,
            where: l.dimension in ^dimension
    Repo.all(query)
  end

  def generate_dopplegangers_ranking do
    original_locations = find_locations_by_dimension(["Dimension C-137","Replacement Dimension"])
    original_locations_ids = Enum.map(original_locations, &(&1.id))

    query = from c in Character,
            where: c.origin_id in ^original_locations_ids,
            order_by: [asc: :id],
            select: [:id,:name,:picture]
    original_characters = Repo.all(query)
    Enum.uniq_by(original_characters, &(get_first_name(&1.name)))
    |> Enum.map(fn char ->
      first_name = get_first_name(char.name)
      IO.inspect first_name
      dimension_count_query = from ch in Character,
                              where: like(ch.name, ^("%#{first_name}%")),
                              select: count()
      dimension_count = Repo.one(dimension_count_query)
      %{
        dimension_count: dimension_count,
        name: first_name,
        image: Character.picture_url(char)
      }
    end)
    |> Enum.sort(&(&1.dimension_count >= &2.dimension_count))
  end

  defp get_first_name(name) do
    name
    |> String.replace_prefix("Mr. ", "")
    |> String.replace_prefix("Mrs. ", "")
    |> String.split
    |> List.first
    |> String.replace_suffix("'s", "")
  end
end
