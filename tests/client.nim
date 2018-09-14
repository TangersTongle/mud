import unittest, websocket, asynchttpserver, asyncnet, asyncdispatch, os

suite "ClientTests":

  setup:
    var client = 
