# Package

version       = "0.1.0"
author        = "Ryanc_signiq"
description   = "A MUD written in Nim"
license       = "MIT"
srcDir        = "src"
bin           = @["mud"]

# Dependencies

requires "nim >= 0.18.0"
requires "websocket#head"

task serverTest, "Run server tests":
  exec("mkdir -p tests/bin")
  exec("nim c -r --out:tests/bin/server tests/server.nim")

task clientTest, "Run client tests":
  exec("mkdir -p tests/bin")
  exec("nim c -r --out:tests/bin/client tests/client.nim")

task run, "Start the server":
  exec("mkdir -p bin")
  exec("nim c -r --out:bin/mud src/mud.nim")

task runServerTests, "Run the source server tests":
  exec("mkdir -p bin")
  exec("nim c -r --threads:on --out:bin/server src/mudpkg/server.nim")
