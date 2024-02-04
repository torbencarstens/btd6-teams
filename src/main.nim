import definitions
import functools
import jesterfork
import models
import std/[algorithm, enumutils, envvars, httpclient, options, random, strformat, strutils, times]
from std/sequtils import filter, map, toSeq
import view

# https://bloons.fandom.com/wiki/Rounds_(BTD6)#List_of_rounds
# see `estimate_gold.nim`
# covers the first 140 rounds
let goldPerRound = @[771, 908, 1046, 1221, 1385, 1548, 1730, 1930, 2129, 2443, 2632, 2824, 3106, 3365, 3631, 3899, 4064, 4422, 4682, 4868, 5219, 5517, 5794, 5961, 6296, 6629, 7291, 7557, 7946, 8283, 8820, 9447, 9652, 10564, 11714, 12610, 13949, 15226, 16985, 17506, 19687, 20346, 21624, 22918, 25340, 26056, 27693, 30536, 35294, 38310, 39333, 40852, 41700, 43821, 46226, 47435, 49215, 51434, 53514, 54356, 55459, 56716, 59412, 60130, 63070, 63941, 64831, 65475, 66730, 69213, 70579, 71946, 73200, 76105, 78632, 79807, 82206, 86926, 93491, 94748, 99969, 104580, 109183, 116080, 118557, 119338, 121797, 124942, 126943, 127111, 131130, 135495, 137268, 144760, 148303, 158082, 159322, 168798, 171446, 172801, 173374, 175633, 181611, 189009, 193215, 194997, 198666, 204472, 211922, 214410, 223877, 225756, 228738, 234143, 239548, 243492, 244447, 248690, 250703, 255747, 257124, 258990, 261494, 263786, 266284, 267043, 268145, 269742, 271758, 273317, 275518, 278475, 281919, 283144, 285017, 286485, 289784, 290749, 292681, 293220]

proc estimateGold(round: int): Option[int] =
  try:
    some goldPerRound[round - 1]
  except:
    return none(int)

proc canPlace(tower: Tower, map: Map): bool =
  tower.placement_terrain in map.available_terrains

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

proc filterTowersByType(towers: openArray[Tower], ttype: TowerType): seq[Tower] =
  sequtils.filter(towers, proc(tower: Tower): bool = tower.ttype == ttype)

proc compareTowerTypes(t1: TowerType, t2: TowerType): int =
  # `symbolRank` is defined in `std/enumutils`: "Returns the index in which a is listed in T."
  system.cmp(t1.symbolRank, t2.symbolRank)

proc compareTowers(t1: Tower, t2: Tower): int =
  compareTowerTypes(t1.ttype, t2.ttype)

proc getRandomTowers(count: int, towers: seq[Tower], map: Map): seq[Tower] =
  var samples = sequtils.filter(towers, proc(tower: Tower): bool = tower.placement_terrain in map.available_terrains)

  random.shuffle(samples)

  samples[0..count - 1]

proc randomMap(difficulty: MapDifficulty): Map =
  if difficulty != MapDifficulty.ANY:
    let maps = sequtils.filter(MAPS, proc(d: Map): bool = d.difficulty == difficulty)
    random.sample(maps)
  else:
    random.sample(MAPS)

proc filterTowersForMapTerrain(towers: openArray[Tower], map: Map): seq[Tower] =
  sequtils.filter(towers, proc(tower: Tower): bool = canPlace(tower, map))

proc randomHero(allowed: seq[Hero]): Hero =
  var heroes = Hero.toSeq
  if len(allowed) > 0:
    heroes = sequtils.filter(heroes, proc(h: Hero): bool = h in allowed)

  random.sample(heroes)

proc getParamListMapped[IV, V](request: Request, key: string, default: seq[string], map_fn: proc(s: string): IV {.gcsafe.}): seq[V] =
  let intermediate = sequtils.map(
      paramValuesAsSeq(request).getOrDefault(key, default),
      map_fn
    )
  functools.filterNone(intermediate)

proc getParamMapped[V](request: Request, key: string, default: string, map_fn: proc(s: string): V {.gcsafe.}): V =
  map_fn(params(request).getOrDefault(key, default))

proc getAllFormParams(request: Request): (int, string, string, seq[TowerType], seq[Tower], seq[Hero]) =
  let count: int = getParamMapped(request, "count", "3", parseInt)
  let difficultyParam = getParamMapped(request, "difficulty", "ANY", toUpperAscii)
  let modeParam = getParamMapped(request, "mode", "", toUpperAscii)

  let ttypes = getParamListMapped[Option[TowerType], TowerType](request, "ttype", @[], towerTypeFromString)
  let towerSelection = getParamListMapped[Option[Tower], Tower](request, "tower", @[], towerFromName)
  let heroSelection = getParamListMapped[Option[Hero], Hero](request, "hero", @[], heroFromString)

  (count, difficultyParam, modeParam, ttypes, towerSelection, heroSelection)

proc filterMapForTerrain(mapDifficulty: MapDifficulty, towerSelection: openArray[Tower], count: int): Option[Map] =
  var rmap = none(Map)
  var ftowers: seq[Tower] = @[]
  var count = 0

  # 100 is completely arbitrary
  while rmap.isNone and count < 100:
    var m = randomMap(mapDifficulty)
    ftowers = filterTowersForMapTerrain(towerSelection, m)
    if ftowers.len() >= count:
      rmap = some(m)

    count += 1

  rmap

router btd6teams:
  # this is fine, don't worry about it
  get "/":
    let (count, difficultyParam, modeParam, ttypes, towerSelection, heroSelection) = getAllFormParams(request)

    let mapDifficultyOpt = mapDifficultyFromString(difficultyParam)
    let modeOpt = modeFromString(modeParam)
    if mapDifficultyOpt.isNone():
      resp Http400, [("Content-Type", "text/plain")], fmt"there is no `{difficultyParam}` difficulty"
    if modeOpt.isNone():
      resp Http400, [("Content-Type", "text/plain")], fmt"there is no `{modeParam}` mode"

    let mode = modeOpt.get()
    let mapDifficulty = mapDifficultyOpt.get()

    var towers: seq[Tower] = @TOWERS

    if isTowerTypeOnlyMode(mode):
      let ttype = getOnlyTowerType(mode)
      towers = filterTowersByType(towers, ttype)
      if len(ttypes) > 0 and ttype notin ttypes:
        let ttypevalue = sequtils.map(ttypes, proc(t: TowerType): string = fmt"{t}").join(", ")
        let message = fmt"mode ({mode.name}) is incompatible with tower type ({ttypevalue}) selection"
        resp Http400, [("Content-Type", "text/plain")], message

    if towerSelection.len() > 0:
      towers = sequtils.filter(towerSelection, proc(t: Tower): bool = t in towers)

    let rmapOpt = filterMapForTerrain(mapDifficulty, towers, count)
    if rmapOpt.isNone:
      resp Http400, "couldn't find a map for the chosen filters"

    let rmap = rmapOpt.get()

    let max = towers.len()
    if max == 0:
      resp Http400, fmt"your selection yielded 0 towers" & homepageLink(request)
    if max < count:
      resp Http400, fmt"your selection yielded {max} towers while your required count was {count}" & homepageLink(request)
    elif count > TOWER_COUNT:
      resp Http400, fmt"there are only {max} towers for the current selection" & homepageLink(request)
    elif count < 1:
      resp Http400, fmt"what do you need <1 towers for you buffon (hero only mode?)" & homepageLink(request)

    let randomTowers = getRandomTowers(count, towers, rmap)
    let sortedTowers = sorted(randomTowers, compareTowers)
    let hero = randomHero(heroSelection)

    let content = buildHtml(sortedTowers, hero, rmap, mode, count, max, difficultyParam, modeParam, ttypes, towerSelection, heroSelection)

    resp content

proc main() =
  let port = Port(parseInt(getEnv("PORT", "8080")))
  let settings = newSettings(port=port)
  var jester = initJester(btd6teams, settings=settings)
  jester.serve()

when isMainModule:
  randomize(now().second)
  main()
