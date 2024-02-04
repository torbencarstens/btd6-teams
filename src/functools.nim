import std/[options, sequtils]

proc filterMap*[N, V](list: openArray[V], filterProc: proc(v: V): bool, mapProc: proc(v: V): N): seq[N] =
  let filtered = sequtils.filter(list, filterProc)
  sequtils.map(filtered, mapProc)

proc filterNone*[V](list: openArray[Option[V]]): seq[V] =
  filterMap(
    list,
    proc(t: Option[V]): bool = t.isSome(),
    proc(t: Option[V]): V = t.get()
  )

iterator countTo*(n: int): int =
  var i = 0
  while i <= n:
    yield i
    inc i
