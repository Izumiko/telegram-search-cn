import os, jester, parseopt, db_sqlite, strutils, times, algorithm

type RawMsg = tuple
  time: int
  message: string

var dbfile = "export.db"
include "home.nimf"

proc timecmp(x,y: RawMsg): int = 
  if x.time < y.time: 1 else: -1

proc results(keyword: string): seq[string] = 
  var rawmsg: seq[RawMsg]
  let db = open(dbfile, "", "", "")
  let query = "SELECT Date,Message FROM Message WHERE Message LIKE '%" & keyword & "%'"
  for row in db.fastRows(sql(query)):
    rawmsg.add((parseInt(row[0]),row[1]))
  db.close()
  rawmsg.sort(timecmp)
  for row in rawmsg:
    var time = row[0].fromUnix().format("yyyy-MM-dd HH:mm:ss")
    result.add(time & "  " & row[1])


router myrouter:
  get "/":
    resp home("", @[])
  get "/search":
    var keyword = request.params["q"]
    resp home(keyword, results(keyword))

proc help(err: int) =
  echo "Usage: tgsearch -H:127.0.0.1 -p:8090 export.db"
  quit(err)

proc main() = 
  var p = initOptParser()
  var port = Port(8090)
  var bindAddr = "127.0.0.1"
  for kind, key, val in p.getopt():
    case kind
    of cmdArgument:
      dbfile = key
    of cmdLongOption, cmdShortOption:
      case key
      of "port", "p": port = parseInt(val).Port
      of "host", "H": bindAddr = val
      of "help", "h": help(QuitSuccess)
    of cmdEnd: assert(false)
  if not existsFile(dbfile):
    help(QuitFailure)

  let settings = newSettings(bindAddr=bindAddr,port=port)
  var jester = initJester(myrouter, settings=settings)
  jester.serve()

when isMainModule:
  main()