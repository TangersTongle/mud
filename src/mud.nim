import macros, json, os, strutils

macro loadConfig(configFileName: untyped): untyped = 
  var procString = """
  proc getConfigFileNameConfig(): JsonNode =
    result = parseFile(getConfigDir() / "mud" / "ConfigFileName.cfg")
  """
  procString = replace(procString, "ConfigFileName", $configFileName)
  add(procString, "\l     ")
  return parseStmt(procString)
   
loadConfig(RequestTypes)
