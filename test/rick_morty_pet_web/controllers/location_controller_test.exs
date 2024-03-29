defmodule RickMortyPetWeb.LocationControllerTest do
  use RickMortyPetWeb.ConnCase

  alias RickMortyPet.RickMorty
  alias RickMortyPet.RickMorty.Location

  @create_attrs %{
    dimension: "some dimension",
    name: "some name",
    type: "some type"
  }
  @update_attrs %{
    dimension: "some updated dimension",
    name: "some updated name",
    type: "some updated type"
  }
  @invalid_attrs %{dimension: nil, name: nil, type: nil}

  def fixture(:location) do
    {:ok, location} = RickMorty.create_location(@create_attrs)
    location
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all locations", %{conn: conn} do
      conn = get(conn, Routes.location_path(conn, :index))
      assert json_response(conn, 200) == []
    end
  end

  describe "create location" do
    test "renders location when data is valid", %{conn: conn} do
      conn = post(conn, Routes.location_path(conn, :create), location: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)

      conn = get(conn, Routes.location_path(conn, :show, id))

      assert %{
               "id" => id,
               "dimension" => "some dimension",
               "name" => "some name",
               "type" => "some type"
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.location_path(conn, :create), location: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update location" do
    setup [:create_location]

    test "renders location when data is valid", %{conn: conn, location: %Location{id: id} = location} do
      conn = put(conn, Routes.location_path(conn, :update, location), location: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)

      conn = get(conn, Routes.location_path(conn, :show, id))

      assert %{
               "id" => id,
               "dimension" => "some updated dimension",
               "name" => "some updated name",
               "type" => "some updated type"
             } = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, location: location} do
      conn = put(conn, Routes.location_path(conn, :update, location), location: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete location" do
    setup [:create_location]

    test "deletes chosen location", %{conn: conn, location: location} do
      conn = delete(conn, Routes.location_path(conn, :delete, location))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.location_path(conn, :show, location))
      end
    end
  end

  defp create_location(_) do
    location = fixture(:location)
    {:ok, location: location}
  end
end
