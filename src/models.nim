type
  MapDifficulty* = enum
    BEGINNER = "Beginner"
    INTERMEDIATE = "Intermediate"
    ADVANCED = "Advanced"
    EXPERT = "Expert"
    ANY

type
  Terrain* = enum
    Ground
    Water

type
  Map* = object
    name*: string
    difficulty*: MapDifficulty
    available_terrains*: seq[Terrain]

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
    placement_terrain*: Terrain

type
  Hero* = enum
    Quincy
    Gwendolin
    Striker_Jones
    Obyn_Greenfoot
    Captain_Churchill
    Benjamin
    Ezili
    Pat_Fusty
    Adora
    Admiral_Brickell
    Etienne
    Sauda
    Psi
    Geraldo
    Corvus

type
  ModeDifficulty* = enum
    EASY = "easy"
    MEDIUM = "medium"
    HARD = "hard"

type
  Mode* = object
    name*: string
    difficulty*: ModeDifficulty
