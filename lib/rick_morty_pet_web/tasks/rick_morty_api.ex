defmodule RickMortyPet.RickMortyAPI do
  alias RickMortyPet.RickMorty

  @url_locations "https://rickandmortyapi.com/api/location/"
  @url_characters "https://rickandmortyapi.com/api/character/"

  def import_data_from_api do
    get_all_locations()
    get_all_characters()
  end

  def get_all_locations(current_page \\ 1) do
    request = HTTPoison.get! @url_locations,[], params: %{page: Integer.to_string(current_page)}
    parsed_response = Jason.decode!(request.body)
    max_pages = parsed_response["info"]["pages"]
    locations = parsed_response["results"]
    Enum.each(locations, fn location ->
      RickMorty.insert_or_update_location_by_name(location)
    end)
    if(current_page + 1 <= max_pages) do
      get_all_locations(current_page + 1)
    end
  end

  def get_all_characters(current_page \\ 1) do
    request = HTTPoison.get! @url_characters,[], [follow_redirect: true,params: %{page: Integer.to_string(current_page)}]
    parsed_response = Jason.decode!(request.body)
    max_pages = parsed_response["info"]["pages"]
    characters = parsed_response["results"]
    Enum.each(characters, fn character ->
      RickMorty.insert_or_update_character_by_name(character)
    end)
    if(current_page + 1 <= max_pages) do
      get_all_characters(current_page + 1)
    end
  end

end
