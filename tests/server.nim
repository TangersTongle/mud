import unittest, websocket, asynchttpserver, asyncnet, asyncdispatch, os
import threadpool

suite "ServerTests":

  setup:
    var server = newAsyncHttpServer()

  test "servercallbacktest":
    const testMessage = "Test Websocket Data"

    proc cb(req: Request) {.async.} =
      let (ws, error) = await(verifyWebsocketRequest(req))
      if ws.isNil:
        echo "ES Negotiation Failed: ", error
        await req.respond(Http400, "Websocket negotiation failed: " & error)
        req.client.close()
      else:
        echo "New websocket connection"
        while true:
          try:
            var f = await ws.readData()
            echo "(opcode: ", f.opcode, ", data: ", f.data.len, ")"

            if f.opcode == Opcode.Text:
              echo f.data
              check(f.data == testMessage)
              waitFor ws.sendText("thanks for the data!")
            else:
              waitFor ws.sendBinary(f.data)
            discard ws.close()
            echo ".. socket test done"
            break
          except:
            echo getCurrentExceptionMsg()
            break
        discard ws.close()
        echo ".. socket went away"
    

    asyncCheck server.serve(Port(8080), cb)
    let wsClient = waitFor newAsyncWebsocketClient("127.0.0.1", Port 8080, "")
    echo "Connected!"
    waitFor wsClient.sendText(testMessage)
    echo "Connected!"
    asyncdispatch.poll()
    discard wsClient.close()
    server.close()

  test "multiconnectiontest":
    const testMessage = "Test Websocket Data"

    proc cb(req: Request) {.async.} =
      let (ws, error) = await(verifyWebsocketRequest(req))
      if ws.isNil:
        echo "ES Negotiation Failed: ", error
        await req.respond(Http400, "Websocket negotiation failed: " & error)
        req.client.close()
      else:
        echo "New websocket connection"
        while true:
          try:
            var f = await ws.readData()
            echo "(opcode: ", f.opcode, ", data: ", f.data.len, ")"

            if f.opcode == Opcode.Text:
              waitFor ws.sendText(f.data)
            else:
              waitFor ws.sendBinary(f.data)
            discard ws.close()
            echo ".. socket test done"
            break
          except:
            echo getCurrentExceptionMsg()
            break
        discard ws.close()
        echo ".. socket went away"
    

    asyncCheck server.serve(Port(8080), cb)

    for num in 1..10:
      let wsClient = waitFor newAsyncWebsocketClient("127.0.0.1", Port 8080, "")
      echo "Connected!"
      waitFor wsClient.sendText(testMessage & $num)
      let response = waitFor wsClient.readData()
      echo "Got Response ", response.data
      check(response.data == testMessage & $num)
      discard wsClient.close()
    server.close()

  test "multiconnectionmessagetest":
    const testMessage = "Test Websocket Data"

    proc cb(req: Request) {.async.} =
      let (ws, error) = await(verifyWebsocketRequest(req))
      if ws.isNil:
        echo "ES Negotiation Failed: ", error
        await req.respond(Http400, "Websocket negotiation failed: " & error)
        req.client.close()
      else:
        echo "New websocket connection"
        while true:
          try:
            var f = await ws.readData()
            if f.opcode == Opcode.Text:
              waitFor ws.sendText(f.data)
            else:
              waitFor ws.sendBinary(f.data)
          except:
            break
        discard ws.close()
        echo ".. socket went away"
    

    asyncCheck server.serve(Port(8080), cb)

    for num in 1..10:
      let wsClient = waitFor newAsyncWebsocketClient("127.0.0.1", Port 8080, "")
      echo "Connected!"
      for d in 1..5:
        echo "Sending ", d + num
        waitFor wsClient.sendText(testMessage & $(num + d))
      for d in 1..5:
        let response = waitFor wsClient.readData()
        echo "Got Response ", response.data
        check(response.data == testMessage & $(num + d))
      discard wsClient.close()
    server.close()
    sync()
