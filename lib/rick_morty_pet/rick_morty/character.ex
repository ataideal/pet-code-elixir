defmodule RickMortyPet.RickMorty.Character do
  use Ecto.Schema
  import Ecto.Changeset
  use Arc.Ecto.Schema

  schema "characters" do
    field :gender, :string
    field :name, :string
    field :species, :string
    field :status, :string
    field :type, :string
    field :picture,  RickMortyPet.Picture.Type

    timestamps()
  end

  @doc false
  def changeset(character, attrs) do
    character
    |> cast(attrs, [:name, :status, :species, :type, :gender])
    |> cast_attachments(attrs, [:picture], allow_paths: true)
    |> validate_required([:name, :status, :species, :gender])
  end

  def picture_url(character) do
    RickMortyPet.Picture.url({character.picture, character})
  end
end
