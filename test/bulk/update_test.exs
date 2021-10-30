defmodule Bulk.UpdateTest do
  use Bulk.DataCase, async: true

  alias Bulk.{Repo, Product, Detail}

  setup do
    one = %Product{price: 10} |> Repo.insert!()
    two = %Bulk.Product{price: 30} |> Repo.insert!()
    three = %Bulk.Product{price: 200} |> Repo.insert!()

    %Detail{name: "foo", product_id: one.id} |> Repo.insert!()
    %Detail{name: "bar", product_id: two.id} |> Repo.insert!()
    %Detail{name: "foos", product_id: three.id} |> Repo.insert!()

    %{one: one, two: two, three: three}
  end

  test "query all products by ids", %{one: one, two: two, three: three} do
    product_ids = [one.id, two.id, three.id]
    results = Product.all_products(%{product_ids: product_ids})
    assert Enum.count(results) == 3
  end

  test "query all products by name" do
    name = "foo"
    results = Product.all_products(%{name: name})
    assert Enum.count(results) == 2
  end
end
