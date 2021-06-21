local func = require "surface_mark/func"
local surface_mark = require "surface_mark"
local modelId = nil
local script = {
    handleEvent = function(src, id, name, param)
        if (id == "__surface_mark__") then
            if (name == "build") then
                local transf = param.transf
                local proposal = api.type.SimpleProposal.new()
                local con = api.type.SimpleProposal.ConstructionEntity.new()
                con.fileName = "surface_mark.con"
                con.params = {
                    seed = 1,
                    size = 9,
                    ratio = 2,
                    lineSpacing = 0,
                    xOffset = 160,
                    tilt = 100,
                    zOffset = 120,
                    font = 0,
                    color = 0,
                    modules = {}
                }
                for i = 1, 16 do
                    con.transf[i] = transf[i]
                end
                con.playerEntity = api.engine.util.getPlayer()
                proposal.constructionsToAdd[1] = con
                
                local node0, node1 = param.node0, param.node1
                local node2Edges = api.engine.system.streetSystem.getNode2StreetEdgeMap()
                local edge = nil
                for _, edge0 in ipairs(node2Edges[node0]) do
                    for _, edge1 in ipairs(node2Edges[node1]) do
                        if edge0 == edge1 then
                            edge = edge0
                        end
                    end
                end
                
                if edge then
                    local street = api.type.SegmentAndEntity.new()
                    local comp = api.engine.getComponent(edge, api.type.ComponentType.BASE_EDGE)
                    local streetEdge = api.engine.getComponent(edge, api.type.ComponentType.BASE_EDGE_STREET)
                    
                    street.entity = -edge
                    street.playerOwned = {player = api.engine.util.getPlayer()}
                    
                    street.comp.node0 = comp.node0
                    street.comp.node1 = comp.node1
                    for i = 1, 3 do
                        street.comp.tangent0[i] = comp.tangent0[i]
                        street.comp.tangent1[i] = comp.tangent1[i]
                    end
                    street.comp.type = comp.type
                    street.comp.typeIndex = comp.typeIndex
                    street.type = 0
                    
                    street.streetEdge = streetEdge
                    local objects = {}
                    local modelId = api.res.modelRep.find("surface_mark/dummy.mdl")
                    for _, o in ipairs(comp.objects) do
                        local info = api.engine.getComponent(o[1], api.type.ComponentType.MODEL_INSTANCE_LIST)
                        if info and info.fatInstances and info.fatInstances[1] and info.fatInstances[1].modelId == modelId then
                            proposal.streetProposal.edgeObjectsToRemove[#proposal.streetProposal.edgeObjectsToRemove + 1] = o[1]
                        else
                            table.insert(objects, o)
                        end
                    end
                    street.comp.objects = objects
                    
                    proposal.streetProposal.edgesToAdd[1] = street
                    proposal.streetProposal.edgesToRemove[1] = edge
                
                end
                api.cmd.sendCommand(api.cmd.make.buildProposal(proposal, nil, false), function(res, err) end)
            elseif name == "update" then
                local entity = game.interface.getEntity(param.id)
                game.interface.upgradeConstruction(
                    param.id,
                    "surface_mark.con",
                    {
                        size = entity.params.size,
                        ratio = entity.params.ratio,
                        lineSpacing = entity.params.lineSpacing,
                        xOffset = entity.params.xOffset,
                        zOffset = entity.params.zOffset,
                        font = entity.params.font,
                        color = entity.params.color,
                        tilt = entity.params.tilt,
                        modules = func.map(surface_mark.utf2unicode(param.text), function(unicode)
                            return {
                                metadata = {},
                                name = "surface_mark.module",
                                variant = unicode,
                                transf = {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1}
                            }
                        end)
                    }
            )
            end
        end
    end,
    guiInit = function()
        modelId = api.res.modelRep.find("surface_mark/dummy.mdl")
    end,
    guiHandleEvent = function(id, name, param)
        if id == "mainView" and name == "select" then
            local entity = game.interface.getEntity(param)
            if (entity.fileName == "surface_mark.con") then
                local ew = api.gui.util.getById("temp.view.entity_" .. param)
                local w = api.gui.util.getById("surface_mark.entity_" .. param)
                if ew then
                    if not w then
                        local layout = api.gui.layout.BoxLayout.new("VERTICAL")
                        w = api.gui.comp.Window.new(_("TYPE_TEXT_BELOW"), layout)
                        local textField = api.gui.comp.TextInputField.new("")
                        textField:setText(entity.params and entity.params.text or "", false)
                        layout:addItem(textField)
                        w:setId("surface_mark.entity_" .. param)
                        w:onClose(function()
                            w:setVisible(false, false)
                        end)
                        textField:onChange(function(text)
                            local cmd = api.cmd.make.sendScriptEvent("surface_mark.lua", "__surface_mark__", "update", {id = param, text = text or "TEXT"})
                            textField:invokeLater(function()api.cmd.sendCommand(cmd, function() end) end)
                        end)
                    end
                    w:setVisible(true, false)
                    local pos = api.gui.util.getMouseScreenPos()
                    w:setPosition(pos.x + 20, pos.y + 20)
                end
            end
        elseif modelId and name == "builder.apply" then
            local proposal = param and param.proposal and param.proposal.proposal
            if (proposal) then
                local edgeObject = proposal.edgeObjectsToAdd[1]
                if edgeObject and edgeObject.modelInstance then
                    if (edgeObject.modelInstance.modelId == modelId) then
                        local transf = {}
                        for i = 1, 16 do
                            transf[i] = edgeObject.modelInstance.transf[i]
                        end
                        game.interface.sendScriptEvent("__surface_mark__", "build", {transf = transf, node0 = proposal.removedSegments[1].comp.node0, node1 = proposal.removedSegments[1].comp.node1})
                    end
                end
            end
        end
    end
}

function data()
    return script
end
