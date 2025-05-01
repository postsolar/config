// Subscribes to Niri's keyboard layout change events and outputs
// layout changes as emoji (or 3-letter fallback if layout is not recognized)

import { Glob } from "bun"

const proc = Bun.spawn(["niri", "msg", "--json", "event-stream"])
const decoder = new TextDecoder()

const checkIfInitState = (events: any[]) =>
  events.length === 3
    && "WorkspacesChanged" in events[0]
    && "WindowsChanged" in events[1]
    && "KeyboardLayoutsChanged" in events[2]

let layoutNames: Array<string>

const layoutMap =
  Object.entries({
    'English*': '🇺🇸',
    'Estonian*': '🇪🇪',
    'Russian*': '🇷🇺'
  })

const showLayout = (lyt: string): string => {
  const patAndText = layoutMap.find(([pat, text]) => new Glob(pat).match(lyt))
  if (patAndText === undefined) {
    return lyt.substring(0, 3).toLocaleUpperCase()
  } else {
    return patAndText[1]
  }
}

for await (const chunk of proc.stdout) {
  const events = decoder.decode(chunk).trim().split("\n").map(JSON.parse)

  if (checkIfInitState(events)) {
    const { KeyboardLayoutsChanged } = events[2]
    const { names, current_idx } = KeyboardLayoutsChanged.keyboard_layouts
    layoutNames = names
    console.log(showLayout(layoutNames[current_idx]))
  } else {
    events.forEach(e =>
      ("KeyboardLayoutSwitched" in e) && console.log(showLayout(layoutNames[e.KeyboardLayoutSwitched.idx]))
    )
  }
}
