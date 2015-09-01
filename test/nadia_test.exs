defmodule NadiaTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Nadia.Model.User

  setup_all do
    unless Application.get_env(:nadia, :token) do
      Application.put_env(:nadia, :token, "TEST_TOKEN")
    end
    ExVCR.Config.filter_sensitive_data("bot[^/]+/", "bot<TOKEN>/")
    ExVCR.Config.filter_sensitive_data("id\":\\d+", "id\":666")
    :ok
  end

  test "get_me" do
    use_cassette "get_me" do
      {:ok, me} = Nadia.get_me
      assert me == %User{id: 666, first_name: "Nadia", username: "nadia_bot"}
    end
  end

  test "get_updates" do
    use_cassette "get_updates" do
      {:ok, updates} = Nadia.get_updates(limit: 1)
      assert length(updates) == 1
    end
  end
end
