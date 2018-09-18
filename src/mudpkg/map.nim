import tables, macros, os

type
  Map* = object
    body: Table[string, seq[string]]

proc loadMap(mapName: string): Map =
  result = Map()
  let path = getConfigDir() / "mud" / mapName / ".mudmap"
  let fd = open(path, fmRead)
  result.body = initTable[string, seq[string]](fd.len)
  for line in fd.lines:
    result.body


  


const map1 = loadMap("Map1")
