defmodule Peach.Repo.Migrations.CreateTickets do
  use Ecto.Migration

  def change do
    create table(:tickets) do
      add :owner, :string
      add :ticket_tier_id, references(:ticket_tiers, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:tickets, [:ticket_tier_id])
  end
end
