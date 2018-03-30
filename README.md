# Cogoli [![Build Status](https://travis-ci.org/mwri/elixir-cogoli.svg?branch=master)](https://travis-ci.org/mwri/elixir-cogoli)

This is an implementation of Conway's Game of Life, and modifications.
You can run the standard game, but the rules, the display the backend
store and even the initialisation routines can be swapped out by using
alternative callback modules.

Cogoli is in fact a wrapper for the Erlang app
[cgolam](https://github.com/mwri/erlang-cgolam).

## Running the standard game

Start a standard game like this:

```
iex(1)> Cogoli.start(
    width: 40,
    height: 40
)
{:ok, #PID<0.83.0>}
```

## A coloured variation

This looks like different species competing and interbreeding, but
the rules are the same as the standard game, so they are cooperative
really.

```
Cogoli.start(
    title: "Coloured Conway's Game of Life",
    interval: 50,
    rules: [cgolam_rules_coloured: []],
    field: [cgolam_field_ets: []],
    width: 150,
    height: 150,
    display: [cgolam_display_wx: [sqsize: 5]],
    init: [cgolam_rules_coloured: [default: [cluster_size: 150]]]
)
```

## Multiple species

To see an attempt at a true multi species varient, try this one:

```elixir
Cogoli.start(
    title: "Coloured Conway's Game of Life",
    interval: 50,
    rules: [cgolam_rules_species3: [colmatch_algorithm: :common_duo]],
    field: [cgolam_field_ets: []],
    width: 150,
    height: 150,
    display: [cgolam_display_wx: [sqsize: 5]],
    init: [cgolam_rules_species3: [default: [
        cluster_size: 300,
        cluster_density: 100,
        clusters: 3
    ]]],
)
```

A bit like CGoL generally, it's not so much a life simulation as a
curious demonstration of emergent behaviour, it's difficult to say
if this exhibits any real competition, but there are elements of that
inherent to this `cgolam_rules_species3` algorithm certainly.

A single colour will perform entirely according the the CGoL rules
but when multiple colours colide, like the coloured version above the
results can be a colour combination... but the difference here is that
the colours are actually entirely independent from each other and a
colour merge only occurs when there is competition for a common cell
(i.e. in a given game cycle two different colours both want to occupy
the same cell), where as two colours can in fact operate along side
one another without having any affect on each other at all IF they
never compete...

What constitutes the same colour is a tricky thing, if an exact match
is required then the chances of a new colour establishing are small
so some tolerance tends to result in more interesting simulations.

For a non tolerant version of the above try changing `:common_duo`
to `:intolerant_duo`.

In many ways the simple coloured version looks more interesting, though
I think the 'species' versions are intellectually more so.

For more information about the game specification properties; how else
the `rules`, `field`, `init` modules can be configured, please see
[cgolam](https://github.com/mwri/erlang-cgolam).

## Installation

The package can be installed by adding `:cogoli` to your list of
dependencies in **mix.exs**:

```elixir
def deps do
  [
    {:cogoli, "~> 1.0.1"},
  ]
end
```

## Licensing

Copyright 2018 Michael Wright <mjw@methodanalysis.com>

'cgolam' is free software, you can redistribute it and/or modify
it under the terms of the MIT license.
