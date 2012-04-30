--------------------------------------------------------------------------------
-- table-utils.lua: small table utilities
-- This file is a part of lua-nucleo library
-- Copyright (c) lua-nucleo authors (see file `COPYRIGHT` for the license)
--------------------------------------------------------------------------------

local setmetatable, error, pairs, ipairs, tostring, select, type, assert
    = setmetatable, error, pairs, ipairs, tostring, select, type, assert

local rawget = rawget

local table_insert, table_remove = table.insert, table.remove

local math_min, math_max = math.min, math.max

--------------------------------------------------------------------------------

local arguments,
      optional_arguments,
      method_arguments
      = import 'lib/args.lua'
      {
        'arguments',
        'optional_arguments',
        'method_arguments'
      }

local is_table
      = import 'lib/type.lua'
      {
        'is_table'
      }

local assert_is_table
      = import 'lib/typeassert.lua'
      {
        'assert_is_table'
      }

--------------------------------------------------------------------------------

local taccumulate = function(t, init)
  local sum = init or 0
  for k, v in pairs(t) do
    sum = sum + v
  end
  return sum
end

local tnormalize, tnormalize_inplace
do
  local impl = function(t, r, sum)
    sum = sum or taccumulate(t)

    for k, v in pairs(t) do
      r[k] = v / sum
    end

    return r
  end

  tnormalize = function(t, sum)
    return impl(t, { }, sum)
  end

  tnormalize_inplace = function(t, sum)
    return impl(t, t, sum)
  end
end

-- TODO: Pick a better name?
local tidentityset = function(t)
  local r = { }

  for k, v in pairs(t) do
    r[v] = v
  end

  return r
end

--------------------------------------------------------------------------------

return
{
  taccumulate = taccumulate;
  tnormalize = tnormalize;
  tnormalize_inplace = tnormalize_inplace;
  tidentityset = tidentityset;
}
