defmodule Main do
  use Bitwise
  def main(size) do
    data = 0..size - 1 |> Enum.to_list
    range = 1 <<< size
    for x <- 0..range - 1 do
      data |> calc(x, 0, size)
    end
  end

  def calc(data, pattern, sum, depth) do
    if depth > 0 do
      case pattern &&& 1 do
        0 -> data
          |> tl
          |> calc(pattern >>> 1, sum, depth - 1)
        1 -> data
          |> tl
          |> calc(pattern >>> 1, sum + hd(data), depth - 1)
      end
    else
      sum
    end
  end
end

Main.main(6) |> Enum.map(& :io.format "~p, ", [&1])
