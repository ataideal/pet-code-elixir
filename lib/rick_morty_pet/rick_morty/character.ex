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
    field :external_id, :integer
    field :picture,  RickMortyPet.Picture.Type
    belongs_to :origin, Location, foreign_key: :origin_id, on_replace: :nilify

    timestamps()
  end

  @doc false
  def changeset(character, attrs) do
    character
    |> cast(attrs, [:name, :status, :species, :type, :gender, :external_id])
    |> cast_attachments(attrs, [:picture], allow_paths: true)
    |> find_or_create_origin(attrs[:origin])
    |> validate_required([:name, :status, :species, :gender])
  end

  def picture_url(character) do
    case RickMortyPet.Picture.url({character.picture, character}) do
      nil -> nil
      _ -> Application.get_env(:arc,:url) <> (RickMortyPet.Picture.url({character.picture, character}))
    end
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
