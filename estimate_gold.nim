import std/[htmlparser, httpclient, options, re, strutils, xmltree]

let url = "https://bloons.fandom.com/wiki/Rounds_(BTD6)#List_of_rounds"
var client = newHttpClient()
var html = none(XmlNode)
try:
  let content = client.getContent(url)
  html = some parseHtml(content)
finally:
  client.close()


proc isRoundsTable(table: XmlNode): bool =
  for th in table.findAll("th"):
    for span in th.findAll("span"):
      if strutils.contains(span.innerText, "Cumulative"):
        return true

  return false

var roundsTable = none(XmlNode)
for table in html.get().findAll("tbody"):
  if isRoundsTable(table):
    roundsTable = some table
    break

var goldInRound: seq[int] = @[]
for tr in roundsTable.get().findAll("tr"):
  if tr.len() == 12:
    let text: string = strutils.strip(tr[11].innerText)
    let value = find(text, re"\$(\d+)")
    if value != -1:
      let gold = strutils.replace(text, "$", "")
      goldInRound.add strutils.parseInt(gold)

echo goldInRound
