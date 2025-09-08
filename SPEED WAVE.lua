local Games = loadstring(game:HttpGet("https://raw.githubusercontent.com/speedwavevip/Speed_Aya/refs/heads/main/Games.lua"))()

local URL = Games[game.PlaceId]

if URL then
  loadstring(game:HttpGet(URL))()
end
