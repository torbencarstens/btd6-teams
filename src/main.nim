import definitions
import jester
import models
import std/[algorithm, enumutils, envvars, htmlgen, httpclient, options, random, strformat, strutils, times]
from std/sequtils import filter, toSeq

randomize(now().second)

proc mapDifficultyFromString*(value: string): Option[MapDifficulty] =
  for ev in MapDifficulty.toSeq:
    if ev.symbolName == value:
      return some(ev)

  return none(MapDifficulty)

proc modeFromString(value: string): Option[Mode] =
  if value == "":
    return some(sample(MODES))

  for mode in MODES:
    let name = mode.name.replace(" ", "_")
    let modeFormat = fmt"{mode.difficulty}-{name}".toLowerAscii()
    if modeFormat == value.toLowerAscii():
      return some(mode)

  return none(Mode)

proc filterTowersForOnlyType(ttype: TowerType, towers: openArray[Tower]): seq[Tower] =
  filter(towers, proc(tower: Tower): bool = tower.ttype == ttype)

proc compareTowerTypes(t1: TowerType, t2: TowerType): int =
  # `symbolRank` is defined in `std/enumutils`: "Returns the index in which a is listed in T."
  system.cmp(t1.symbolRank, t2.symbolRank)

proc compareTowers(t1: Tower, t2: Tower): int =
  compareTowerTypes(t1.ttype, t2.ttype)

proc getRandomTowers(count: int, towers: seq[Tower]): seq[Tower] =
  var samples = towers
  shuffle(samples)

  samples[0..count - 1]

proc randomMap(difficulty: MapDifficulty): Map =
  if difficulty != MapDifficulty.ANY:
    let maps = filter(MAPS, proc(d: Map): bool = d.difficulty == difficulty)
    sample(maps)
  else:
    sample(MAPS)

proc displayMap(m: Map, mode: Mode): string =
  `div`(
    `div`(fmt"{m.name} ({m.difficulty})", id="map-name"),
    `div`(fmt"{mode.name} ({mode.difficulty})", id="map-mode"),
  )

proc displayTower(t: Tower): string =
  `li`(t.name)

proc displayTowers(towers: seq[Tower]): string =
  var html = "<ul>"
  for tower in towers:
    html.add displayTower(tower)

  html.add "</ul>"
  html

proc randomHero(): Hero =
  random.sample(Hero.toSeq)

proc displayHero(hero: Hero): string =
  let heroName = hero.symbolName.replace("_", " ")

  `div`(heroName, id="hero-name")

proc displayMapDifficultySelect(difficulty: string): string =
  var html = "<select name='difficulty'>"
  for ev in MapDifficulty.toSeq:
    if ev.symbolName.toLowerAscii() == difficulty.toLowerAscii():
      html.add option(ev.symbolName, value=ev.symbolName, selected="true")
    else:
      html.add option(ev.symbolName, value=ev.symbolName)

  html & "</select>"

proc displayModeSelect(modeStr: string): string =
  var html = "<select name='mode'>"
  for mode in MODES:
    let name = mode.name.replace(" ", "_")
    let modeFormat = fmt"{mode.difficulty}-{name}".toLowerAscii()
    if modeStr.toLowerAscii() == modeFormat:
      html.add option(fmt"{mode.name} ({mode.difficulty})", value=modeFormat, selected="true")
    else:
      html.add option(fmt"{mode.name} ({mode.difficulty})", value=modeFormat)

  if modeStr == "":
    html.add option("Any", value="", selected="true")
  else:
    html.add option("Any", value="")
  html & "</select>"

proc displayCountSelect(count: int, max: int): string =
  var html = "<label for='count'>Tower count</count><select name='count'>"
  for i in 1..max:
    let number = fmt"{i}"
    if i == count:
      html.add option(number, value=number, selected="true")
    else:
      html.add option(number, value=number)

  html & "</select>"

proc displayForm(count: int, max: int, difficulty: string, mode: string): string =
  form(
    displayMapDifficultySelect(difficulty),
    displayModeSelect(mode),
    displayCountSelect(count, max),
    button("Filter", `type`="submit")
  )

proc css(selectors: openArray[string], properties: openArray[(string, string)]): string =
  var css = selectors.join(",") & " {\n"

  for property in properties:
    css.add fmt"  {property[0]}: {property[1]};" & "\n"

  css & "}\n"

router btd6teams:
  get "/":
    let countParam = params(request).getOrDefault("count", "3")
    let count = parseInt(countParam);
    let difficultyParam = params(request).getOrDefault("difficulty", "ANY").toUpperAscii()
    let modeParam = params(request).getOrDefault("mode", "").toUpperAscii()

    let mapDifficulty = mapDifficultyFromString(difficultyParam)
    let mode = modeFromString(modeParam)
    if mapDifficulty.isNone():
      resp Http400, [("Content-Type", "text/plain")], fmt"there is no `{difficultyParam}` difficulty"
    if mode.isNone():
      resp Http400, [("Content-Type", "text/plain")], fmt"there is no `{modeParam}` mode"

    if count > TOWER_COUNT:
      resp Http400, [("Content-Type", "text/plain")], fmt"there are only {TOWER_COUNT} towers"
    elif count < 1:
      resp Http400, [("Content-Type", "text/plain")], fmt"what do you need <1 towers for you buffon"

    var towers: seq[Tower] = @TOWERS
    if isTypeOnlyMode(mode.get()):
      let ttype = getOnlyType(mode.get())
      towers = filterTowersForOnlyType(ttype, towers)

    let max = towers.len()
    let randomTowers = getRandomTowers(count, towers)
    let sortedTowers = sorted(randomTowers, compareTowers)

    let content = "<!DOCTYPE html>" & html(
        head(
          meta(charset="utf-8"),
          title(fmt"btd6 team"),
          link(rel="icon", `type`="image/png", href="data:image/png;base64,iVBORw0KGgo="),
          style(
            css(["html"], [("background-color", "#222"), ("color", "#ddd")]),
            css(["#map-title", "#hero-title"], [("margin-top", "10px")]),
            css(["ul"], [("list-style", "none"), ("padding", "0"), ("margin-left", "10px"), ("margin-top", "0")]),
            css(["form"], [("margin-top", "10px")]),
            css(["select", "button"], [("display", "block"), ("margin-bottom", "5px")]),
          )
        ),
        body(
          `div`("Towers"),
          displayTowers(sortedTowers),
          `div`("Hero", id="hero-title"),
          displayHero(randomHero()),
          `div`("Map", id="map-title"),
          displayMap(randomMap(mapDifficulty.get()), mode.get()),
          hr(),
          displayForm(count, max, difficultyParam, modeParam),
        )
      )
    resp content

proc main() =
  let port = Port(parseInt(getEnv("PORT", "8080")))
  let settings = newSettings(port=port)
  var jester = initJester(btd6teams, settings=settings)
  jester.serve()

when isMainModule:
  main()
