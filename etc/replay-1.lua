pcall(require, 'luarocks.require')
--pcall(require, 'luarocks.require')
require 'lib.module'
require 'lib.strict'
require = import 'lib/require_and_declare.lua' { 'require_and_declare' }

math.randomseed(12345)

local ensure_returns  = import 'lib/ensure.lua' { 'ensure_returns' }
local tdeepequals = import 'lib/tdeepequals.lua' { 'tdeepequals' }

local find_all_files,
      read_file
      = import 'lib/filesystem.lua'
      {
        'find_all_files',
        'read_file'
      }

--------------------------------------------------------------------------------

-- TODO: ?! UGH! #3836
declare 'inf'
inf = 1/0

--------------------------------------------------------------------------------

local PREFIX = select(1, ...) or "tmp"
local OFFSET = tonumber(select(2, ...) or 1) or 1
local MODE = "lua" --(select(3, ...) or "c"):lower()

local luatexts
if MODE == "c" then
  luatexts = require 'luatexts'
elseif MODE == "lua" then
  luatexts = require 'luatexts.lua'
else
  error("unknown mode")
end

io.stderr:write(
    "replay.lua:",
    " PREFIX: ", PREFIX,
    " OFFSET: ", OFFSET,
    " MODE: ", MODE,
    "\n"
  )
io.stderr:flush()

--------------------------------------------------------------------------------

local ensure_custom = function(file, expected, ...)
      for i = 1, select("#", ...) do         
        local ex = expected[i]
        local ac = select(i, ...)
        if not tdeepequals(ex, ac) then
          print ("ensure_custom fail; FILE: " .. file .. " ITEM: " .. i
            .. "; EXPECTED: '" .. ex .. "'; ACTUAL: '" .. ac .. "'")
        end
      end
end

local filenames = find_all_files(PREFIX, ".*%d+%.luatexts$")
table.sort(filenames)

local n_str

local start = 1
local _end = 500 --#filenames
for i = start, _end do
  local filename = filenames[i]
  n_str = assert(filename:match("^"..PREFIX.."/(%d+).luatexts$"))

  local n = assert(tonumber(n_str, 10))
  if n >= OFFSET then
    local tuple, tuple_size = assert(dofile(PREFIX.."/"..n_str..".lua"))
    local data = assert(read_file(filename))
    
    -- ensure_custom(
    --     filename, 
    --     { true, unpack(tuple, 1, tuple_size) }, 
    --     luatexts.load(data)
    --   )

    ensure_returns(
            "load " .. n_str,
            tuple_size + 1, { true, unpack(tuple, 1, tuple_size) },
            luatexts.load(data)
          )
    
  end
end

io.stdout:flush()
--print("OK")
