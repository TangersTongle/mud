import websocket, asyncdispatch, asynchttpserver, json, macros, asyncnet, threadpool, net, uri

import src/mudpkg/protocol

proc processRequest(websocket: AsyncWebSocket) {.async.} =
  ## Process a request a websocket request
  echo "Processing Request"
  while true:
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
