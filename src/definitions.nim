import models
from std/strutils import endsWith

const TOWER_COUNT* = 22
const TOWERS*: array[0..TOWER_COUNT - 1, Tower] = [
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
  Map(name: "Water Park", difficulty: MapDifficulty.INTERMEDIATE),
  Map(name: "Polyphemus", difficulty: MapDifficulty.INTERMEDIATE),
  Map(name: "Covered Garden", difficulty: MapDifficulty.INTERMEDIATE),
  Map(name: "Quarry", difficulty: MapDifficulty.INTERMEDIATE),
  Map(name: "Quiet Street", difficulty: MapDifficulty.INTERMEDIATE),
  Map(name: "Bloonarius Prime", difficulty: MapDifficulty.INTERMEDIATE),
  Map(name: "Balance", difficulty: MapDifficulty.INTERMEDIATE),
  Map(name: "Encrypted", difficulty: MapDifficulty.INTERMEDIATE),
  Map(name: "Bazaar", difficulty: MapDifficulty.INTERMEDIATE),
  Map(name: "Adora's Temple", difficulty: MapDifficulty.INTERMEDIATE),
  Map(name: "Spring Spring", difficulty: MapDifficulty.INTERMEDIATE),
  Map(name: "KartsNDarts", difficulty: MapDifficulty.INTERMEDIATE),
  Map(name: "Moon Landing", difficulty: MapDifficulty.INTERMEDIATE),
  Map(name: "Haunted", difficulty: MapDifficulty.INTERMEDIATE),
  Map(name: "Downstream", difficulty: MapDifficulty.INTERMEDIATE),
  Map(name: "Firing Range", difficulty: MapDifficulty.INTERMEDIATE),
  Map(name: "Cracked", difficulty: MapDifficulty.INTERMEDIATE),
  Map(name: "Streambed", difficulty: MapDifficulty.INTERMEDIATE),
  Map(name: "Chutes", difficulty: MapDifficulty.INTERMEDIATE),
  Map(name: "Rake", difficulty: MapDifficulty.INTERMEDIATE),
  Map(name: "Spice Islands", difficulty: MapDifficulty.INTERMEDIATE),
  Map(name: "Erosion", difficulty: MapDifficulty.ADVANCED),
  Map(name: "Midnight Mansion", difficulty: MapDifficulty.ADVANCED),
  Map(name: "Sunken Columns", difficulty: MapDifficulty.ADVANCED),
  Map(name: "X Factor", difficulty: MapDifficulty.ADVANCED),
  Map(name: "Mesa", difficulty: MapDifficulty.ADVANCED),
  Map(name: "Geared", difficulty: MapDifficulty.ADVANCED),
  Map(name: "Spillway", difficulty: MapDifficulty.ADVANCED),
  Map(name: "Cargo", difficulty: MapDifficulty.ADVANCED),
  Map(name: "Pat's Pond", difficulty: MapDifficulty.ADVANCED),
  Map(name: "Peninsula", difficulty: MapDifficulty.ADVANCED),
  Map(name: "High Finance", difficulty: MapDifficulty.ADVANCED),
  Map(name: "Another Brick", difficulty: MapDifficulty.ADVANCED),
  Map(name: "Off The Coast", difficulty: MapDifficulty.ADVANCED),
  Map(name: "Cornfield", difficulty: MapDifficulty.ADVANCED),
  Map(name: "Underground", difficulty: MapDifficulty.ADVANCED),
  Map(name: "Dark Dungeons", difficulty: MapDifficulty.EXPERT),
  Map(name: "Sanctuary", difficulty: MapDifficulty.EXPERT),
  Map(name: "Ravine", difficulty: MapDifficulty.EXPERT),
  Map(name: "Flooded Valley", difficulty: MapDifficulty.EXPERT),
  Map(name: "Infernal", difficulty: MapDifficulty.EXPERT),
  Map(name: "Bloody Puddles", difficulty: MapDifficulty.EXPERT),
  Map(name: "Workshop", difficulty: MapDifficulty.EXPERT),
  Map(name: "Quad", difficulty: MapDifficulty.EXPERT),
  Map(name: "Dark Castle", difficulty: MapDifficulty.EXPERT),
  Map(name: "Muddy Puddles", difficulty: MapDifficulty.EXPERT),
  Map(name: "#Ouch", difficulty: MapDifficulty.EXPERT),
]
