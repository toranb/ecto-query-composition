defmodule Bulk.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :price, :integer

      timestamps()
    end

    create table(:details) do
      add :name, :string
      add :product_id, references(:products), null: false

      timestamps()
    end
  end
end
