local pipe = require "surface_mark/pipe"
local func = require "surface_mark/func"
local coor = require "surface_mark/coor"

local bit32 = bit32
local band = bit32.band
local lshift = bit32.lshift
local bor = bit32.bor

local unpack = table.unpack
local insert = table.insert

local gen = function(scale, z, font, color)
    local abc, kern = unpack(require (string.format("livetext/%s", font)))
    local scale = scale or 1
    local z = z or 0
    return function(unicode)
        local result = {}
        for _, c in ipairs(unicode) do
            local lastPos = #result > 0 and result[#result].to or 0
            local abc = abc[c]
            local kern = kern[c]
            
            if (abc) then
                local pos = lastPos + abc.a + (#result > 0 and kern and kern[result[#result].c] or 0)
                local nextPos = pos + abc.b + abc.c
                insert(result, {c = c, from = pos, to = nextPos})
            end
        end
        if (#result > 0) then
            local width = result[#result].to * scale
            return
                function(fTrans) return func.map(result, function(r)
                    return {
                        id = ("livetext/%s/%s/%d.mdl"):format(font, color, r.c),
                        transf = coor.transX(r.from) * coor.scale(coor.xyz(scale, scale, scale)) * coor.transZ(z * scale) * (fTrans(width) or coor.I())
                    }
                end)
                end, width
        else
            return false, false
        end
    end
end

return gen
