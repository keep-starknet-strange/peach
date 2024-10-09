defmodule Peach.Repo.Migrations.CreateTicketTiers do
  use Ecto.Migration

  def change do
    create table(:ticket_tiers) do
      add :name, :string
      add :description, :string
      add :max_supply, :integer
      add :event_id, references(:events, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:ticket_tiers, [:event_id])
  end
end
