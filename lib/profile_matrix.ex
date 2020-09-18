defmodule ProfileMatrix do
  @moduledoc """
  Documentation for ProfileMatrix.
  """

  @doc """
  Hello world.

  ## Examples

      iex> ProfileMatrix.hello()
      :world

  """
  def run(input \\ 2_000) do
    Benchee.run(
      %{
        "flow" => fn -> flow(input) end,
        "stream" => fn -> stream(input) end,
        "enum" => fn -> enum(input) end
      }
    )
  end

  def stream(input) do
    range = 1..input
    range
    |> Stream.flat_map(fn x -> Stream.map(range, fn y -> [x, y] end) end)
    |> Stream.map(fn [x, y] -> "#{x},#{y}" end)
    |> Enum.to_list()
  end

  def enum(input) do
    range = 1..input
    range
    |> Enum.flat_map(fn x -> Enum.map(range, fn y -> [x, y] end) end)
    |> Enum.map(fn [x, y] -> "#{x},#{y}" end)
  end

  def flow(input) do
    range = 1..input
    range
    |> Flow.from_enumerable()
    |> Flow.flat_map(fn x -> Enum.map(range, fn y -> [x, y] end) end)
    |> Flow.partition()
    |> Flow.map(fn [x, y] -> "#{x},#{y}" end)
    |> Enum.to_list()
  end
end
