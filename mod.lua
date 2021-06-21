function data()
    return {
        info = {
            severityAdd = "NONE",
            severityRemove = "CRITICAL",
            name = _("MOD_NAME"),
            description = _("MOD_DESC"),
            authors = {
                {
                    name = "Enzojz",
                    role = "CREATOR",
                    text = "Idea, Scripting, Modeling",
                    steamProfile = "enzojz",
                    tfnetId = 27218,
                }
            },
            tags = {"Street", "Street Construction", "Misc"},
        },
        postRunFn = function(settings, params)
            local m = api.res.moduleRep.find("surface_mark.module")
            api.res.moduleRep.setVisible(m, false)
        end
    }
end
