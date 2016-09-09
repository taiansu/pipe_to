defmodule PipeTo.Override do
  import Kernel, except: [|>: 2]
  import PipeTo

  defmacro __using__(_opts) do
    quote do
      import Kernel, except: [{:|>, 2}]
      import PipeTo
      import unquote(__MODULE__)
    end
  end
  @doc """
  Since `~>` is the enhanced `|>`, you can overrid the Kernel.|> with `use PipeTo.Override`

          defmodule YourModule do
              use PipeTo.Override

              def run do
                1 |> Enum.at([1, 2, 3], _)
              end
          end
  """
  defmacro left |> right do
    quote do
      unquote(left) ~> unquote(right)
    end
  end
end
