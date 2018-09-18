import websocket, asyncdispatch, asynchttpserver, asyncnet, tables

import src/mudpkg/protocol
import src/mudpkg/map

proc newUserFromInput(websocket: AsyncWebSocket): Future[User] {.async.} =
  ## Create a new user based on user input
  new result
  asyncCheck websocket.sendText("Enter your name")
  let data = await websocket.readData()
  let parsedData = parseMessage(data)
  result.name = $parsedData
  result.id = 1

proc processRequest(websocket: AsyncWebSocket) {.async.} =
  ## Process a request a websocket request
  var user = await newUserFromInput(websocket)
  echo "Processing Request"
  while true:
    asyncCheck websocket.sendText("Welcome " & user.name)
    for key, option in map1.pairs():
      case key
      of "default":
        for line in option:
          asyncCheck websocket.sendText(line)
      else:
        continue

    let data = await websocket.readData()
    let parsedData = parseMessage(data)

proc processClient(req: Request) {.async.} =
  ## Once a client sends a connection request and it's verified as a websocket connection,
  ## hook them up with a websocket and start listening
  let (ws, error) = await verifyWebsocketRequest(req)

  if ws.isNil:
    echo "WS negotiation failed: ", error
    await req.respond(Http400, "Websocket negotiation failed: " & error)
    req.client.close()
    return

  echo "New websocket customer arrived!"

  while not ws.sock.isClosed:
    await processRequest(ws)

when isMainModule:
  let s = newAsyncHttpServer()
  waitFor s.serve(Port(8080), processClient)
