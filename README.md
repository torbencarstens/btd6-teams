btd6-teams
===

## Troubleshooting

### SIGSEGV

```
[...]
INFO Jester is making jokes at http://0.0.0.0:8080
Starting 16 threads
Listening on port 8080
No stack traceback available
SIGSEGV: Illegal storage access. (Attempt to read from nil?)
[...]
```

This can be fixed by either importing `std/segfaults` or using `refc` (pass `--mm:refc` to `nim`/`nimble`)
