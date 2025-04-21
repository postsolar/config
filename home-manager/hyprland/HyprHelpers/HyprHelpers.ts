#! /usr/bin/env bun

// utils

const timestamp = (): string => `[${new Date().toUTCString()}]`
const log = (...args : Array<any>): void => console.log(timestamp(), ...args)
// const warn = (...args : Array<any>): void => console.warn(timestamp(), ...args)

const exec = (args : Array<string>): string =>
  Bun.spawnSync(args).stdout?.toString()

const minBy = <T>(f: (a: T) => number) => (as: Array<T>): T =>
  as.reduce((a, b) => f(a) < f(b) ? a : b)

const partition = <T>(f: (a: T) => boolean) => (as: Array<T>): { yes: Array<T>, no: Array<T> } =>
  as.reduce<{ yes: Array<T>, no: Array<T> }>(({ yes, no }, a) => f(a) ? { yes: [ ...yes, a ], no: no } : { yes: yes, no: [ ...no, a ] }, { yes: [], no: [] })

const last : <T>(as: Array<T>) => T | undefined = as => as[as.length - 1]

// hyprctl wrappers

const workspaceWindows = (): Array<HyWindow> => {
  const workspaceID = hyprget(["activeworkspace"]).id
  const windows = hyprget(["clients"]).filter((w : HyWindow) => w.workspace.id === workspaceID)
  return windows
}

const hyprdo = (args : Array<string>): void => {
  log(`executing: hyprctl dispatch -- ${args}`)
  log(exec(["hyprctl", "dispatch", "--", ...args]))
}

const hyprget = (args : Array<string>): any =>
  JSON.parse(exec(["hyprctl", "-j", ...args]))

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

const isMoveDirection = (d: string): d is MoveDirection => ["left", "right", "up", "down"].includes(d)

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

const moveTiled = (direction : MoveDirection, address : string, group : Array<string>): (() => void) => () =>
  group.length === 0
    ? hyprdo([`movewindoworgroup ${direction[0]}`])
    : direction === 'left' && group.indexOf(address) === 0
    ? hyprdo([`movewindoworgroup l`])
    : direction === 'left'
    ? hyprdo([`movegroupwindow b`])
    : direction == 'right' && address === last(group)
    ? hyprdo([`movewindoworgroup r`])
    : direction == 'right'
    ? hyprdo([`movegroupwindow f`])
    : hyprdo([`movewindoworgroup ${direction[0]}`])

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
  onCustomEvent(line, 'togglefocus', () => (toggleFocus(), true))

const handleMoveWindowOrGroup: LineHandler = line =>
  onCustomEvent(line, 'movewindoworgroup', args => (moveWindowOrGroup(args)(), true))

const handleLine = (line : string): void => {
  const lineHandlers = [
    handleMoveWindowOrGroup,
    handleToggleFocus
  ]
  lineHandlers.some(h => h(line))
}

export const main = async () =>{
  const decoder = new TextDecoder()
  const ipcPath = `${process.env.XDG_RUNTIME_DIR}/hypr/${process.env.HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock`
  const conn = Bun.spawn(["socat", "-U", "-", `UNIX-CONNECT:${ipcPath}`])
  log(`connected to Hyprland IPC at ${ipcPath}`)
  log(`pid: ${conn.pid}`)

  for await (const chunk of conn.stdout) {
    decoder.decode(chunk)
      .trim()
      .split("\n")
      .forEach(handleLine)
  }
}

main()

