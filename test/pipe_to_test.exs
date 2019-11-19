defmodule PipeToTest do
  use ExUnit.Case
  use PropCheck
  import PipeTo
  doctest PipeTo

  test "using will import :~> operator" do
    result = 1 ~> Enum.at([1, 2, 3], _)
    assert result == 2
  end

  test "show work when placeholder partially exist" do
    result =
      ~w(a b c)a
      ~> Enum.zip(1..3)
      ~> Enum.reduce(%{}, fn {key, value}, accu ->
        Map.put(accu, key, value)
      end)
      ~> Map.merge(%{d: 4, e: 5}, _)

    assert result == %{a: 1, b: 2, c: 3, d: 4, e: 5}
  end

  property "Pipe to function with 1 argument, without assigning position" do
    forall {fun, arg} <- {function1(any()), any()} do
      arg ~> fun.() == fun.(arg)
    end
  end
end
