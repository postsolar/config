#! /usr/bin/env bun

import { $ } from "bun"

const bigIn = "8 8 8 8"
const bigOut = "20 25 25 25"

const smallIn = "2 2 2 2"
const smallOut = "0 5 5 5"

const get = async (dir: string) => {
  return (await $`hyprctl -j getoption general:gaps_${dir}`.json()).custom
}

const set = async (dir: string, gaps: string) => {
  await $`hyprctl keyword general:gaps_${dir} ${gaps.replace(/ /g, ', ')}`
}

const currIn = await get('in')
const currOut = await get('out')

console.log({ currIn, currOut })

if (currIn === bigIn && currOut === bigOut) {
  set('in', smallIn)
  set('out', smallOut)
} else if (currIn === smallIn && currOut === smallOut) {
  set('in', bigIn)
  set('out', bigOut)
}
