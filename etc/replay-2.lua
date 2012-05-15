pcall(require, 'luarocks.require')
--pcall(require, 'luarocks.require')
require 'lib.module'
require 'lib.strict'
require = import 'lib/require_and_declare.lua' { 'require_and_declare' }

math.randomseed(12345)

local ensure_returns,
      ensure_tdeepequals
      = import 'lib/ensure.lua'
      {
        'ensure_returns',
        'ensure_tdeepequals'
      }
local tdeepequals = import 'lib/tdeepequals.lua' { 'tdeepequals' }
local tstr = import 'lib/tstr.lua' { 'tstr' }
local find_all_files,
      read_file
      = import 'lib/filesystem.lua'
      {
        'find_all_files',
        'read_file'
      }

--------------------------------------------------------------------------------

declare 'inf'
inf = 1

--------------------------------------------------------------------------------

-- if this condition is replaced with "local luatexts = require 'luatexts.lua'",
-- the error does not occur
local MODE = "lua"
local luatexts
if MODE == "c" then
  luatexts = require 'luatexts'
elseif MODE == "lua" then
  luatexts = require 'luatexts.lua'
else
  error("unknown mode")
end

-- these two strings has no obvious sense, but if they are removed or replaced
-- with "io.stderr:write("")", the error does not occur
io.stderr:write(" ")
io.stderr:flush()

--------------------------------------------------------------------------------
-- The data is placed here to ensure that the problem is not caused by 
-- filesystem.lua function
local data = [[4
N
-298
T
7
7
N
3.140000000000000124344978758017532527446746826171875
1
N
inf
N
3.140000000000000124344978758017532527446746826171875
N
0.44275075076618275460305085289292037487030029296875
N
0
1
S
8
luatexts
S
8
luatexts
1
T
0
0
N
0.19624278641948844636999638169072568416595458984375
S
0

N
3.140000000000000124344978758017532527446746826171875
T
6
6
N
42
0
1
N
0
T
0
0
T
3
8
0
0
T
8
4
S
0

N
3.140000000000000124344978758017532527446746826171875
0
S
0

N
775
-
S
8
luatexts
N
0.2719410400704733721255479395040310919284820556640625
S
0

T
10
2
-
N
-306
-
1
0
N
0.846021000303272874276672155247069895267486572265625
1
S
0

S
8
luatexts
T
0
0
S
8
luatexts
T
0
0
N
inf
T
0
0
1
1
S
5
(nil)
S
0

T
0
0
N
42
N
0
T
0
0
0
N
487
1
S
0

S
5
(nil)
N
3.140000000000000124344978758017532527446746826171875
N
3.140000000000000124344978758017532527446746826171875
N
965
N
42
1
N
0.9468222821656215870689266012050211429595947265625
N
872
N
0.085364059985064688618194850278086960315704345703125
N
0.4025835519865006428830156437470577657222747802734375
N
0.8038934534357025096795723584364168345928192138671875
N
42
N
0.347571557695551813793599649216048419475555419921875
1
T
0
0
T
0
0
N
42
N
42
0
T
2
6
N
42
T
0
0
N
0
S
8
luatexts
T
4
7
0
N
inf
T
0
0
T
0
0
N
0
T
0
0
S
8
luatexts
0
T
1
7
0
N
0
T
0
0
S
0

N
0.06315879074936248116500792093575000762939453125
1
0
N
0.4335378247310328614361196741810999810695648193359375
T
0
6
S
8
luatexts
1
T
0
0
1
N
0.4091412660110886889697212609462440013885498046875
N
3.140000000000000124344978758017532527446746826171875
N
42
N
826
N
inf
S
8
luatexts
N
3.140000000000000124344978758017532527446746826171875
T
0
0
T
9
5
S
8
luatexts
N
0.9595698791955873385717268320149742066860198974609375
T
0
0
N
inf
N
-629
T
0
0
N
-910
N
0.37959526454007086471165166585706174373626708984375
N
3.140000000000000124344978758017532527446746826171875
0
1
1
T
0
0
N
inf
N
3.140000000000000124344978758017532527446746826171875
S
8
luatexts
S
0

N
3.140000000000000124344978758017532527446746826171875
1
T
0
0
N
996
N
896
N
3.140000000000000124344978758017532527446746826171875
T
0
0
S
8
luatexts
S
5
(nil)
N
42
N
273
N
997
N
-62
N
20
1
N
3.140000000000000124344978758017532527446746826171875
T
6
5
N
0.8228398485293861863709707904490642249584197998046875
S
0

N
inf
S
0

0
N
42
T
0
0
0
1
N
0
T
0
0
N
42
N
42
N
inf
0
1
S
5
(nil)
N
3.140000000000000124344978758017532527446746826171875
S
8
luatexts
S
0

T
0
0
S
8
luatexts
N
3.140000000000000124344978758017532527446746826171875
N
0.7758487285353574680613064629142172634601593017578125
N
inf
S
0

N
inf
N
0
T
2
2
-
N
3.140000000000000124344978758017532527446746826171875
T
8
2
S
8
luatexts
N
0
S
0

N
42
N
0.6438686822984582835971423264709301292896270751953125
N
0.0530468830000092594900706899352371692657470703125
S
0

1
N
0.73050256150024761581107668462209403514862060546875
0
N
-932
N
0
N
-701
S
0

S
8
luatexts
N
42
T
0
0
1
S
0

N
-913
]]
-----------------------------------------------------------------------------

local pack = function(...)
  local t = {}
  for i = 1, select("#", ...) do
    t[#t + 1] = select(i, ...)
  end
  return t 
end

-- this function is not used, but if it is removed, 
-- the error occurs less frequently
local ensure_custom = function(file, expected, ...)
      for i = 1, select("#", ...) do        
        local ex = expected[i]
        local ac = select(i, ...)
        if not tdeepequals(ex, ac) then
          print ("ensure_custom fail; FILE: " .. file .. " ITEM: " .. i - 1
            .. "; EXPECTED: '" .. tstr(ex) .. "'; ACTUAL: '" .. tstr(ac) .. "'")
        end
      end
end

local n_str
local start = 1
local _end = 100 
for i = 1, 100 do
  local filename = "data/00000051.luatexts"
  local n = tonumber("1", 10)
  -- if this condition is removed or replaced with "if true then",
  -- the error occurs less frequently
  if 1 >= 1 then
    local tuple, tuple_size = assert(dofile("data/00000051.lua"))
    -- if this string is removed, the error does not occur
    table.sort({"1", "2", "3", "4", "5", "6", "7", "8", "9", "10"})
    ensure_tdeepequals(
        filename,
        pack(luatexts.load(data)),
        pack(true, unpack(tuple, 1, tuple_size))
      )   
  end
end

io.stdout:flush()
