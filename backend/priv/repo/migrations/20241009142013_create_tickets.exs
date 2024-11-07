defmodule Peach.Repo.Migrations.CreateTickets do
  use Ecto.Migration

  def change do
    create table(:tickets, primary_key: false) do
      add :id, :string, primary_key: true
      add :ticket_tier_id, references(:ticket_tiers, on_delete: :nothing)
      add :event_id, references(:events, on_delete: :nothing)
      add :block_hash, :string
      add :block_number, :integer
      add :block_timestamp, :utc_datetime_usec
      add :transaction_hash, :string
      add :transfer_id, :string
      add :index_in_block, :integer
      add :owner, :string
      add :balance, :string
      add :created_at, :utc_datetime
      add :_cursor, :bigint
    end

    create index(:tickets, [:ticket_tier_id])
    create index(:tickets, [:event_id])
  end
end
