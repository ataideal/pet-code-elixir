defmodule RickMortyPetWeb.CharacterControllerTest do
  use RickMortyPetWeb.ConnCase

  alias RickMortyPet.RickMorty
  alias RickMortyPet.RickMorty.Character

  @create_attrs %{
    gender: "some gender",
    name: "some name",
    species: "some species",
    status: "some status",
    type: "some type"
  }
  @update_attrs %{
    gender: "some updated gender",
    name: "some updated name",
    species: "some updated species",
    status: "some updated status",
    type: "some updated type"
  }
  @invalid_attrs %{gender: nil, name: nil, species: nil, status: nil}

  def fixture(:character) do
    {:ok, character} = RickMorty.create_character(@create_attrs)
    character
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all characters", %{conn: conn} do
      conn = get(conn, Routes.character_path(conn, :index))
      assert json_response(conn, 200) == []
    end
  end

  describe "create character" do
    test "renders character when data is valid", %{conn: conn} do
      conn = post(conn, Routes.character_path(conn, :create), character: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)

      conn = get(conn, Routes.character_path(conn, :show, id))

      assert %{
               "id" => id,
               "gender" => "some gender",
               "name" => "some name",
               "species" => "some species",
               "status" => "some status",
               "type" => "some type"
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.character_path(conn, :create), character: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update character" do
    setup [:create_character]

    test "renders character when data is valid", %{conn: conn, character: %Character{id: id} = character} do
      conn = put(conn, Routes.character_path(conn, :update, character), character: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get(conn, Routes.character_path(conn, :show, id))

      assert %{
               "id" => id,
               "gender" => "some updated gender",
               "name" => "some updated name",
               "species" => "some updated species",
               "status" => "some updated status",
               "type" => "some updated type"
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, character: character} do
      conn = put(conn, Routes.character_path(conn, :update, character), character: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete character" do
    setup [:create_character]

    test "deletes chosen character", %{conn: conn, character: character} do
      conn = delete(conn, Routes.character_path(conn, :delete, character))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.character_path(conn, :show, character))
      end
    end
  end

  defp create_character(_) do
    character = fixture(:character)
    {:ok, character: character}
  end
end
