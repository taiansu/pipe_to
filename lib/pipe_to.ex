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

  def unpipe(expr) do
    :lists.reverse(unpipe(expr, []))
  end

  defp unpipe({:~>, _, [left, right]}, acc) do
    unpipe(right, unpipe(left, acc))
  end

  defp unpipe(ast = {_, _, args}, acc) do
    placeholder_index =
      Enum.find_index(args, &is_placeholder/1)

    correct_ast = fix_ast(ast, placeholder_index)

    [{correct_ast, pipe_position(placeholder_index)} | acc]
  end

  defp unpipe(other, acc) do
    [{other, 0} | acc]
  end

  defp is_placeholder(arg) do
    is_tuple(arg) && elem(arg, 0) == :_
  end

  defp pipe_position(nil),   do: 0
  defp pipe_position(index), do: index
    
  defp fix_ast(ast, nil), do: ast
  defp fix_ast({fun, meta, args}, index) do
    {fun, meta, List.delete_at(args, index)}
  end
end
