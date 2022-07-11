import random
from enum import Enum
from typing import List

from flask import Flask

app = Flask(__name__)


class SkillProperty(Enum):
    CAMO = 0

    def camo(self):
        return self == SkillProperty.CAMO

    def __str__(self):
        return self.name.lower()


class Skill:
    def __init__(self, name: str, properties: List[SkillProperty]):
        self.name = name
        self.properties = properties

    def camo(self):
        return any(prop.camo() for prop in self.properties)


class TowerType(Enum):
    PRIMARY = 0
    MILITARY = 1
    MAGIC = 2
    SUPPORT = 3

    def __str__(self):
        return self.name.lower()

    def __lt__(self, other):
        return self.value < other.value


class Tower:
    def __init__(self, name: str, _type: TowerType, skills: List[Skill] = None):
        self.name = name
        self.skills = skills if skills else []
        self.type = _type

    def camo(self):
        return all(skill.camo() for skill in self.skills)

    def __str__(self):
        return self.name


class MapDifficulty(Enum):
    BEGINNER = 0
    INTERMEDIATE = 1
    ADVANCED = 2
    EXPERT = 3

    def __str__(self):
        return self.name.lower()


class Map:
    def __init__(self, name: str, difficulty: MapDifficulty):
        self.name = name
        self.difficulty = difficulty


MAPS = [
    Map("Monkey Meadow", MapDifficulty.BEGINNER),
    Map("Tree Stump", MapDifficulty.BEGINNER),
    Map("Town Center", MapDifficulty.BEGINNER),
    Map("Scrapyard", MapDifficulty.BEGINNER),
    Map("The Cabin", MapDifficulty.BEGINNER),
    Map("Resort", MapDifficulty.BEGINNER),
    Map("Skates", MapDifficulty.BEGINNER),
    Map("Lotus Island", MapDifficulty.BEGINNER),
    Map("Candy Falls", MapDifficulty.BEGINNER),
    Map("Winter Park", MapDifficulty.BEGINNER),
    Map("Carved", MapDifficulty.BEGINNER),
    Map("Park Path", MapDifficulty.BEGINNER),
    Map("Alpine Run", MapDifficulty.BEGINNER),
    Map("Frozen Over", MapDifficulty.BEGINNER),
    Map("In The Loop", MapDifficulty.BEGINNER),
    Map("Cubism", MapDifficulty.BEGINNER),
    Map("Four Circles", MapDifficulty.BEGINNER),
    Map("Hedge", MapDifficulty.BEGINNER),
    Map("End Of The Road", MapDifficulty.BEGINNER),
    Map("Logs", MapDifficulty.BEGINNER),
]

TOWER_NAMES = [
    Tower("Dart Monkey", TowerType.PRIMARY),
    Tower("Boomerang Monkey", TowerType.PRIMARY),
    Tower("Bomb Shooter", TowerType.PRIMARY),
    Tower("Tack Shooter", TowerType.PRIMARY),
    Tower("Ice Monkey", TowerType.PRIMARY),
    Tower("Glue Gunner", TowerType.PRIMARY),
    Tower("Sniper Monkey", TowerType.MILITARY),
    Tower("Monkey Sub", TowerType.MILITARY),
    Tower("Monkey Buccaneer", TowerType.MILITARY),
    Tower("Monkey Ace", TowerType.MILITARY),
    Tower("Heli Pilot", TowerType.MILITARY),
    Tower("Mortar Monkey", TowerType.MILITARY),
    Tower("Dartling Gunner", TowerType.MILITARY),
    Tower("Wizard Monkey", TowerType.MAGIC),
    Tower("Super Monkey", TowerType.MAGIC),
    Tower("Ninja Monkey", TowerType.MAGIC),
    Tower("Alchemist", TowerType.MAGIC),
    Tower("Druid", TowerType.MAGIC),
    Tower("Banana Farm", TowerType.SUPPORT),
    Tower("Spike Factory", TowerType.SUPPORT),
    Tower("Monkey Village", TowerType.SUPPORT),
    Tower("Engineer Monkey", TowerType.SUPPORT),
]


@app.route("/")
def index():
    TEAM_SIZE = 3
    team = set()
    while len(team) < TEAM_SIZE:
        choice = random.choice(TOWER_NAMES)
        team.add(choice)

    team = list(map(str, sorted(team, key=lambda t: t.type)))
    msg = "<h1>" + ", ".join(team) + "</h1>"
    msg += "<h3>" + random.choice(MAPS).name + "</h3>"

    return msg


app.run("0.0.0.0", 8080)
