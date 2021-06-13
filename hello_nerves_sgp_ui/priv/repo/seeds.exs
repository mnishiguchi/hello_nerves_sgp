# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     HelloNervesSgpUi.Repo.insert!(%HelloNervesSgpUi.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias HelloNervesSgpUi.Environment

Enum.each(1..5, fn _x ->
  {:ok, _} =
    %{
      temperature_c: Faker.random_between(25, 32) + Faker.random_uniform(),
      humidity_rh: Faker.random_between(30, 50) + Faker.random_uniform(),
      voc_index: Faker.random_between(1, 300)
    }
    |> Environment.create_measurement()
end)
