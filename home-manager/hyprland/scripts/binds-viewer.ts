import { $ } from 'bun'

type HyBind = {
  "locked": boolean,
  "mouse": boolean,
  "release": boolean,
  "repeat": boolean,
  "longPress": boolean,
  "non_consuming": boolean,
  "has_description": boolean,
  "modmask": number,
  "submap": string,
  "key": string,
  "keycode": number,
  "catch_all": boolean,
  "description": string,
  "dispatcher": string,
  "arg": string,
}

const getBinds = async (): Promise<HyBind[]> => {
  return await $`hyprctl binds -j`.json()
}

// todo: add more
const humanizeModmask = {
  0: [],
  1: [ "Shift" ],
  4: [ "Control" ],
  5: [ "Control", "Shift" ],
  8: [ "Alt" ],
  12: [ "Control", "Alt" ],
  64: [ "Super" ],
  65: [ "Super", "Shift" ],
  68: [ "Super", "Control" ],
  72: [ "Super", "Alt" ],
  73: [ "Super", "Alt", "Shift" ],
  76: [ "Super", "Control", "Alt" ],
}

const showFields = [
  "submap",
  "key",
  "dispatcher",
  "arg",
  "description",
]

const filters : Array<((bind: HyBind) => boolean)> = [
  (bind => ! bind.catch_all)
]

const overEntries = (obj, f) => Object.fromEntries(f(Object.entries(obj)))

const main = async () => {
  const binds = await getBinds()

  return binds
    .filter(b => filters.every(f => f(b)))
    .map(b => {
      const mods = humanizeModmask[b.modmask]
      const key = b.keycode === 0 ? b.key : `[${b.keycode}]`
      const finalKey = mods.length === 0 ? key : `${mods.join("+")}+${key}`
      return overEntries({ ...b, key: finalKey},
        fields => fields.filter(([k, _v]) => showFields.includes(k))
      )
    })
}

console.log(JSON.stringify(await main()))
