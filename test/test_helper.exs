ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Foo.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Foo.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Foo.Repo)

