#! /usr/bin/env bun

// types

type HyWindow = {
  at: [ number, number ]
  size: [ number, number ]
  address: string
  focusHistoryID: number
  workspace: { id: number }
  floating: boolean
  fullscreen: number
  grouped: Array<string>
}

type MoveDirection = "left" | "right" | "up" | "down"

type MoveWindowOrGroupArgs = {
  direction: MoveDirection
  Δ: number
}

// state

let hyprscrollerMode = 'row'

// utils

const timestamp = (): string => `[${new Date().toUTCString()}]`
const log = (...args : Array<any>): void => console.log(timestamp(), ...args)

const exec = (args : Array<string>): string => {
  log(`executing: ${args.join(' ')}`)
  return Bun.spawnSync(args).stdout?.toString()
}

const minBy = <T>(f: (a: T) => number) => (as: Array<T>): T =>
  as.reduce((a, b) => f(a) < f(b) ? a : b)

const partition = <T>(f: (a: T) => boolean) => (as: Array<T>): { yes: Array<T>, no: Array<T> } =>
  as.reduce<{ yes: Array<T>, no: Array<T> }>(({ yes, no }, a) => f(a) ? { yes: [ ...yes, a ], no: no } : { yes: yes, no: [ ...no, a ] }, { yes: [], no: [] })

// hyprctl wrappers

const workspaceWindows = (): Array<HyWindow> => {
  const workspaceID = hyprget(["activeworkspace"]).id
  const windows = hyprget(["clients"]).filter((w : HyWindow) => w.workspace.id === workspaceID)
  return windows
}

const hyprdo = (args : Array<string>): void => {
  log(exec(["hyprctl", "dispatch", "--", ...args]))
}

const hyprget = (args : Array<string>): any =>
  JSON.parse(exec(["hyprctl", "-j", ...args]))

const hyprset = (args : Array<string>): void =>
  log(exec(["hyprctl", "keyword", ...args]))

// ironbar wrappers

// update Ironbar variables on hyprscroller mode change
const updateIronvar = (var_: string, value: string): void => {
  exec(["ironbar", "var", "set", var_, value])
}

// intra-workspace window moving

const moveFloating = (direction : MoveDirection, Δ : number, address : string): (() => void) => () => {
  const resizeParams = {
    "left": `-${Δ} 0`,
    "right": `${Δ} 0`,
    "up": `0 -${Δ}`,
    "down": `0 ${Δ}`
  }
  hyprdo([`movewindowpixel ${resizeParams[direction]},address:${address}`])
}

// map left/right/up/down to l/r/u/d
const moveDirectionToHyDirection = (direction : MoveDirection): string =>
  direction[0]

const moveTiled = (direction : MoveDirection, address : string, group : Array<string>): (() => void) => () => {
  const emptyGroup = group.length === 0
  const moveLeft = direction === "left"
  const moveRight = direction === "right"
  const firstInGroup = group.indexOf(address) === 0
  const lastInGroup = group.indexOf(address) === group.length - 1

  const command =
    emptyGroup
      ? `movewindoworgroup ${moveDirectionToHyDirection(direction)}`
      : (moveLeft && firstInGroup)
      ? "movewindoworgroup l"
      : moveLeft
      ? "movegroupwindow b"
      : (moveRight && lastInGroup)
      ? "movewindoworgroup r"
      : moveRight
      ? "movegroupwindow f"
      : `movewindoworgroup ${moveDirectionToHyDirection(direction)}`

  hyprdo([command])
}

const moveWindowOrGroup = (args: MoveWindowOrGroupArgs): (() => void) => () => {
  const { address, floating, grouped } = hyprget(["activewindow"])
  floating
    ? moveFloating(args.direction, args.Δ, address)()
    : moveTiled(args.direction, address, grouped)()
}

// other utils

// Toggle focus between floating and tiled windows
// This can be achieved with `hyprctl dispatch focuswindow tiled/floating`, but it doesn't remember which one was last focused
const toggleFocus = (): void => {
  const windows = workspaceWindows()
  const currentFloating = windows.find(w => w.focusHistoryID === 0)?.floating
  const { yes: floatingWs, no: tiledWs } = partition<HyWindow>(w => w.floating)(windows)
  if (floatingWs.length === 0 || tiledWs.length === 0)
    return
  const lastFocused = minBy<HyWindow>(w => w.focusHistoryID)(currentFloating ? tiledWs : floatingWs)
  hyprdo([`focuswindow address:${lastFocused.address}`])
}

// Toggle between `row` and `column` mode for hyprscroller
//
// Change of stateful `let hyprscrollerMode` within HyprHelpers is done by `handleHyprscrollerModeChange`,
// and happens when Hyprland IPC notifies us about the successful change, so no need to set it here
const toggleHyprscrollerMode = () => {
  const nextMode = hyprscrollerMode === 'row' ? 'column' : 'row'
  hyprdo([`scroller:setmode ${nextMode}`])
}

// main

const onCustomEvent = (json: string): void => {
  const event = JSON.parse(json)

  const customEventsMap = {
    toggleHyprscrollerMode: toggleHyprscrollerMode,
    movewindoworgroup: moveWindowOrGroup,
    togglefocus: toggleFocus,
  }

  event.name in customEventsMap && customEventsMap[event.name](event.args)
}

const onScrollerChange = (change: string): void => {
  const [ event, ...args ] = change.split(/, /)
  const eventMap = {
    mode: (args: Array<string>): void => {
      const newMode = args[0]
      hyprscrollerMode = newMode
      const modeDisplay = `${newMode === "row" ? "⇒" : "⇓"}`
      updateIronvar("hyprscrollerMode", modeDisplay)
    },
  }

  event in eventMap && eventMap[event](args)
}

const handleLine = (line: string): void => {
  const [ event, ...rest_ ] = line.split(/>>/)
  const rest = rest_.join(">>")

  const eventMap: Record<string, ((args: string) => void)> = {
    custom: onCustomEvent,
    scroller: onScrollerChange,
  }

  event in eventMap && eventMap[event](rest)
}

export const main = async () => {
  Bun.connect({
    unix: `${process.env.XDG_RUNTIME_DIR}/hypr/${process.env.HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock`,

    socket: {
      data(_socket, data) {
        data.toString("utf8")
          .trim()
          .split("\n")
          .forEach(handleLine)
      },

      end(_socket) {
        log("Socket was closed.")
        process.exit(1)
      },
    }
  })
}

main()

