defmodule RickMortyPet.RickMortyAPI do
  alias RickMortyPet.RickMorty

  @url_locations "https://rickandmortyapi.com/api/location/"
  @url_characters "https://rickandmortyapi.com/api/character/"

  def import_data_from_api do
    get_all_locations()
    get_all_characters()
    :ok
  end

  def get_all_locations(current_page \\ 1) do
    IO.puts "Start to fetching locations from api page #{current_page}"
    request = HTTPoison.get! @url_locations,[], params: %{page: Integer.to_string(current_page)}
    parsed_response = Jason.decode!(request.body)
    max_pages = parsed_response["info"]["pages"]
    locations = parsed_response["results"]
    Enum.each(locations, fn location ->
      RickMorty.insert_or_update_location_by_external_id(location)
    end)
    if(current_page + 1 <= max_pages) do
      get_all_locations(current_page + 1)
    end
  end

  def get_all_characters(current_page \\ 1) do
    IO.puts "Start to fetching characters from api page #{current_page}"
    request = HTTPoison.get! @url_characters,[], [follow_redirect: true,params: %{page: Integer.to_string(current_page)}]
    parsed_response = Jason.decode!(request.body)
    max_pages = parsed_response["info"]["pages"]
    characters = parsed_response["results"]
    Enum.each(characters, fn character ->
      RickMorty.insert_or_update_character_by_external_id(character)
    end)
    if(current_page + 1 <= max_pages) do
      get_all_characters(current_page + 1)
    end
  end

  def verify_if_database_is_empty_and_fetch_data do
    with [] <- RickMorty.list_characters do
      import_data_from_api()
    end
  end

end
