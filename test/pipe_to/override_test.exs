defmodule PipeTo.OverrideToTest do
  use ExUnit.Case
  use PipeTo.Override

  test "override the Kernel.|> operator" do
    result = 1 |> Enum.at(1..3, _)
    assert result == 2
  end

  test "chain pipe works correctly" do
    result = 5 |> Enum.take(1..10, _) |> Enum.reverse
    assert result == [5, 4, 3, 2, 1]
  end

  test "works like normal pipe" do
    result = ~w(a b c)a
    |> Enum.zip(3..1)
    |> Enum.sort_by(fn {k, v} -> v end)

    assert result == [c: 1, b: 2, a: 3]
  end
end
