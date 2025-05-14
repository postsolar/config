import { $ } from "bun"

const modMaskMap = {
  "0": [],
  "1": [ "Shift" ],
  "4": [ "Ctrl" ],
  "5": [ "Ctrl", "Shift" ],
  "8": [ "Alt" ],
  "9": [ "Alt", "Shift" ],
  "12": [ "Ctrl", "Alt" ],
  "13": [ "Ctrl", "Alt", "Shift" ],
  "64": [ "Super" ],
  "65": [ "Super", "Shift" ],
  "68": [ "Super", "Ctrl" ],
  "69": [ "Super", "Ctrl", "Shift" ],
  "72": [ "Super", "Alt" ],
  "73": [ "Super", "Alt", "Shift" ],
  "76": [ "Super", "Ctrl", "Alt" ],
  "77": [ "Super", "Ctrl", "Alt", "Shift" ],
}

const submap = process.argv[2]

const submapBinds = $`hyprctl -j binds`
  .json()
  .then(binds => binds.filter(b => b.submap === submap))

const bindDisplay = b => {
  const mods = modMaskMap[b.modmask].join("+")
  const catchall = b.catch_all ? "catchall" : ""
  const key = `${mods}${mods === "" ? "" : "+"}${b.key}${catchall}`
  const dispatcher = Bun.escapeHTML(b.dispatcher)
  const arg = Bun.escapeHTML(b.arg)
  return `<span weight="bold" color="darkturquoise">${key}</span>: ${dispatcher} ${arg}`
}

const bindsDisplay =
  submapBinds.then(binds => binds.map(b => bindDisplay(b)).join("\n\n"))

const nwgWrapperArgs = [
  "--text", "/dev/stdin",
  "--layer", "3",
  "--justify", "center",
  "--sig_quit", "31",
  "--css", `${process.env.XDG_CONFIG_HOME}/nwg-wrapper/default.css`,
  "--position", "center",
  "--alignment", "end",
]

Bun.spawn(["nwg-wrapper", ...nwgWrapperArgs], {
  stdin: new Blob([await bindsDisplay])
})

