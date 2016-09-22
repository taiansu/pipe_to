defmodule PipeTo do
  @doc """
  PipeTo operator.

  This operator will replace the placeholder argument `_` in the right-hand
  side function call with left-hand side expression.

  ### Examples

        iex> 1 ~> Enum.at(1..3, _)
        2

  It can mix with `|>` operation

  ### Examples

        iex> 1 ~> Enum.at(1..3, _) |> Kernel.*(5)
        10

  When using ~> withou placeholder `_`, it act just like `|>` pipe operator.

  ### Examples

        iex> [1, 2, 3] ~> Enum.take(2)
        [1, 2]
  """
  defmacro left ~> right do
    [{h, _} | t] = __MODULE__.unpipe({:~>, [], [left, right]})

    :lists.foldl fn {x, pos}, acc ->
      case Macro.pipe_warning(x) do
        nil -> :ok
        message ->
          :elixir_errors.warn(__CALLER__.line, __CALLER__.file, message)
      end
      Macro.pipe(acc, x, pos)
    end, h, t
  end

  @doc """
  Breaks a pipeline expression into a list. This is where the target position being calculated.

          PipeTo.unpipe(quote do: 5 ~> div(100, _) ~> div(2))
          # => [{5, 0},
          #     {{:div, [context: Elixir, import: Kernel], 'd'}, 1},
          #     {{:div, [], [2]}, 0}]
  """
  @spec unpipe(Macro.t) :: [Macro.t]
  def unpipe(expr) do
    :lists.reverse(unpipe(expr, []))
  end

  defp unpipe({:~>, _, [left, right]}, acc) do
    unpipe(right, unpipe(left, acc))
  end

  defp unpipe(ast = {_, _, args}, acc) when is_list(args) do
    placeholder_index =
      Enum.find_index(args, &is_placeholder/1)

    fixed_ast = remove_placeholder(ast, placeholder_index)

    [{fixed_ast, pipe_position(placeholder_index)} | acc]
  end

  defp unpipe(other, acc) do
    [{other, 0} | acc]
  end

  defp is_placeholder({:_, _, _}),  do: true
  defp is_placeholder(_), do: false

  defp pipe_position(nil),   do: 0
  defp pipe_position(index), do: index

  defp remove_placeholder(ast, nil), do: ast
  defp remove_placeholder({fun, meta, args}, index) do
    {fun, meta, List.delete_at(args, index)}
  end
end
