#! /usr/bin/env bun

// utils

const timestamp = (): string => `[${new Date().toUTCString()}]`
const log = (...args : Array<any>): void => console.log(timestamp(), ...args)

const exec = (args : Array<string>): string => {
  log(`executing: ${args}`)
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

// ironbar wrappers

// update Ironbar variables on hyprland submap and hyprscroller mode change
const updateIronvar = (var_: string, value: string): void => {
  exec(["ironbar", "var", "set", var_, value])
}

// types

type LineHandler = (line: string) => boolean

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

type MoveWindowOrGroupArgs = {
  direction: MoveDirection
  Δ: number
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

// main

const onCustomEvent = (line: string, eventName: string, callback: (args: any) => boolean): boolean => {
  if (line.match(/^custom>>/)) {
    const eventString = line.replace(/^custom>>/, "")
    const event = JSON.parse(eventString)
    if (event.name === eventName) {
      return callback(event.args)
    }
  }
  return false
}

const handleToggleFocus: LineHandler = line =>
  onCustomEvent(line, 'togglefocus', () => {
    toggleFocus()
    return true
  })

const handleMoveWindowOrGroup: LineHandler = line =>
  onCustomEvent(line, 'movewindoworgroup', args => {
    moveWindowOrGroup(args)()
    return true
  })

const handleSubmapChange: LineHandler = line => {
  if (line.match(/^submap>>/)) {
    const submap = line.replace(/^submap>>/, "")
    const varValue =
      submap === ""
        ? '<span color="gray">global</span>'
        : `<span color="hotpink" font-weight="bold">${submap}</span>`
    updateIronvar("hyprlandSubmap", varValue)
    return true
  }
  return false
}

const handleHyprscrollerModeChange: LineHandler = line => {
  if (line.match(/^scroller>>mode, /)) {
    const mode_ = line.match(/^scroller>>mode, (\w+)/)
    const mode = mode_ === null ? "oops" : mode_[1]
    const varValue = `<span color="azure" size="12pt">${mode === "row" ? "⇄" : "⇵"}</span>`
    updateIronvar("hyprscrollerMode", varValue)
    return true
  }
  return false
}

const handleLine = (line : string): void => {
  const lineHandlers = [
    handleMoveWindowOrGroup,
    handleToggleFocus,
    handleSubmapChange,
    handleHyprscrollerModeChange,
  ]
  lineHandlers.some(h => h(line))
}

export const main = async () =>{
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

