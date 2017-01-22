# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Meetings.Repo.insert!(%Meetings.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

defmodule Meetings.DatabaseSeeder do
   alias Meetings.Repo
   alias Meetings.MeetingType
   alias Meetings.MeetingDate
   alias Meetings.MeetingExtra

   def truncate do
      Repo.query("ALTER TABLE meeting_dates DROP CONSTRAINT meeting_dates_meeting_type_id_fkey")
      Repo.query("ALTER TABLE meeting_extras DROP CONSTRAINT meeting_extras_meeting_type_id_fkey")

      Repo.delete_all MeetingType
      Repo.delete_all MeetingDate
      Repo.delete_all MeetingExtra
   end

   def add_constraints do
      Repo.query("ALTER TABLE meeting_dates ADD CONSTRAINT meeting_dates_meeting_type_id_fkey")
      Repo.query("ALTER TABLE meeting_extras ADD CONSTRAINT meeting_extras_meeting_type_id_fkey")
   end

   def insert_type(meeting) do
      Repo.insert! %MeetingType{
         type: meeting["type"],
         subtype: meeting["subtype"],
         title: meeting["title"],
         description: meeting["description"],
         location: meeting["location"],
         hour: String.to_integer(meeting["hour"]),
         minute: String.to_integer(meeting["minute"]),
         duration: String.to_integer(meeting["duration"]),
         email: meeting["email"],
         agenda: meeting["agenda"]
      }
   end

   def insert_date(meeting) do
      Repo.insert! %MeetingDate{
         meeting_type_id: String.to_integer(meeting["tid"]),
         year: String.to_integer(meeting["year"]),
         month: String.to_integer(meeting["month"]),
         day: String.to_integer(meeting["day"]),
      }
   end

   def insert_extra(meeting) do
      Repo.insert! %MeetingExtra{
         meeting_type_id: String.to_integer(meeting["tid"]),
         field: meeting["name"],
         value: meeting["value"]
      }
   end

   def read(mtype) do
      Application.app_dir(:meetings, "priv/data/meeting_#{mtype}.json")
         |> File.read!
         |> Poison.decode!
   end

   def each(meetings, func) do
      Enum.each(meetings, func)
   end
end


alias Meetings.DatabaseSeeder

#DatabaseSeeder.truncate()
DatabaseSeeder.each(DatabaseSeeder.read("types"), fn meeting -> DatabaseSeeder.insert_type(meeting) end)
DatabaseSeeder.each(DatabaseSeeder.read("dates"), fn meeting -> DatabaseSeeder.insert_date(meeting) end)
DatabaseSeeder.each(DatabaseSeeder.read("extras"), fn meeting -> DatabaseSeeder.insert_extra(meeting) end)
#DatabaseSeeder.add_constraints()


