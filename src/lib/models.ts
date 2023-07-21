export enum MapDifficulty {
    BEGINNER = "Beginner",
    INTERMEDIATE = "Intermediate",
    ADVANCED = "Advanced",
    EXPERT = "Expert",
}

export type Map = {
    name: string,
    difficulty: MapDifficulty,
}

export enum TowerType {
    PRIMARY = "Primary",
    MILITARY = "Military",
    MAGIC = "Magic",
    SUPPORT = "Support",
}

export type Tower = {
    name: string,
    type: TowerType,
}