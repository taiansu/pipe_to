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
end
