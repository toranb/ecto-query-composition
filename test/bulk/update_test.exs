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

  test "bulk update products by ids", %{one: one, two: two, three: three} do
    increase = 1
    product_ids = [one.id, two.id, three.id]

    Product.update_sales_price(%{
      increase: increase,
      product_ids: product_ids
    })

    one = Product |> Repo.get!(one.id)
    assert one.price == 20
    two = Product |> Repo.get!(two.id)
    assert two.price == 60
    three = Product |> Repo.get!(three.id)
    assert three.price == 400
  end

  test "bulk update products by name", %{one: one, two: two, three: three} do
    name = "foo"
    increase = 1

    Product.update_sales_price(%{
      name: name,
      increase: increase
    })

    one = Product |> Repo.get!(one.id)
    assert one.price == 20
    two = Product |> Repo.get!(two.id)
    # two is not updated because name == bar
    assert two.price == 30
    three = Product |> Repo.get!(three.id)
    assert three.price == 400
  end
end
