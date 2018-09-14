import websocket, asyncdispatch, asynchttpserver, json, macros

template isOpcode(ident: untyped): bool =
  proc `isOpcode ident`(opcode: Opcode): bool =
    opcode == Opcode.`ident`

macro makeOpcodeChecks(): untyped =
  result = newStmtList()

  let id: NimNode = ident("Opcode")
  echo id.kind
  echo id
  echo typeKind(gettype(Opcode))


#proc handleTextMessage*(message: tuple[opcode: Opcode, data: string]): Future[JsonNode] {.async.} =
#  echo "HANDLING TEXT"
#
#proc handleWebsocketConnection*(websocket: AsyncWebSocket) {.async.} =
#  echo "Handling new websocket connection"
#  while true:
#    try:
#      let message = await websocket.readData()
#      if isTextOpcode message:
#        handleTextMessage(message)
#    except:
#      echo getCurrentExceptionMsg()
#
#
#proc dispatchWebsocketConnection*(req: Request) {.async.} =
#  let (websocket, error) = await verifyWebsocketRequest(req)
#
#  if ws.isNil:
#    echo "Websocket Negotiation Failed: ", error
#    await req.respond(Http400, "Websocket negotiation failed: " & error)
#    req.client.close()
#  else:
#    asyncCheck handleWebsocketConnection(websocket)

when isMainModule:
  makeOpcodeChecks()
