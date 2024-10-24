defmodule Peach.Config do
  @moduledoc """
  Provides access to application configuration.
  """

  @app :peach

  def private_key do
    Application.fetch_env!(@app, __MODULE__)[:private_key]
  end

  def address do
    Application.fetch_env!(@app, __MODULE__)[:address]
  end

  def provider_url do
    Application.fetch_env!(@app, __MODULE__)[:provider_url]
  end

  def contract_address do
    Application.fetch_env!(@app, __MODULE__)[:contract_address]
  end

  def chain_id do
    Application.fetch_env!(@app, __MODULE__)[:chain_id]
  end
end
