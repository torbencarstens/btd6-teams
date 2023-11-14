import models
from std/strutils import endsWith

const TOWER_COUNT* = 22
const TOWERS*: array[0..TOWER_COUNT - 1, Tower] = [
  Tower(name: "Dart Monkey", ttype: TowerType.PRIMARY, placement_terrain: Terrain.Ground),
  Tower(name: "Boomerang Monkey", ttype: TowerType.PRIMARY, placement_terrain: Terrain.Ground),
  Tower(name: "Bomb Shooter", ttype: TowerType.PRIMARY, placement_terrain: Terrain.Ground),
  Tower(name: "Tack Shooter", ttype: TowerType.PRIMARY, placement_terrain: Terrain.Ground),
  Tower(name: "Ice Monkey", ttype: TowerType.PRIMARY, placement_terrain: Terrain.Ground),
  Tower(name: "Glue Gunner", ttype: TowerType.PRIMARY, placement_terrain: Terrain.Ground),
  Tower(name: "Sniper Monkey", ttype: TowerType.MILITARY, placement_terrain: Terrain.Ground),
  Tower(name: "Monkey Sub", ttype: TowerType.MILITARY, placement_terrain: Terrain.Water),
  Tower(name: "Monkey Buccaneer", ttype: TowerType.MILITARY, placement_terrain: Terrain.Water),
  Tower(name: "Monkey Ace", ttype: TowerType.MILITARY, placement_terrain: Terrain.Ground),
  Tower(name: "Heli Pilot", ttype: TowerType.MILITARY, placement_terrain: Terrain.Ground),
  Tower(name: "Mortar Monkey", ttype: TowerType.MILITARY, placement_terrain: Terrain.Ground),
  Tower(name: "Dartling Gunner", ttype: TowerType.MILITARY, placement_terrain: Terrain.Ground),
  Tower(name: "Wizard Monkey", ttype: TowerType.MAGIC, placement_terrain: Terrain.Ground),
  Tower(name: "Super Monkey", ttype: TowerType.MAGIC, placement_terrain: Terrain.Ground),
  Tower(name: "Ninja Monkey", ttype: TowerType.MAGIC, placement_terrain: Terrain.Ground),
  Tower(name: "Alchemist", ttype: TowerType.MAGIC, placement_terrain: Terrain.Ground),
  Tower(name: "Druid", ttype: TowerType.MAGIC, placement_terrain: Terrain.Ground),
  Tower(name: "Banana Farm", ttype: TowerType.SUPPORT, placement_terrain: Terrain.Ground),
  Tower(name: "Spike Factory", ttype: TowerType.SUPPORT, placement_terrain: Terrain.Ground),
  Tower(name: "Monkey Village", ttype: TowerType.SUPPORT, placement_terrain: Terrain.Ground),
  Tower(name: "Engineer Monkey", ttype: TowerType.SUPPORT, placement_terrain: Terrain.Ground),
]

const MODE_COUNT* = 14
const MODES*: array[0..MODE_COUNT - 1, Mode] = [
  Mode(name: "Standard", difficulty: ModeDifficulty.EASY),
  Mode(name: "Primary only", difficulty: ModeDifficulty.EASY),
  Mode(name: "Deflation", difficulty: ModeDifficulty.EASY),
  Mode(name: "Standard", difficulty: ModeDifficulty.MEDIUM),
  Mode(name: "Military only", difficulty: ModeDifficulty.MEDIUM),
  Mode(name: "Apopalypse", difficulty: ModeDifficulty.MEDIUM),
  Mode(name: "Reverse", difficulty: ModeDifficulty.MEDIUM),
  Mode(name: "Standard", difficulty: ModeDifficulty.HARD),
  Mode(name: "Magic Monkeys only", difficulty: ModeDifficulty.HARD),
  Mode(name: "Double HP Moabs", difficulty: ModeDifficulty.HARD),
  Mode(name: "Half Cash", difficulty: ModeDifficulty.HARD),
  Mode(name: "Alternate Bloons Rounds", difficulty: ModeDifficulty.HARD),
  Mode(name: "Impoppable", difficulty: ModeDifficulty.HARD),
  Mode(name: "Chimps", difficulty: ModeDifficulty.HARD),
]

proc isTypeOnlyMode*(mode: Mode): bool =
  mode.name.endsWith(" only")

proc getOnlyType*(mode: Mode): TowerType =
  var ttype = TowerType.PRIMARY
  if mode.name == "Military only":
    ttype = TowerType.MILITARY
  elif mode.name == "Magic Monkeys only":
    ttype = TowerType.MAGIC

  ttype

const MAP_COUNT* = 69
const MAPS*: array[0..MAP_COUNT - 1, Map] = [
  Map(name: "Monkey Meadow", difficulty: MapDifficulty.BEGINNER, available_terrains: @[Terrain.Ground]),
  Map(name: "Tree Stump", difficulty: MapDifficulty.BEGINNER, available_terrains: @[Terrain.Ground]),
  Map(name: "Town Center", difficulty: MapDifficulty.BEGINNER, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Middle of the Road", difficulty: MapDifficulty.BEGINNER, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "One Two Tree", difficulty: MapDifficulty.BEGINNER, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Scrapyard", difficulty: MapDifficulty.BEGINNER, available_terrains: @[Terrain.Ground]),
  Map(name: "The Cabin", difficulty: MapDifficulty.BEGINNER, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Resort", difficulty: MapDifficulty.BEGINNER, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Skates", difficulty: MapDifficulty.BEGINNER, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Lotus Island", difficulty: MapDifficulty.BEGINNER, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Candy Falls", difficulty: MapDifficulty.BEGINNER, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Winter Park", difficulty: MapDifficulty.BEGINNER, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Carved", difficulty: MapDifficulty.BEGINNER, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Park Path", difficulty: MapDifficulty.BEGINNER, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Alpine Run", difficulty: MapDifficulty.BEGINNER, available_terrains: @[Terrain.Ground]),
  Map(name: "Frozen Over", difficulty: MapDifficulty.BEGINNER, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "In The Loop", difficulty: MapDifficulty.BEGINNER, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Cubism", difficulty: MapDifficulty.BEGINNER, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Four Circles", difficulty: MapDifficulty.BEGINNER, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Hedge", difficulty: MapDifficulty.BEGINNER, available_terrains: @[Terrain.Ground]),
  Map(name: "End of the Road", difficulty: MapDifficulty.BEGINNER, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Logs", difficulty: MapDifficulty.BEGINNER, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Water Park", difficulty: MapDifficulty.INTERMEDIATE, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Polyphemus", difficulty: MapDifficulty.INTERMEDIATE, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Covered Garden", difficulty: MapDifficulty.INTERMEDIATE, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Quarry", difficulty: MapDifficulty.INTERMEDIATE, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Quiet Street", difficulty: MapDifficulty.INTERMEDIATE, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Bloonarius Prime", difficulty: MapDifficulty.INTERMEDIATE, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Balance", difficulty: MapDifficulty.INTERMEDIATE, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Encrypted", difficulty: MapDifficulty.INTERMEDIATE, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Bazaar", difficulty: MapDifficulty.INTERMEDIATE, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Adora's Temple", difficulty: MapDifficulty.INTERMEDIATE, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Spring Spring", difficulty: MapDifficulty.INTERMEDIATE, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "KartsNDarts", difficulty: MapDifficulty.INTERMEDIATE, available_terrains: @[Terrain.Ground]),
  Map(name: "Moon Landing", difficulty: MapDifficulty.INTERMEDIATE, available_terrains: @[Terrain.Ground]),
  Map(name: "Haunted", difficulty: MapDifficulty.INTERMEDIATE, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Downstream", difficulty: MapDifficulty.INTERMEDIATE, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Firing Range", difficulty: MapDifficulty.INTERMEDIATE, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Cracked", difficulty: MapDifficulty.INTERMEDIATE, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Streambed", difficulty: MapDifficulty.INTERMEDIATE, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Chutes", difficulty: MapDifficulty.INTERMEDIATE, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Rake", difficulty: MapDifficulty.INTERMEDIATE, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Spice Islands", difficulty: MapDifficulty.INTERMEDIATE, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Erosion", difficulty: MapDifficulty.ADVANCED, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Midnight Mansion", difficulty: MapDifficulty.ADVANCED, available_terrains: @[Terrain.Ground]),
  Map(name: "Sunken Columns", difficulty: MapDifficulty.ADVANCED, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "X Factor", difficulty: MapDifficulty.ADVANCED, available_terrains: @[Terrain.Ground]),
  Map(name: "Mesa", difficulty: MapDifficulty.ADVANCED, available_terrains: @[Terrain.Ground]),
  Map(name: "Geared", difficulty: MapDifficulty.ADVANCED, available_terrains: @[Terrain.Ground]),
  Map(name: "Spillway", difficulty: MapDifficulty.ADVANCED, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Cargo", difficulty: MapDifficulty.ADVANCED, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Pat's Pond", difficulty: MapDifficulty.ADVANCED, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Peninsula", difficulty: MapDifficulty.ADVANCED, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "High Finance", difficulty: MapDifficulty.ADVANCED, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Another Brick", difficulty: MapDifficulty.ADVANCED, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Off The Coast", difficulty: MapDifficulty.ADVANCED, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Cornfield", difficulty: MapDifficulty.ADVANCED, available_terrains: @[Terrain.Ground]),
  Map(name: "Underground", difficulty: MapDifficulty.ADVANCED, available_terrains: @[Terrain.Ground]),
  Map(name: "Dark Dungeons", difficulty: MapDifficulty.EXPERT, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Sanctuary", difficulty: MapDifficulty.EXPERT, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Ravine", difficulty: MapDifficulty.EXPERT, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Flooded Valley", difficulty: MapDifficulty.EXPERT, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Infernal", difficulty: MapDifficulty.EXPERT, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Bloody Puddles", difficulty: MapDifficulty.EXPERT, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Workshop", difficulty: MapDifficulty.EXPERT, available_terrains: @[Terrain.Ground]),
  Map(name: "Quad", difficulty: MapDifficulty.EXPERT, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Dark Castle", difficulty: MapDifficulty.EXPERT, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "Muddy Puddles", difficulty: MapDifficulty.EXPERT, available_terrains: @[Terrain.Ground, Terrain.Water]),
  Map(name: "#Ouch", difficulty: MapDifficulty.EXPERT, available_terrains: @[Terrain.Ground, Terrain.Water]),
]
