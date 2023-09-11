import jester
import models
import std/[algorithm, enumutils, htmlgen, httpclient, random, strformat, strutils, times]

randomize(cpuTime().int)

proc compareTowerTypes(t1: TowerType, t2: TowerType): int =
  # `symbolRank` is defined in `std/enumutils`: "Returns the index in which a is listed in T."
  system.cmp(t1.symbolRank, t2.symbolRank)

proc compareTowers(t1: Tower, t2: Tower): int =
  compareTowerTypes(t1.ttype, t2.ttype)

const TOWER_COUNT = 22
const towers: array[0..TOWER_COUNT - 1, Tower] = [
  Tower(name: "Dart Monkey", ttype: TowerType.PRIMARY),
  Tower(name: "Boomerang Monkey", ttype: TowerType.PRIMARY),
  Tower(name: "Bomb Shooter", ttype: TowerType.PRIMARY),
  Tower(name: "Tack Shooter", ttype: TowerType.PRIMARY),
  Tower(name: "Ice Monkey", ttype: TowerType.PRIMARY),
  Tower(name: "Glue Gunner", ttype: TowerType.PRIMARY),
  Tower(name: "Sniper Monkey", ttype: TowerType.MILITARY),
  Tower(name: "Monkey Sub", ttype: TowerType.MILITARY),
  Tower(name: "Monkey Buccaneer", ttype: TowerType.MILITARY),
  Tower(name: "Monkey Ace", ttype: TowerType.MILITARY),
  Tower(name: "Heli Pilot", ttype: TowerType.MILITARY),
  Tower(name: "Mortar Monkey", ttype: TowerType.MILITARY),
  Tower(name: "Dartling Gunner", ttype: TowerType.MILITARY),
  Tower(name: "Wizard Monkey", ttype: TowerType.MAGIC),
  Tower(name: "Super Monkey", ttype: TowerType.MAGIC),
  Tower(name: "Ninja Monkey", ttype: TowerType.MAGIC),
  Tower(name: "Alchemist", ttype: TowerType.MAGIC),
  Tower(name: "Druid", ttype: TowerType.MAGIC),
  Tower(name: "Banana Farm", ttype: TowerType.SUPPORT),
  Tower(name: "Spike Factory", ttype: TowerType.SUPPORT),
  Tower(name: "Monkey Village", ttype: TowerType.SUPPORT),
  Tower(name: "Engineer Monkey", ttype: TowerType.SUPPORT),
]

const MAP_COUNT = 22
const maps: array[0..MAP_COUNT - 1, Map] = [
  Map(name: "Monkey Meadow", difficulty: MapDifficulty.BEGINNER),
  Map(name: "Tree Stump", difficulty: MapDifficulty.BEGINNER),
  Map(name: "Town Center", difficulty: MapDifficulty.BEGINNER),
  Map(name: "Middle of the Road", difficulty: MapDifficulty.BEGINNER),
  Map(name: "One Two Tree", difficulty: MapDifficulty.BEGINNER),
  Map(name: "Scrapyard", difficulty: MapDifficulty.BEGINNER),
  Map(name: "The Cabin", difficulty: MapDifficulty.BEGINNER),
  Map(name: "Resort", difficulty: MapDifficulty.BEGINNER),
  Map(name: "Skates", difficulty: MapDifficulty.BEGINNER),
  Map(name: "Lotus Island", difficulty: MapDifficulty.BEGINNER),
  Map(name: "Candy Falls", difficulty: MapDifficulty.BEGINNER),
  Map(name: "Winter Park", difficulty: MapDifficulty.BEGINNER),
  Map(name: "Carved", difficulty: MapDifficulty.BEGINNER),
  Map(name: "Park Path", difficulty: MapDifficulty.BEGINNER),
  Map(name: "Alpine Run", difficulty: MapDifficulty.BEGINNER),
  Map(name: "Frozen Over", difficulty: MapDifficulty.BEGINNER),
  Map(name: "In The Loop", difficulty: MapDifficulty.BEGINNER),
  Map(name: "Cubism", difficulty: MapDifficulty.BEGINNER),
  Map(name: "Four Circles", difficulty: MapDifficulty.BEGINNER),
  Map(name: "Hedge", difficulty: MapDifficulty.BEGINNER),
  Map(name: "End of the Road", difficulty: MapDifficulty.BEGINNER),
  Map(name: "Logs", difficulty: MapDifficulty.BEGINNER),
]

proc getRandomTowers(count: int): seq[Tower] =
  var samples = towers
  shuffle(samples)

  samples[0..count - 1]

proc randomMap(): Map =
  sample(maps)

proc displayMap(m: Map): string =
  `div`(fmt"{m.name} ({m.difficulty})")

proc displayTower(t: Tower): string =
  `div`(t.name)

proc displayTowers(towers: seq[Tower]): string =
  var html = ""
  for tower in towers:
    html.add displayTower(tower)

  html

router btd6teams:
  get "/":
    redirect("/3")
  get "/@count":
    let count = parseInt(@"count")
    if count > TOWER_COUNT:
      resp Http400, [("Content-Type", "text/plain")], fmt"there are only {TOWER_COUNT} towers"
    elif count < 1:
      resp Http400, [("Content-Type", "text/plain")], fmt"what do you need <1 towers for you buffon"

    let randomTowers = getRandomTowers(count)
    let sortedTowers = sorted(randomTowers, compareTowers)

    let content = "<!DOCTYPE html>" & html(
        head(
          meta(charset="utf-8"),
          title(fmt"btd6 team"),
          link(rel="icon", `type`="image/png", href="data:image/png;base64,iVBORw0KGgo="),
          style("html { background-color: #222; color: #ddd; } #map-title { margin-top: 10px; }"),
        ),
        body(
          `div`("Towers:"),
          displayTowers(sortedTowers),
          `div`("Map:", id="map-title"),
          displayMap(randomMap())
        )
      )
    resp content

proc main() =
  let port = Port(8080)
  let settings = newSettings(port=port)
  var jester = initJester(btd6teams, settings=settings)
  jester.serve()

when isMainModule:
  main()
