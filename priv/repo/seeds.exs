# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Atlas.Repo.insert!(%Atlas.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Atlas.Repo
alias Atlas.Customers.{Location, ServiceCall, ServiceInstruction, TechNote}

aaron1 = %{"name" => "Aaron1", "email" => "aaron1@mail.com", "password" => "Atlas123456789"}
aaron2 = %{"name" => "Aaron2", "email" => "aaron2@mail.com", "password" => "Atlas123456789"}
aaron3 = %{"name" => "Aaron3", "email" => "aaron3@mail.com", "password" => "Atlas123456789"}

{:ok, %{tech: aaron1}} = Atlas.Accounts.register_user(aaron1)
{:ok, %{tech: aaron2}} = Atlas.Accounts.register_user(aaron2)
{:ok, %{tech: aaron3}} = Atlas.Accounts.register_user(aaron3)


loc1 = %{name: "Some customer", location_number: 108429}
%{location_number: no} = Location.create_changeset(%Location{}, loc1) |> Repo.insert!()


call = %{location_number: no, start_date: ~N[2022-03-03 12:00:00], end_date: ~N[2022-03-03 23:00:00]}
%{id: call_id} = ServiceCall.create_changeset(%ServiceCall{}, call) |> Repo.insert!()


instruction = %{call_id: call_id, type: "mass_pharoah_ants", description: ""}
ServiceInstruction.create_changeset(%ServiceInstruction{}, instruction) |> Repo.insert!()

note = %{call_id: call_id, tech_id: aaron1.id, note: "Wuzzuuuuup"}
TechNote.create_changeset(%TechNote{}, note)
