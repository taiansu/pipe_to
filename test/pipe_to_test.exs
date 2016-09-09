defmodule PipeToTest do
  use ExUnit.Case
  import PipeTo
  doctest PipeTo

  test "using will import :~> operator" do
    result = 1 ~> Enum.at([1, 2, 3], _)
    assert result == 2
  end
end
