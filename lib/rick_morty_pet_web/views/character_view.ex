defmodule RickMortyPetWeb.CharacterView do
  use RickMortyPetWeb, :view
  alias RickMortyPetWeb.CharacterView

  def render("index.json", %{characters: characters}) do
    render_many(characters, CharacterView, "character.json")
  end

  def render("show.json", %{character: character}) do
    render_one(character, CharacterView, "character.json")
  end

  def render("character.json", %{character: character}) do
    %{id: character.id,
      name: character.name,
      status: character.status,
      species: character.species,
      type: character.type,
      gender: character.gender,
      picture: RickMortyPet.RickMorty.Character.picture_url(character)
    }
  end
end
