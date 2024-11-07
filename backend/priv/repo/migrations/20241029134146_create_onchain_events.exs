defmodule Peach.Repo.Migrations.CreateOnchainEvents do
  use Ecto.Migration

  def change do
    create table(:onchain_events, primary_key: false) do
      add :id, :string, primary_key: true
      add :onchain, :boolean, default: false
      add :_cursor, :bigint
      add :event_id, references(:events, on_delete: :nothing)
    end
  end
end
