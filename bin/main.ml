open Opium

type tower_type = PRIMARY | MILITARY | MAGIC | SUPPORT

type tower = { name : string; _type : tower_type }

let towers : tower list =
  [
    { name = "Dart Monkey"; _type = PRIMARY };
    { name = "Boomerang Monkey"; _type = PRIMARY };
    { name = "Bomb Shooter"; _type = PRIMARY };
    { name = "Tack Shooter"; _type = PRIMARY };
    { name = "Ice Monkey"; _type = PRIMARY };
    { name = "Glue Gunner"; _type = PRIMARY };
    { name = "Sniper Monkey"; _type = MILITARY };
    { name = "Monkey Sub"; _type = MILITARY };
    { name = "Monkey Buccaneer"; _type = MILITARY };
    { name = "Monkey Ace"; _type = MILITARY };
    { name = "Heli Pilot"; _type = MILITARY };
    { name = "Mortar Monkey"; _type = MILITARY };
    { name = "Dartling Gunner"; _type = MILITARY };
    { name = "Wizard Monkey"; _type = MAGIC };
    { name = "Super Monkey"; _type = MAGIC };
    { name = "Ninja Monkey"; _type = MAGIC };
    { name = "Alchemist"; _type = MAGIC };
    { name = "Druid"; _type = MAGIC };
    { name = "Banana Farm"; _type = SUPPORT };
    { name = "Spike Factory"; _type = SUPPORT };
    { name = "Monkey Village"; _type = SUPPORT };
    { name = "Engineer Monkey"; _type = SUPPORT };
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
