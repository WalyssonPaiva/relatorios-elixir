defmodule GenReport do
  alias GenReport.Parser

  @users [
    "danilo",
    "mayk",
    "daniele",
    "giuliano",
    "cleiton",
    "jakeliny",
    "joseph",
    "diego",
    "rafael",
    "vinicius"
  ]

  @months [
    "janeiro",
    "fevereiro",
    "março",
    "abril",
    "maio",
    "junho",
    "julho",
    "agosto",
    "setembro",
    "outubro",
    "novembro",
    "dezembro"
  ]
  @years [
    2016,
    2017,
    2018,
    2019,
    2020
  ]
  def build(file_name) do
    file_name
    |> Parser.parse_file()
    |> Enum.reduce(report_acc(), &build_report(&1, &2))
  end

  def build do
    {:error, "Insira o nome de um arquivo"}
  end

  def report_acc do
    all_horus = Enum.into(@users, %{}, &{&1, 0})
    hours_per_month = Enum.into(@users, %{}, &{&1, create_nested_map(@months)})
    hours_per_year = Enum.into(@users, %{}, &{&1, create_nested_map(@years)})

    %{
      "all_hours" => all_horus,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    }
  end

  defp create_nested_map(map) do
    Enum.into(map, %{}, &{&1, 0})
  end

  defp build_report(
         [name, hours, _day, month, year],
         %{
           "all_hours" => all_hours,
           "hours_per_month" => hours_per_month,
           "hours_per_year" => hours_per_year
         } = acc
       ) do
    all_hours = Map.put(all_hours, name, all_hours[name] + hours)

    hours_per_month =
      Map.put(hours_per_month, name, update_nested_map(hours_per_month[name], month, hours))

    hours_per_year =
      Map.put(hours_per_year, name, update_nested_map(hours_per_year[name], year, hours))

    %{
      acc
      | "all_hours" => all_hours,
        "hours_per_month" => hours_per_month,
        "hours_per_year" => hours_per_year
    }
  end

  defp update_nested_map(map, key, value) do
    map = Map.put(map, key, map[key] + value)
    map
  end
end
