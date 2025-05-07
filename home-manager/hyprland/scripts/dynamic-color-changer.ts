import { $ } from "bun"

const nameToHex = async (color : string) => {
  return (await $`pastel format hex ${color}`.text()).trim().replace("#", "")
}

const preview = async (keyword : string, color : string) => {
  const colorHex = await nameToHex(color)
  await $`unbuffer pastel color ${color}`
  await $`hyprctl keyword ${keyword} 0xff${colorHex}`
}

const printPick = async (keyword : string, value : string) => {
  const go = (indent : number, path : Array<string>) => {
    const indentS = '  '.repeat(indent)
    const indentSClose = '  '.repeat(indent - 1)
    return (path.length === 1)
      ? `${path[0]} = 0xff${value}`
      : `${path[0]} {\n${indentS}${go(indent + 1, path.slice(1))}\n${indentSClose}}`
  }

  return `${go(1, keyword.split(':'))}\n`
}

const main = async () => {
  if (process.argv[2] === 'preview') {
    preview(process.argv[3], process.argv[4])
  } else {
    const keyword = process.argv[2]

    const pick = await $`unbuffer pastel list | fzf --preview "${process.argv[0]} ${import.meta.path} preview ${keyword} {}"`.quiet()
    const pick_ = pick.text()
    if (pick.exitCode === 0 && pick_ !== '') {
      const colorHex = await nameToHex(pick_)
      console.log(await printPick(keyword, colorHex))
    }
  }
}

main()


