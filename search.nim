import os, jester, parseopt, db_sqlite, strutils, times

var dbfile = "export.db"
include "home.nimf"

proc results(keyword: string): seq[string] = 
  let db = open(dbfile, "", "", "")
  let query = "SELECT Date,Message FROM Message WHERE Message LIKE '%" & keyword & "%'"
  for row in db.fastRows(sql(query)):
    var time = parseInt(row[0]).fromUnix().format("yyyy-MM-dd HH:mm:ss")
    result.add(time & "  " & row[1])
  db.close()

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