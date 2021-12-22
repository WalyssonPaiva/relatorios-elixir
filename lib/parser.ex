defmodule GenReport.Parser do
  def parse_file(filename) do
    filename
    |> File.stream!()
    |> Stream.map(&parse_line(&1))
  end

  def parse_line(line) do
    line
    |> String.trim()
    |> String.split(",")
    |> List.update_at(0, &String.downcase/1)
    |> List.update_at(1, &String.to_integer/1)
    |> List.update_at(2, &String.to_integer/1)
    |> List.update_at(3, &get_month_name/1)
    |> List.update_at(4, &String.to_integer/1)
  end

  defp get_month_name(month_number) do
    month_index = String.to_integer(month_number) - 1

    month = [
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

    Enum.at(month, month_index)
  end
end
