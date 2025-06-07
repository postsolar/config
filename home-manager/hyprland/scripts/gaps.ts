#! /usr/bin/env bun

import { $ } from "bun"

const scope =
  { "inner": "general:gaps_in",
    "outer": "general:gaps_out"
  }[process.argv[2]]

const Δ = parseInt(process.argv[3])

const new_ = (await $`hyprctl -j getoption ${scope}`.json())
  .custom
  .split(" ")
  .map(x => parseInt(x) + Δ)

await $`hyprctl keyword ${scope} ${new_}`

