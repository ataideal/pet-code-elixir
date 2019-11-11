defmodule RickMortyPet.RickMorty.Location do
  use Ecto.Schema
  import Ecto.Changeset
  alias RickMortyPet.RickMorty.Character

  schema "locations" do
    field :dimension, :string
    field :name, :string
    field :type, :string
    field :external_id, :integer
    has_many :characters, Character, foreign_key: :origin_id, on_delete: :nilify_all

    timestamps()
  end

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, [:name, :type, :dimension, :external_id])
    |> validate_required([:name])
  end
end
