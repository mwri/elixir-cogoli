defmodule Cogoli do

  @moduledoc """
  A highly modular implementation of Conway's Game of Life.

  The implementation itself is provided as a callback module, and as such
  alternative callback modules can be written to explore variations on the
  original Game of Life. A number of variations are in fact included with
  the app which implement purely aesthetic game alternatives in the form
  of colouration, and others that implement actual competition between
  different 'species' which individually implement the Game of Life rules
  on their own, but experience conflict and cross breading when there is
  a conflict for the same square!

  The display and back end store are also implemented as callbacks, so it
  is possible to implement more efficient back end storage, or present the
  game as something other than by X Windows, if desirable.
  """

  @doc """
  Start a game.

  Start a game. The single parameter is a keywords list and at least the
  Width and height properties must be provided, like this:

      iex(1)> Cogoli.start(
          width: 100,
          height: 100
      )
      {:ok, #PID<0.83.0>}

  Other properties that may be given are as follows:

      rules: [RulesModule: RulesConfig]
      rules: RulesModule

  The default is `cgolam_rules_normal: []` but other modules, which implement
  the cgolam_rules behaviour, may be used to provide a different set of rules
  to Conway's Game of Life.

  Another rules implementation is cgolam_rules_coloured, which also implements
  Conway's Game of Life, but uses different colours for the cells, with new
  cells (becoming alive from dead) assuming a colour mix of the surrounding
  cells.

      field: [FieldModule: FieldConfig]
      field: FieldModule

  The 'field' module is the back end implementation containing the data
  representing the game state.

  The default is `cgolam_rules_ets: []`, which uses ETS tables, but
  cgolam_rules_gb_trees and cgolam_rules_tuples also exist.

      init: [InitModule: [InitType: InitConfig]]
      init: [InitModule: InitType]

  The 'init' module is used to initialise the field with contents. The default
  is to use RulesModule, which initialises the field with data that makes sense
  the rules. The default InitType is `:default`.

  InitType is an atom, by default it is `:default` but can be other values if
  supported by the module. InitConfig is a keywords list, and the properties
  supported depends entirely on the module, but cgolam_rules_normal end
  cgolam_rules_coloured both `:support cluster_size` and `:cluster_density`,
  which increase or decrease the size and densities of the clusters of cells
  (the default is 100, it is a percentage, so 50 halves the density (sort of)
  and 200 doubles it). Also both support clusters, which determine the number
  of clusters.

      display: [DisplayModule: DisplayConfig]
      display: DisplayModule

  The 'display' module is used to display the game state. Currently this can
  only be `:cgolam_display_wx`, which uses WX Widgets / X Windows. A property
  of `:sqsize` may be given in DisplayConfig to change the size of the cells in
  pixels.

  For example, this, with the width and height added is the default game
  (note that the 'init' config is redundant here):

      cgolam:start(
          rules: [cgolam_rules_normal: []],
          field: [cgolam_field_ets: []],
          width: 100,
          height, 100,
          display: [cgolam_display_wx: [sqsize: 1]],
          init: [cgolam_rules_normal: [default: []]],
      )

  Here's a more interesting one which shows you more features:

      cgolam:start(
          title: "Coloured Conway's Game of Life",
          interval: 20,
          rules: [cgolam_rules_coloured: []],
          field: [cgolam_field_ets: []],
          width: 100,
          height: 100,
          display: [cgolam_display_wx: [sqsize: 5]],
          init: [cgolam_rules_coloured: [default: [cluster_size: 200]]],
      ])
  """

  @spec start([{atom, term}]) :: {:ok, pid}

  def start(game_cfg) do
    :cgolam.start(cfg_iex_to_erl(game_cfg))
  end

  @spec stop(pid) :: :ok

  def stop(pid) do
    :cgolam.stop(pid)
  end

  @spec list() :: [pid]

  def list() do
    :cgolam.list()
  end

  defp cfg_iex_to_erl ([{:rules, [{rules_mod, rules_cfg}]} | more_cfg]) do
    [{:rules, rules_mod, rules_cfg} | cfg_iex_to_erl(more_cfg)]
  end
  defp cfg_iex_to_erl ([{:field, [{field_mod, field_cfg}]} | more_cfg]) do
    [{:field, field_mod, field_cfg} | cfg_iex_to_erl(more_cfg)]
  end
  defp cfg_iex_to_erl ([{:display, [{display_mod, display_cfg}]} | more_cfg]) do
    [{:display, display_mod, display_cfg} | cfg_iex_to_erl(more_cfg)]
  end
  defp cfg_iex_to_erl ([{:init, [{init_mod, [{init_type, init_cfg}]}]} | more_cfg]) do
    [{:init, init_mod, init_type, init_cfg} | cfg_iex_to_erl(more_cfg)]
  end
  defp cfg_iex_to_erl ([{:init, [{init_mod, init_type}]} | more_cfg]) do
    [{:init, init_mod, init_type} | cfg_iex_to_erl(more_cfg)]
  end
  defp cfg_iex_to_erl ([{cfg_opt, cfg_val} | more_cfg]) do
    [{cfg_opt, cfg_val} | cfg_iex_to_erl(more_cfg)]
  end
  defp cfg_iex_to_erl ([]) do
    []
  end

end
