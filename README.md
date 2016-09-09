# PipeTo

__Homing pipe  `~>`__

The enhanced pipe operator which can specify the target position.

## Getting Start

To use PipeTo with your projects, edit your mix.exs file and add it as a dependency:

```elixir
def deps do
  [{:pipe_to, "~> 0.1.0"}]
end

defp application do
  [applications: [:pipe_to]]
end
```

### Introduction

* `import PipeTo` in your module,
* pipe with `~>`
* use `_` to specify the target position of left-hand side expression.

```elixir
> import PipeTo
> 1 ~> Enum.at([1, 2, 3], _)
# 2
```

It can works with pipe operator well.

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

### Disclaimer
  I have read through the proposals of pipe operator enhancement on the [elixir-lang-core](https://groups.google.com/forum/#!forum/elixir-lang-core), like [this](https://groups.google.com/forum/#!searchin/elixir-lang-core/pipe$20argument%7Csort:relevance/elixir-lang-core/jKOJ1zUYwaE/SIKql6ybAQAJ), [this](https://groups.google.com/forum/#!searchin/elixir-lang-core/pipe$20argument|sort:relevance/elixir-lang-) or [this](https://groups.google.com/forum/#!searchin/elixir-lang-core/pipe$20argument|sort:relevance/elixir-lang-core/wTK072BdJus/GOUMaUrEEQAJ).

  The reason I still want this is because the combination of curried function (or partial application) with pipe operator is so elegant, like [this F# example here](https://fsharpforfunandprofit.com/posts/partial-application/). Since Elixir doesn't have these mechnism, and also anonymous function call use `.()`, so syntactically (well, aesthetically) the only choice I have is to modify the pipe operator.

### Is it any good?
[Yes](https://news.ycombinator.com/item?id=3067434)

## License
Apache 2
