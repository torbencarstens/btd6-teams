open Opium

type tower = { name : string; _type : string }

let towers : tower list =
  [
    { name = "Dart Monkey"; _type = "PRIMARY" };
    { name = "Boomerang Monkey"; _type = "PRIMARY" };
    { name = "Bomb Shooter"; _type = "PRIMARY" };
    { name = "Tack Shooter"; _type = "PRIMARY" };
    { name = "Ice Monkey"; _type = "PRIMARY" };
    { name = "Glue Gunner"; _type = "PRIMARY" };
    { name = "Sniper Monkey"; _type = "MILITARY" };
    { name = "Monkey Sub"; _type = "MILITARY" };
    { name = "Monkey Buccaneer"; _type = "MILITARY" };
    { name = "Monkey Ace"; _type = "MILITARY" };
    { name = "Heli Pilot"; _type = "MILITARY" };
    { name = "Mortar Monkey"; _type = "MILITARY" };
    { name = "Dartling Gunner"; _type = "MILITARY" };
    { name = "Wizard Monkey"; _type = "MAGIC" };
    { name = "Super Monkey"; _type = "MAGIC" };
    { name = "Ninja Monkey"; _type = "MAGIC" };
    { name = "Alchemist"; _type = "MAGIC" };
    { name = "Druid"; _type = "MAGIC" };
    { name = "Banana Farm"; _type = "SUPPORT" };
    { name = "Spike Factory"; _type = "SUPPORT" };
    { name = "Monkey Village"; _type = "SUPPORT" };
    { name = "Engineer Monkey"; _type = "SUPPORT" };
  ]

let rec get_random_towers _towers =
  let () = print_int (List.length _towers) in
  if List.length _towers >= 3 then _towers
  else
    let random_tower = List.nth towers (Random.int (List.length towers)) in
    if List.mem random_tower _towers then get_random_towers _towers
    else get_random_towers (random_tower :: _towers)

let default_handler _ =
  get_random_towers []
  |> List.map (fun t -> t.name)
  |> String.concat ", "
  |> Response.of_plain_text |> Lwt.return

let _ = App.empty |> App.get "/" default_handler |> App.run_command
