defmodule Peach.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :name, :string
      add :description, :string
      add :location, :string
      add :start, :utc_datetime
      add :end, :utc_datetime
      add :cover, :string
      add :treasury, :string

      timestamps(type: :utc_datetime)
    end
  end
end
