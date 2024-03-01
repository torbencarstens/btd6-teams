import definitions
import functools
import models
import money
import jesterfork
import std/[algorithm, enumutils, htmlgen, strformat, strutils]
from std/sequtils import toSeq

proc displayMap(m: Map, mode: Mode): string =
  `div`(
    `div`(fmt"{m.name} ({m.difficulty})", id="map-name"),
    `div`(fmt"{mode.name} ({mode.difficulty})", id="map-mode"),
  )

proc displayTower(t: Tower): string =
  `li`(t.name)

proc displayTowers(towers: openArray[Tower]): string =
  var html = "<ul>"
  for tower in towers:
    html.add displayTower(tower)

  html.add "</ul>"
  html

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

proc css(selectors: openArray[string], properties: openArray[(string, string)]): string =
  var css = selectors.join(",") & " {\n"

  for property in properties:
    css.add fmt"  {property[0]}: {property[1]};" & "\n"

  css & "}\n"

proc homepageLink*(request: Request): string =
  `div`(a("Return", href=fmt"/?{request.query()}"))

proc baseCss*(): string =
  strutils.join([
    css(["html"], [("background-color", "#222"), ("color", "#ddd")]),
    css(["#map-title", "#hero-title"], [("margin-top", "10px")]),
    css(["ul"], [("list-style", "none"), ("padding", "0"), ("margin-left", "10px"), ("margin-top", "0")]),
    css(["form"], [("margin-top", "10px")]),
    css(["select", "button"], [("display", "block"), ("margin-bottom", "5px")]),
    css(["#map-name", "#hero-name", "#map-mode"], [("margin-left", "10px")])
  ], "\n")

proc buildHtml*(bod: string, customCss: string = ""): string =
  "<!DOCTYPE html>" & html(
    head(
      meta(charset="utf-8"),
      title(fmt"btd6 team"),
      # while this isn't a valid PNG file (we literally don't have any content) browsers simply display their
      # default favicon which is usually some kind of representation of the globe
      link(rel="icon", `type`="image/png", href="data:image/png;base64,"),
      style(
        baseCss(),
        customCss,
      )
    ),
    body(
      bod
    )
  )

proc buildFrontpage*(sortedTowers: openArray[Tower], hero: Hero, rmap: Map, mode: Mode, count: int, max:int, difficultyParam: string, modeParam: string, ttypes: openArray[TowerType], towerSelection: openArray[Tower], heroSelection: openArray[Hero]): string =
  buildHtml(strutils.join([
    `div`("Towers"),
    displayTowers(sortedTowers),
    `div`("Hero", id="hero-title"),
    displayHero(hero),
    `div`("Map", id="map-title"),
    displayMap(rmap, mode),
    hr(),
    displayForm(count, max, difficultyParam, modeParam, ttypes, towerSelection, heroSelection),
  ], "\n"))

proc displayGoldRow(round: int, gold: int, total: int): string =
  tr(
    td(strutils.intToStr(round)),
    td(strutils.intToStr(gold)),
    td(strutils.intToStr(total)),
  )

proc displayMoneyTable(): string =
  var content = "<table>"

  content.add(tr(
    th("round"),
    th("gold (round)"),
    th("gold (total)"),
  ))
  for i in countTo(GOLD_PER_ROUND_COUNT - 1):
    content.add displayGoldRow(i + 1, goldForRound(i + 1).get(), estimateGold(i + 1).get())

  content

proc buildMoney*(): string =
  var moneyCss = css(@["table"], [("border-spacing", "12px")]) & css(@["th", "td"], [(" border-bottom", "2px solid black")])
  buildHtml(displayMoneyTable(), moneyCss)

proc buildMoneyParams*(params: (int, int)): string =
  let froGold = estimateGold(params[1])
  let toGold = estimateGold(params[0])

  if froGold.isNone or toGold.isNone:
    buildHtml("couldn't estimate gold for these rounds")
  else:
    buildHtml(strutils.intToStr(froGold.get() - toGold.get()))
