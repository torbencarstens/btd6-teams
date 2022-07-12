(lang dune 2.0)
(generate_opam_files true)

(name btd6_teams)
(version 0.1.0)

(authors "Torben Carstens")
(license MIT)
(source (uri "git+https://gitlab.com/torbencarstens/btd6-teams.git"))
(maintainers "github@carstens.tech") ; TODO
(homepage "https://gitlab.com/torbencarstens/btd6-teams")
(bug_reports "https://gitlab.com/torbencarstens/btd6-teams/issues")
(documentation "https://gitlab.com/torbencarstens/btd6-teams")

(package
 (name btd6_teams)
 (synopsis "Generate random teams for btd6")
 (description "Generate random teams for btd6")
 (depends
  ;; General system dependencies
  (dune (>= 2))
  (ocaml (>= 4.08.0))

  ;; Standard library replacement
  (core (>= v0.12.2))

  ;; Web toolkit
  (opium (>= 0.17.1))

  ;; HTML generation
  (tyxml (>= 4.3.0))

  ;; Logging
  (logs (>= 0.7.0))

  ;; Dev dependencies
  (utop :dev)
  (merlin :dev)
  (ocamlformat :dev)
  (ocp-indent :dev)
))