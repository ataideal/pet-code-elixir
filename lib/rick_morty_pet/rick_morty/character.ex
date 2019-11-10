defmodule RickMortyPet.RickMorty.Character do
  use Ecto.Schema
  import Ecto.Changeset
  use Arc.Ecto.Schema
  alias RickMortyPet.RickMorty.Location

  schema "characters" do
    field :gender, :string
    field :name, :string
    field :species, :string
    field :status, :string
    field :type, :string
    field :picture,  RickMortyPet.Picture.Type
    belongs_to :origin, Location, foreign_key: :origin_id, on_replace: :nilify

    timestamps()
  end

  @doc false
  def changeset(character, attrs) do
    character
    |> cast(attrs, [:name, :status, :species, :type, :gender])
    |> cast_attachments(attrs, [:picture], allow_paths: true)
    |> find_or_create_origin(attrs[:origin])
    |> validate_required([:name, :status, :species, :gender])
  end

  def picture_url(character) do
    RickMortyPet.Picture.url({character.picture, character})
  end

  def find_or_create_origin(changeset, origin) do
    if(!is_nil(origin[:name])) do
      case RickMortyPet.RickMorty.find_location_by_name(origin[:name]) do
        %Location{} = origin -> changeset
                                |> put_assoc(:origin, origin)
        nil -> changeset
               |> cast_assoc(:origin)
      end
    else
      changeset
    end
  end
end
