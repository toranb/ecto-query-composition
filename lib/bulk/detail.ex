defmodule Bulk.Detail do
  use Ecto.Schema
  import Ecto.Changeset

  schema "details" do
    field :name, :string
    belongs_to :product, Bulk.Product, foreign_key: :product_id

    timestamps()
  end

  @doc false
  def changeset(detail, attrs) do
    detail
    |> cast(attrs, [:name, :product_id])
    |> validate_required([:name])
  end
end
