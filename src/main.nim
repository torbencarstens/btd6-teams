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

proc compareTowerTypes(t1: TowerType, t2: TowerType): int =
  # `symbolRank` is defined in `std/enumutils`: "Returns the index in which a is listed in T."
  system.cmp(t1.symbolRank, t2.symbolRank)

proc compareTowers(t1: Tower, t2: Tower): int =
  compareTowerTypes(t1.ttype, t2.ttype)

proc getRandomTowers(count: int): seq[Tower] =
  var samples = TOWERS
  shuffle(samples)

  samples[0..count - 1]

proc randomMap(difficulty: MapDifficulty): Map =
  if difficulty != MapDifficulty.ANY:
    let maps = filter(MAPS, proc(d: Map): bool = d.difficulty == difficulty)
    sample(maps)
  else:
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

proc randomHero(): Hero =
  random.sample(Hero.toSeq)

proc displayHero(hero: Hero): string =
  let heroName = hero.symbolName.replace("_", " ")

  `div`(heroName, id="hero-name")

router btd6teams:
  get "/":
    let countParam = params(request).getOrDefault("count", "3")
    let count = parseInt(countParam);
    let difficultyParam = params(request).getOrDefault("difficulty", "ANY").toUpperAscii()

    let mapDifficulty = mapDifficultyFromString(difficultyParam)
    if mapDifficulty.isNone():
      # resp Http400, [{"Content-Type": "text/plain"}], fmt"Unknown map difficulty {mapDifficultyParam}"
      resp Http400, [("Content-Type", "text/plain")], fmt"there are only {TOWER_COUNT} towers"

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
                   #map-title, #hero-title { margin-top: 10px; }
                   #map-name, #hero-name { margin-left: 10px; }
                   ul { list-style: none; padding: 0; margin-left: 10px; margin-top: 0; }
          """),
        ),
        body(
          `div`("Towers"),
          displayTowers(sortedTowers),
          `div`("Hero", id="hero-title"),
          displayHero(randomHero()),
          `div`("Map", id="map-title"),
          displayMap(randomMap(mapDifficulty.get()))
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
