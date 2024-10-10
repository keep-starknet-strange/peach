defmodule Peach.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :name, :string
      add :description, :string
      add :location, :string
      add :date, :utc_datetime
      add :cover, :string
      add :onchain, :boolean, default: false
      add :treasury, :string

      timestamps(type: :utc_datetime)
    end
  end
end
