defmodule Bulk.Product do
  use Ecto.Schema

  import Ecto.Query

  alias Bulk.Repo
  alias __MODULE__

  schema "products" do
    field :price, :integer
    has_one :detail, Bulk.Detail, on_replace: :update, foreign_key: :product_id

    timestamps()
  end

  def update_sales_price(%{name: name, increase: increase}) do
    generate_query(name)
    |> update([],
      set: [price: fragment("price + (price * ?)", ^increase)]
    )
    |> Repo.update_all([])
  end

  def update_sales_price(%{product_ids: product_ids, increase: increase}) do
    generate_query(product_ids)
    |> update([],
      set: [price: fragment("price + (price * ?)", ^increase)]
    )
    |> Repo.update_all([])
  end

  def all_products(%{name: name}) do
    generate_query(name)
    |> Repo.all()
  end

  def all_products(%{product_ids: product_ids}) do
    generate_query(product_ids)
    |> Repo.all()
  end

  def generate_query(product_ids) when is_list(product_ids) do
    from(p in Product, join: d in assoc(p, :detail))
    |> where([p, _d], p.id in ^product_ids)
    |> order_by([p, _d], p.id)
  end

  def generate_query(name) when is_binary(name) do
    from(p in Product, join: d in assoc(p, :detail))
    |> where([_p, d], ilike(d.name, ^"%#{name}%"))
    |> order_by([p, _d], p.id)
  end
end
