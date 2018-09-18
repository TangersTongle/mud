from websocket import Opcode

type
  MuddyMessage = distinct string

proc `$`*(message: MuddyMessage): MuddyMessage {.borrow.}

proc parseMessage*(payload: tuple[opcode: Opcode, data: string]): MuddyMessage =
  MuddyMessage(payload.data)


