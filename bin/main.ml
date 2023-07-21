open Opium

type tower_type = PRIMARY | MILITARY | MAGIC | SUPPORT

type tower = { name : string; _type : tower_type; ordering : int }

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

let tower_type_to_int _type =
    match _type with
    | PRIMARY -> 0
    | MILITARY -> 1
    | MAGIC -> 2
    | SUPPORT -> 3

let comp_towers (t1: tower) (t2: tower) =
    compare (tower_type_to_int (t1._type)) (tower_type_to_int (t2._type))

let rec get_random_towers _towers =
  if List.length _towers >= 3 then _towers
  else
    let random_tower = List.nth towers (Random.int (List.length towers)) in
    if List.mem random_tower _towers then get_random_towers _towers
    else get_random_towers (random_tower :: _towers)

let default_handler _ =
  get_random_towers []
  |> List.sort comp_towers
  |> List.map (fun t -> t.name)
  |> String.concat ", "
  |> Response.of_plain_text |> Lwt.return

let _ = App.empty |> App.get "/" default_handler |> App.run_command
