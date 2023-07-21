open Opium

type tower_type = PRIMARY | MILITARY | MAGIC | SUPPORT

type map_difficulty = BEGINNER | INTERMEDIATE | ADVANCED | EXPERT

type tower = { name : string; _type : tower_type; ordering : int }

type map = { map_name : string; difficulty : map_difficulty; map_ordering : int }

let towers : tower list =
  [
    { name = "Dart Monkey"; _type = PRIMARY; ordering = 0 };
    { name = "Boomerang Monkey"; _type = PRIMARY; ordering = 1 };
    { name = "Bomb Shooter"; _type = PRIMARY; ordering = 2 };
    { name = "Tack Shooter"; _type = PRIMARY; ordering = 3 };
    { name = "Ice Monkey"; _type = PRIMARY; ordering = 4 };
    { name = "Glue Gunner"; _type = PRIMARY; ordering = 5 };
    { name = "Sniper Monkey"; _type = MILITARY; ordering = 6 };
    { name = "Monkey Sub"; _type = MILITARY; ordering = 7 };
    { name = "Monkey Buccaneer"; _type = MILITARY; ordering = 8 };
    { name = "Monkey Ace"; _type = MILITARY; ordering = 9 };
    { name = "Heli Pilot"; _type = MILITARY; ordering = 10 };
    { name = "Mortar Monkey"; _type = MILITARY; ordering = 11 };
    { name = "Dartling Gunner"; _type = MILITARY; ordering = 12 };
    { name = "Wizard Monkey"; _type = MAGIC; ordering = 13 };
    { name = "Super Monkey"; _type = MAGIC; ordering = 14 };
    { name = "Ninja Monkey"; _type = MAGIC; ordering = 15 };
    { name = "Alchemist"; _type = MAGIC; ordering = 16 };
    { name = "Druid"; _type = MAGIC; ordering = 17 };
    { name = "Banana Farm"; _type = SUPPORT; ordering = 18 };
    { name = "Spike Factory"; _type = SUPPORT; ordering = 19 };
    { name = "Monkey Village"; _type = SUPPORT; ordering = 20 };
    { name = "Engineer Monkey"; _type = SUPPORT; ordering = 21 };
    { name = "Beast Handler"; _type = SUPPORT; ordering = 22 };
  ]

let maps : map list =
  [
    { map_name = "Monkey Meadow"; difficulty = BEGINNER; map_ordering = 0 };
    { map_name = "Tree Stump"; difficulty = BEGINNER; map_ordering = 1 };
    { map_name = "Town Center"; difficulty = BEGINNER; map_ordering = 2 };
    { map_name = "Middle of the Road"; difficulty = BEGINNER; map_ordering = 3 };
    { map_name = "One Two Tree"; difficulty = BEGINNER; map_ordering = 4 };
    { map_name = "Scrapyard"; difficulty = BEGINNER; map_ordering = 5 };
    { map_name = "The Cabin"; difficulty = BEGINNER; map_ordering = 6 };
    { map_name = "Resort"; difficulty = BEGINNER; map_ordering = 7 };
    { map_name = "Skates"; difficulty = BEGINNER; map_ordering = 8 };
    { map_name = "Lotus Island"; difficulty = BEGINNER; map_ordering = 9 };
    { map_name = "Candy Falls"; difficulty = BEGINNER; map_ordering = 10 };
    { map_name = "Winter Park"; difficulty = BEGINNER; map_ordering = 11 };
    { map_name = "Carved"; difficulty = BEGINNER; map_ordering = 12 };
    { map_name = "Park Path"; difficulty = BEGINNER; map_ordering = 13 };
    { map_name = "Alpine Run"; difficulty = BEGINNER; map_ordering = 14 };
    { map_name = "Frozen Over"; difficulty = BEGINNER; map_ordering = 15 };
    { map_name = "In The Loop"; difficulty = BEGINNER; map_ordering = 16 };
    { map_name = "Cubism"; difficulty = BEGINNER; map_ordering = 17 };
    { map_name = "Four Circles"; difficulty = BEGINNER; map_ordering = 18 };
    { map_name = "Hedge"; difficulty = BEGINNER; map_ordering = 19 };
    { map_name = "End of the Road"; difficulty = BEGINNER; map_ordering = 20 };
    { map_name = "Logs"; difficulty = BEGINNER; map_ordering = 21 };
  ]

let comp_towers (t1: tower) (t2: tower) =
    compare t1.ordering t2.ordering

let comp_maps (m1: map) (m2: map) =
    compare m1.map_ordering m2.map_ordering

let rec get_random_towers (_towers : tower list) : tower list =
  if List.length _towers >= 3 then _towers
  else
    let random_tower = List.nth towers (Random.int (List.length towers)) in
    if List.mem random_tower _towers then get_random_towers _towers
    else get_random_towers (random_tower :: _towers)

let get_random_map : map =
  List.nth maps (Random.int (List.length maps))

let tower_output : string =
  String.concat "\n"
  [
    "Towers:";
    (get_random_towers []
    |> List.sort comp_towers
    |> List.map (fun t -> t.name)
    |> String.concat ", ")
  ]

let map_output : string =
  String.concat ": "
  ["Map"; get_random_map.map_name]

let default_handler _ =
  String.concat "\n\n" [(tower_output); (map_output)]
  |> Response.of_plain_text |> Lwt.return

let _ = App.empty |> App.get "/" default_handler |> App.run_command
