type
  MapDifficulty* = enum
    BEGINNER = "Beginner",
    INTERMEDIATE = "Intermediate",
    ADVANCED = "Advanced",
    EXPERT = "Expert",

type
  Map* = object
    name*: string
    difficulty*: MapDifficulty

type
  TowerType* = enum
    PRIMARY = "Primary",
    MILITARY = "Military",
    MAGIC = "Magic",
    SUPPORT = "Support",

type
  Tower* = object
    name*: string
    ttype*: TowerType
