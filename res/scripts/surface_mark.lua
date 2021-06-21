local pipe = require "surface_mark/pipe"
local func = require "surface_mark/func"

local unpack = table.unpack

local bit32 = bit32
local band = bit32.band
local lshift = bit32.lshift
local bor = bit32.bor

local function utf2unicode(str)
    if (str == nil) then return pipe.new / 0 end
    local function continue(val, c, ...)
        if (c and band(c, 0xC0) == 0x80) then
            return continue(bor(lshift(val, 6), band(c, 0x3F)), ...)
        else
            return val, {c, ...}
        end
    end
    local function convert(rs, c, ...)
        if (c == nil) then return rs
        elseif (c < 0x80) then
            return convert(rs / c, ...)
        else
            local lGr = c < 0xE0 and 2
                or c < 0xF0 and 3
                or c < 0xF8 and 4
                or error("invalid UTF-8 character sequence")
            local val, rest = continue(band(c, 2 ^ (8 - lGr) - 1), ...)
            return convert(rs / val, unpack(rest))
        end
    end
    return convert(pipe.new, str:byte(1, -1))
end

return { utf2unicode = utf2unicode }