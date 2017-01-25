# Public Meetings

A project to aggregate public civic meetings available in Wichita to a single
location. It is powered by:

* Scrapers in python (check the `prototype-web-scraping` branch)
* Web app with Elixir, Phoenix and PostgreSQL

**To get involved** be sure to join the [Open Wichita
slack](https://openwichita.com/slack) and hop in to the #public-meetings
channel.

**Also make sure to check [the
issues](https://github.com/openwichita/public-meetings/issues)!**


**View temporary meeting list with latest updates**
http://public-meetings.website/meetings

**To get started:**
  * [Install elixir](http://elixir-lang.org/install.html)
    * Alternatively: use [asdf](https://github.com/asdf-vm/asdf) with the
      [erlang](https://github.com/asdf-vm/asdf-erlang) and
      [elixir](https://github.com/asdf-vm/asdf-elixir) plugins.
  * `cd` to the project directory and install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Node.js dependencies with `npm install`
  * Seed the database with meeting data: `mix run priv/repo/seeds.exs`
  * Start Phoenix endpoint with `mix phoenix.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Learn more about Phoneix!

  * Official website: http://www.phoenixframework.org/
  * Guides: http://phoenixframework.org/docs/overview
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix
  
## Meetings scraped/aggregated so far:

  * Council
      * Regular
      * Consent Workshop
  * Mayor's Briefings
  * City Agenda Review
  * County Commission
  * County Staff
  * Metropolitan Area Planning Commission
  * Board of Education
      * Regular
      * Committee of the Whole
      * 99% Awards
      * Good Apples
      * Special
      * Year-End Meeting
  * Airport Board
  * Animal Control Advisory Board
  * Bicycle & Pedestrian Advisory Board
  * Board of Code Standards
   * Board of Electrical Appeals
  * Building Board
  * District Advisory Boards
      *  I - VI
  * Mechanical Board
  * Park Board
  * Plumbers and Gas fitters Board Of Appeals
  * Subdivision and Utility Advisory
  * Wichita Transit Advisory Board
  * League of Women Voters
  * Wichita Pachyderm Club
