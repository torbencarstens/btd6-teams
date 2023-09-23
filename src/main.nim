import definitions
import jester
import models
import std/[algorithm, enumutils, envvars, htmlgen, httpclient, options, random, segfaults, strformat, strutils, times]
from std/sequtils import filter, map, toSeq

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

proc towerTypeFromString(ttype: string): Option[TowerType] =
  for ev in TowerType.toSeq:
    if ev.symbolName.toUpperAscii() == ttype.toUpperAscii():
      return some(ev)

  return none(TowerType)

proc heroFromString(hero: string): Option[Hero] =
  for ev in Hero.toSeq:
    if ev.symbolName.toUpperAscii() == hero.toUpperAscii():
      return some(ev)

  return none(Hero)

proc towerFromName(name: string): Option[Tower] =
  for tower in TOWERS:
    if tower.name == name:
      return some(tower)

  none(Tower)

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

proc randomHero(allowed: seq[Hero]): Hero =
  var heroes = Hero.toSeq
  if len(allowed) > 0:
    heroes = filter(heroes, proc(h: Hero): bool = h in allowed)
  random.sample(heroes)

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

proc displayTowerSelect(towers: openArray[Tower]): string =
  var html = "<select name='tower' multiple>"
  for tower in TOWERS:
    let value = tower.name
    if tower in towers or len(towers) == 0:
      html.add option(value, value=value, selected="true")
    else:
      html.add option(value, value=value)

  html & "</select>"

proc displayTowerTypeSelect(ttypes: openArray[TowerType]): string =
  var html = "<select name='ttype' multiple>"
  for ev in TowerType.toSeq:
    let value = fmt"{ev}"
    if ev in ttypes:
      html.add option(value, value=value, selected="true")
    else:
      html.add option(value, value=value)

  html & "</select>"

proc displayHeroSelect(selected: openArray[Hero]): string =
  var html = "<select name='hero' multiple>"
  var heroes = Hero.toSeq
  sort(heroes, proc(h1: Hero, h2: Hero): int = system.cmp(h1.symbolName, h2.symbolName))

  for ev in heroes:
    let value = fmt"{ev}".replace("_", " ")
    if ev in selected or len(selected) == 0:
      html.add option(value, value=value, selected="true")
    else:
      html.add option(value, value=value)

  html & "</select>"

proc displayForm(count: int, max: int, difficulty: string, mode: string, ttypes: openArray[TowerType],
                 towers: openArray[Tower], heroes: openArray[Hero]): string =
  form(
    displayMapDifficultySelect(difficulty),
    displayModeSelect(mode),
    displayCountSelect(count, max),
    displayTowerTypeSelect(ttypes),
    displayTowerSelect(towers),
    displayHeroSelect(heroes),
    button("Filter", `type`="submit")
  )

proc filterMap[N, V](list: openArray[V], filterProc: proc(v: V): bool, mapProc: proc(v: V): N): seq[N] =
  let filtered = filter(list, filterProc)
  sequtils.map(filtered, mapProc)

proc filterNone[V](list: openArray[Option[V]]): seq[V] =
  filterMap(
    list,
    proc(t: Option[V]): bool = t.isSome(),
    proc(t: Option[V]): V = t.get()
  )

proc css(selectors: openArray[string], properties: openArray[(string, string)]): string =
  var css = selectors.join(",") & " {\n"

  for property in properties:
    css.add fmt"  {property[0]}: {property[1]};" & "\n"

  css & "}\n"

proc homepageLink(request: Request): string =
  `div`(a("Return", href=fmt"/?{request.query()}"))

router btd6teams:
  # this is fine, don't worry about it
  get "/":
    let count = params(request).getOrDefault("count", "3").parseInt()
    let difficultyParam = params(request).getOrDefault("difficulty", "ANY").toUpperAscii()
    let modeParam = params(request).getOrDefault("mode", "").toUpperAscii()
    let ttypesWithNone = sequtils.map(paramValuesAsSeq(request).getOrDefault("ttype", @[]), towerTypeFromString)
    let ttypes: seq[TowerType] = filterNone(ttypesWithNone)
    let towerSelectionNone: seq[Option[Tower]] = sequtils.map(paramValuesAsSeq(request).getOrDefault("tower", @[]), towerFromName)
    let towerSelection: seq[Tower] = filterNone(towerSelectionNone)
    let heroSelectionWithNone = sequtils.map(paramValuesAsSeq(request).getOrDefault("hero", @[]), heroFromString)
    let heroSelection = filterNone(heroSelectionWithNone)

    let mapDifficulty = mapDifficultyFromString(difficultyParam)
    let mode = modeFromString(modeParam)
    if mapDifficulty.isNone():
      resp Http400, [("Content-Type", "text/plain")], fmt"there is no `{difficultyParam}` difficulty"
    if mode.isNone():
      resp Http400, [("Content-Type", "text/plain")], fmt"there is no `{modeParam}` mode"

    var towers: seq[Tower] = @TOWERS
    if isTypeOnlyMode(mode.get()):
      let ttype = getOnlyType(mode.get())
      towers = filterTowersForOnlyType(ttype, towers)
      if len(ttypes) > 0 and ttype notin ttypes:
        let ttypevalue = map(ttypes, proc(t: TowerType): string = fmt"{t}").join(", ")
        let message = fmt"mode ({mode.get().name}) is incompatible with tower type ({ttypevalue}) selection"
        resp Http400, [("Content-Type", "text/plain")], message
    if towerSelection.len() > 0:
      towers = filter(towerSelection, proc(t: Tower): bool = t in towers)

    let max = towers.len()

    if max == 0:
      resp Http400, fmt"your selection yielded 0 towers" & homepageLink(request)
    if max < count:
      resp Http400, fmt"your selection yielded {max} towers while your required count was {count}" & homepageLink(request)
    elif count > TOWER_COUNT:
      resp Http400, fmt"there are only {max} towers for the current selection" & homepageLink(request)
    elif count < 1:
      resp Http400, fmt"what do you need <1 towers for you buffon (hero only mode?)" & homepageLink(request)

    let randomTowers = getRandomTowers(count, towers)
    let sortedTowers = sorted(randomTowers, compareTowers)
    let hero = randomHero(heroSelection)

    let content = "<!DOCTYPE html>" & html(
        head(
          meta(charset="utf-8"),
          title(fmt"btd6 team"),
          # while this isn't a valid PNG file (we literally don't have any content) browsers simply display their
          # default favicon which is usually some kind of representation of the globe
          link(rel="icon", `type`="image/png", href="data:image/png;base64,"),
          style(
            css(["html"], [("background-color", "#222"), ("color", "#ddd")]),
            css(["#map-title", "#hero-title"], [("margin-top", "10px")]),
            css(["ul"], [("list-style", "none"), ("padding", "0"), ("margin-left", "10px"), ("margin-top", "0")]),
            css(["form"], [("margin-top", "10px")]),
            css(["select", "button"], [("display", "block"), ("margin-bottom", "5px")]),
            css(["#map-name", "#hero-name", "#map-mode"], [("margin-left", "10px")]),
          )
        ),
        body(
          `div`("Towers"),
          displayTowers(sortedTowers),
          `div`("Hero", id="hero-title"),
          displayHero(hero),
          `div`("Map", id="map-title"),
          displayMap(randomMap(mapDifficulty.get()), mode.get()),
          hr(),
          displayForm(count, max, difficultyParam, modeParam, ttypes, towerSelection, heroSelection),
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
