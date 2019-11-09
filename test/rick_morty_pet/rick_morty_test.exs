defmodule RickMortyPet.RickMortyTest do
  use RickMortyPet.DataCase

  alias RickMortyPet.RickMorty

  describe "characters" do
    alias RickMortyPet.RickMorty.Character

    @valid_attrs %{gender: "some gender", name: "some name", species: "some species", status: "some status", type: "some type"}
    @update_attrs %{gender: "some updated gender", name: "some updated name", species: "some updated species", status: "some updated status", type: "some updated type"}
    @invalid_attrs %{gender: nil, name: nil, species: nil, status: nil, type: nil}

    def character_fixture(attrs \\ %{}) do
      {:ok, character} =
        attrs
        |> Enum.into(@valid_attrs)
        |> RickMorty.create_character()

      character
    end

    test "list_characters/0 returns all characters" do
      character = character_fixture()
      assert RickMorty.list_characters() == [character]
    end

    test "get_character!/1 returns the character with given id" do
      character = character_fixture()
      assert RickMorty.get_character!(character.id) == character
    end

    test "create_character/1 with valid data creates a character" do
      assert {:ok, %Character{} = character} = RickMorty.create_character(@valid_attrs)
      assert character.gender == "some gender"
      assert character.name == "some name"
      assert character.species == "some species"
      assert character.status == "some status"
      assert character.type == "some type"
    end

    test "create_character/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = RickMorty.create_character(@invalid_attrs)
    end

    test "update_character/2 with valid data updates the character" do
      character = character_fixture()
      assert {:ok, %Character{} = character} = RickMorty.update_character(character, @update_attrs)
      assert character.gender == "some updated gender"
      assert character.name == "some updated name"
      assert character.species == "some updated species"
      assert character.status == "some updated status"
      assert character.type == "some updated type"
    end

    test "update_character/2 with invalid data returns error changeset" do
      character = character_fixture()
      assert {:error, %Ecto.Changeset{}} = RickMorty.update_character(character, @invalid_attrs)
      assert character == RickMorty.get_character!(character.id)
    end

    test "delete_character/1 deletes the character" do
      character = character_fixture()
      assert {:ok, %Character{}} = RickMorty.delete_character(character)
      assert_raise Ecto.NoResultsError, fn -> RickMorty.get_character!(character.id) end
    end

    test "change_character/1 returns a character changeset" do
      character = character_fixture()
      assert %Ecto.Changeset{} = RickMorty.change_character(character)
    end
  end
end
