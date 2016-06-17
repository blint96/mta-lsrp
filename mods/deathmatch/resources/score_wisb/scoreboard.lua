local x,y = guiGetScreenSize()
font = {}
font['sans_14'] = dxCreateFont ('sans.ttf', 14)
font['sans'] = dxCreateFont ('sans.ttf', 10)
font['sans_light'] = dxCreateFont ('sans_light.ttf', 10)
scoreboard = {
tab_size = 25,
size = {505, 0},
pos = {x/2-252.5, 0},
players = {},
from = 1,
to = 20,
playersData = {},
pings = {},
  columns = { 
    [1] = {'GamePoints', 75, 'gs'}, [4] = {'ID', 40, 'id'}, [3] = {'Ping', 40, 'ping'}, [2] = {'OOC', 170, 'ooc_nick'}
    -- pierwszy elemtn tablicy: nazwa przyjazna, wyswietla sie w grze
    -- drugi: wielkosc, radze nie bawic sie z tym
    -- trzeci: wykorzystywany do przypisywania wartosci do kolumny dla gracza, oraz przy wyswietlaniu, nic specjalnego
  },
}
----- funkcja do tekstu obramowanego, zajebiscie wyglada, z jakiegos forum juz nie pamietam skad
function dxDrawTextBordered(text,x1,y1,x2,y2,color, color2, thickness,scale,font,alignX,alignY,textclip,wordbreak,postgui,colored)
  local noHextext = string.gsub(text, "#%x%x%x%x%x%x", "") 
  if not color2 then color2 = black end
  for w=-thickness,thickness,thickness do
    for h=-thickness,thickness,thickness do
      if not(w==0 and h==0) then
        dxDrawText(noHextext,x1+w,y1+h,x2+w,y2+h,color2,scale,font,alignX,alignY,textclip,wordbreak,postgui)
      end
    end
  end
  dxDrawText(text,x1,y1,x2,y2,color,scale,font,alignX,alignY,textclip,wordbreak,postgui, colored)
end
-- na testy tylko :

function getPlayersStats()
  getPlayersPing()
  for k,v in pairs (scoreboard.players) do
	local id = getElementData (v, 'id')
	local ooc_name = getElementData (v, 'player.gname' )
	local gs = getElementData (v, 'player.gamescore' )
	-- wiadomo, ELEMENT DATA
	scoreboard.playersData[k] = {['playa'] = v, ['ooc_nick'] = ooc_name, ['gs'] = gs, ['id'] = id, ['ping'] = scoreboard.pings[v].ping }
  end
end

function getPlayersPing ()
  for k,v in pairs (scoreboard.players) do
    if getPlayerPing(v) >= 999 then
      scoreboard.pings[v] = {ping = '>999'}
    else
      scoreboard.pings[v] = {ping = getPlayerPing (v)}
    end
  end
end
function scoreboardScroll(key)
  if key == 'mouse_wheel_up' then
    if scoreboard.from > 1 then 
      scoreboard.from = scoreboard.from - 1
      scoreboard.to = scoreboard.to - 1
    end
  elseif key == 'mouse_wheel_down' then
    if scoreboard.to < #scoreboard.players then 
      scoreboard.from = scoreboard.from + 1
      scoreboard.to = scoreboard.to + 1
    end
  end
end
function toggleScoreBoard(key, keyState )
  if keyState == 'down' then
    scoreboard.players = getElementsByType('player')
    getPlayersStats()
    statsTimer = setTimer (getPlayersStats, 1000, 0)
    bindKey ('mouse_wheel_up', 'both', scoreboardScroll)
    bindKey ('mouse_wheel_down', 'both', scoreboardScroll)
    calcSize()
    addEventHandler ('onClientRender', root, renderScoreboard)
  else 
    if statsTimer then killTimer (statsTimer) end
    unbindKey ('mouse_wheel_up', 'both', scoreboardScroll)
    unbindKey ('mouse_wheel_down', 'both', scoreboardScroll)
    removeEventHandler ('onClientRender', root, renderScoreboard)
  end
end
bindKey ('tab', 'both', toggleScoreBoard)
function calcSize()
  scoreboard.size[2] = 20 * scoreboard.tab_size
  scoreboard.pos[2] = y/2-scoreboard.size[2]/2
end
-- 
-- nizej dzieje sie magia :D
function renderScoreboard()
  dxDrawBlurredRectangle (scoreboard.pos[1], scoreboard.pos[2], scoreboard.size[1], scoreboard.size[2])
  dxDrawRectangle (scoreboard.pos[1], scoreboard.pos[2], scoreboard.size[1], scoreboard.size[2], tocolor (0,0,0,150))
  offset_y = 0
  local start_x ,start_y = scoreboard.pos[1] , scoreboard.pos[2]
  local offset_x = 180
  local lineOffset = scoreboard.pos[1]
  local size_x, size_y = scoreboard.size[1], scoreboard.size[2]
  dxDrawLine (start_x+size_x, start_y-12, start_x+size_x, start_y+size_y, tocolor (255,255,255,66))
  dxDrawLine (start_x, start_y, start_x,  start_y+size_y, tocolor (255,255,255,66))
  dxDrawLine (start_x, start_y, start_x+size_x,start_y, tocolor (255,255,255,66))

  -- belka dolna
  dxDrawLine (start_x, start_y+size_y, start_x+size_x,start_y+size_y, tocolor (255,255,255,66))

  dxDrawTextBordered ('Uzyj rolki do przewijania listy', start_x+5, start_y-15, 200, 200, tocolor (255,255,255,255), tocolor (1,1,1,50), 1, 1, font['sans'],'left','top',false, false,false, true,false) 
  dxDrawLine (start_x+offset_x, start_y-12, start_x+size_x-1,start_y-12, tocolor (255,255,255,199))  
  for k,v in pairs (scoreboard.columns) do
    --outputChatBox(v[3])
    dxDrawBlurredRectangle (start_x+offset_x, start_y+offset_y-12, v[2],12, scoreboard.size[2])
    dxDrawRectangle (start_x+offset_x, start_y+offset_y-12, v[2],12, tocolor (0,0,0,150))
    dxDrawLine (start_x+offset_x, start_y-12, start_x+offset_x,start_y+scoreboard.size[2], tocolor (255,255,255,66))
    dxDrawTextBordered (v[1], start_x+offset_x, start_y+offset_y-12, start_x+offset_x+v[2], 200, tocolor (255,255,255,255), tocolor (0,0,0,255), 1,0.5, font['sans_14'],'center','top',false, false,false, true,false)   
    offset_x = offset_x + v[2] 
  end  
  for i = scoreboard.from, scoreboard.to do
    if #scoreboard.players < i then break end
    local v = scoreboard.playersData[i].playa
    if v == localPlayer then
      dxDrawRectangle (scoreboard.pos[1], scoreboard.pos[2]+offset_y, scoreboard.size[1],25, tocolor (255,255,255,25))
    end
    dxDrawTextBordered (getPlayerName (v):gsub("_", " "), start_x+5, start_y+offset_y+5, 200, 200, tocolor (255,255,255,255), tocolor (0,0,0,255), 1, 1, font['sans'],'left','top',false, false,false, true,false) 
    dxDrawLine (lineOffset, start_y+offset_y+25, start_x+size_x,start_y+offset_y+25, tocolor (255,255,255,66)) 
    offset_x = 180
    for c,v in pairs(scoreboard.columns) do
      dxDrawTextBordered (scoreboard.playersData[i][v[3]] or 'b/d', start_x+offset_x, start_y+offset_y, start_x+offset_x+v[2], start_y+offset_y+25, tocolor (255,255,255,255), tocolor (0,0,0,121), 0.5, 1, font['sans_light'],'center','center',false, false,false, true,false) 
      offset_x = offset_x + v[2]  
    end
    offset_y= offset_y + 25  
  end
end