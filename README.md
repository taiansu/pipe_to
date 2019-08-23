# PipeTo

The enhanced pipe operator which can specify the target position.

## Installation

To use PipeTo with your projects, edit your mix.exs file and add it as a dependency:

```elixir
def deps do
  [{:pipe_to, "~> 0.2"}]
end
```

Then run `mix deps.get`

## Quick start

* `import PipeTo` in your module,
* pipe with `~>`
* use `_` to specify the target position of left-hand side expression.

```elixir
> import PipeTo
> 1 ~> Enum.at([1, 2, 3], _)
# 2
```

It works with pipe operator nicely.

```elixir
> 5 ~> Enum.take(1..10, _) |> Enum.reverse()
# [5, 4, 3, 2, 1]
```

In fact, if you don't specify the position with `_`, it acts just like normal `|>`
```elixir
> [4, 8, 1] ~> Enum.max()
# 8
```

## Override the `Kernel.|>/2`
Since `~>` is the enhanced pipe operator, you can override the `Kernel.|>/2` with it.

```elixir
defmodule Foo do
  use PipeTo.Override

  def bar do
    2 |> Enum.drop(1..10, _) |> Enum.at(1)
  end
end

Foo.bar
# 4
```

## Performance

use `PipeTo` sightly faster then normal pipe in all these cases below. For the __case 2__ and __case 3__, I will guess
that anonymous function slow down the oridinary pipe. But it doesn't explain why in the _case 1_ `PipeTo` insignificantly faster
then ordinary pipe. Any ideas?

### Case 1: Ordinary Pipe vs PipeTo without index

![bench_1](https://cloud.githubusercontent.com/assets/241597/18638941/81e774ec-7ec4-11e6-9609-ed2c4747c3cf.png)

### Case 2: Pipe with anonymous function vs PipeTo with index

![bench_2](https://cloud.githubusercontent.com/assets/241597/18634414/621593f8-7eb3-11e6-8c31-2895efd150b8.png)

### Case 3: Pipe with anonymous vs use PipeTo.Override

![bench_3](https://cloud.githubusercontent.com/assets/241597/18634416/6217001c-7eb3-11e6-94dd-aacc9dec2ad1.png)

## Disclaimer

  I have read through the proposals of pipe operator enhancement on the [elixir-lang-core](https://groups.google.com/forum/#!forum/elixir-lang-core), like [this](https://groups.google.com/forum/#!searchin/elixir-lang-core/pipe$20argument%7Csort:relevance/elixir-lang-core/jKOJ1zUYwaE/SIKql6ybAQAJ), [this](https://groups.google.com/forum/#!searchin/elixir-lang-core/pipe$20argument|sort:relevance/elixir-lang-) or [this](https://groups.google.com/forum/#!searchin/elixir-lang-core/pipe$20argument|sort:relevance/elixir-lang-core/wTK072BdJus/GOUMaUrEEQAJ).

  The reason I still want this is because the combination of curried function (or partial application) with pipe operator is so elegant, like [this F# example here](https://fsharpforfunandprofit.com/posts/partial-application/). Since Elixir doesn't have these mechnism, and also anonymous function call use `.()`, so syntactically (well, aesthetically) the only choice I have is to modify the pipe operator.

## Is it any good?
[Yes](https://news.ycombinator.com/item?id=3067434)

## License
Apache 2

## TODO
* Discard the default operator, user should specify the operator expicitly, to work with lib like Witchcraft better.
* Pipe into mutiple target at once
* Pipe into target in nested expression, instead of only the shallowest level like now.
