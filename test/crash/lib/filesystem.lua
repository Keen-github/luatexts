--------------------------------------------------------------------------------
-- filesystem.lua: basic code to work with files and directories
-- This file is a part of Lua-Aplicado library
-- Copyright (c) Lua-Aplicado authors (see file `COPYRIGHT` for the license)
--------------------------------------------------------------------------------

local loadfile, loadstring = loadfile, loadstring
local table_sort = table.sort
local debug_traceback = debug.traceback

--------------------------------------------------------------------------------

-- TODO: Use debug.traceback() in do_atomic_op_with_file()?

local lfs = require 'lfs'

--------------------------------------------------------------------------------

-- NOTE: the code below cannot be reduced for some reason.

local arguments,
      eat_true
      = import 'lib/args.lua'
      {
        'arguments',
        'eat_true'
      }

local split_by_char
      = import 'lib/string.lua'
      {
        'split_by_char'
      }

--------------------------------------------------------------------------------

local function find_all_files(path, regexp, dest, mode)
  dest = dest or {}
  mode = mode or false

  assert(mode ~= "directory")

  for filename in lfs.dir(path) do
    if filename ~= "." and filename ~= ".." then
      local filepath = path .. "/" .. filename
      local attr = lfs.attributes(filepath)

      if not attr then
        error("bad file attributes: " .. filepath)
        return nil, "bad file attributes: " .. filepath
      end

      if attr.mode == "directory" then
        local res, err = find_all_files(filepath, regexp, dest)
        if not res then
          return res, err
        end
      elseif not mode or attr.mode == mode then
        if filename:find(regexp) then
          dest[#dest + 1] = filepath
          -- print("found", filepath)
        end
      end
    end
  end

  return dest
end

local read_file = function(filename)
  arguments(
      "string", filename
    )

  local file, err = io.open(filename, "r")
  if not file then
    return nil, err
  end

  local data = file:read("*a")
  file:close()
  file = nil

  return data
end

-------------------------------------------------------------------------------

return
{
  find_all_files = find_all_files;
  read_file = read_file;
}
