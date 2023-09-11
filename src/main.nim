import definitions
import jester
import models
import std/[algorithm, enumutils, htmlgen, httpclient, random, strformat, strutils, times]

randomize(cpuTime().int)

proc compareTowerTypes(t1: TowerType, t2: TowerType): int =
  # `symbolRank` is defined in `std/enumutils`: "Returns the index in which a is listed in T."
  system.cmp(t1.symbolRank, t2.symbolRank)

proc compareTowers(t1: Tower, t2: Tower): int =
  compareTowerTypes(t1.ttype, t2.ttype)

proc getRandomTowers(count: int): seq[Tower] =
  var samples = TOWERS
  shuffle(samples)

  samples[0..count - 1]

proc randomMap(): Map =
  sample(MAPS)

proc displayMap(m: Map): string =
  `div`(fmt"{m.name} ({m.difficulty})", id="map-name")

proc displayTower(t: Tower): string =
  `li`(t.name)

proc displayTowers(towers: seq[Tower]): string =
  var html = "<ul>"
  for tower in towers:
    html.add displayTower(tower)

  html.add "</ul>"
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
          style("""html { background-color: #222; color: #ddd; }
                   #map-title { margin-top: 10px; }
                   #map-name { margin-left: 10px; }
                   ul { list-style: none; padding: 0; margin-left: 10px; margin-top: 0; }
          """),
        ),
        body(
          `div`("Towers"),
          displayTowers(sortedTowers),
          `div`("Map", id="map-title"),
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
