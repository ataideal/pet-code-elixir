defmodule RickMortyPetWeb.LocationView do
  use RickMortyPetWeb, :view
  alias RickMortyPetWeb.LocationView

  def render("index.json", %{locations: locations}) do
    render_many(locations, LocationView, "location.json")
  end

  def render("show.json", %{location: location}) do
    render_one(location, LocationView, "location.json")
  end

  def render("location.json", %{location: location}) do
    %{id: location.id,
      name: location.name,
      type: location.type,
      dimension: location.dimension}
  end
end
