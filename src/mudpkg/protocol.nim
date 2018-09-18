from websocket import Opcode

type
  MuddyMessage* = distinct string

  User* = ref object
    name*: string
    id*: int

proc `$`*(message: MuddyMessage): string {.borrow.}

proc parseMessage*(payload: tuple[opcode: Opcode, data: string]): MuddyMessage =
  MuddyMessage(payload.data)


