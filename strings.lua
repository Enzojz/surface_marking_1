local descEN = [[This mod helps you placing customized text marking on streets and roads.
Find the tool in waypoint menu, place a # sign at road side first then customize it by clicking on it.
You can also find a free postion marking in the street construction menu, but this one doesn't make road alignment.

For techinical reason, you need to fine adjust the mark yourself, especailly the height. Go into the customize menu to change parameters.

The font used in this mod is "Alte DIN 1451 Mittelschrift".

The supported characters are essentially latin letters (and variants), cyrilic letters, math signs and unicode arrows. You can use copy-paste shortkeys in this game.
For technical reason I didn't use textlabel function of the game to implement this mod, and I am not able to put a super large charset in this mod (doing this will explode your graphics memory and blocks the game), so I feel sorry for players from countries which doesn't use latin or cyrillic letters (especailly CJKs), I have done my best.

This mod can be served as a base mod for other mods who in needs of these DIN typeface.]]

function data()
    local profile = {
        en = {
            MOD_NAME = "Surface Markings",
            MOD_DESC = descEN,
            MENU_NAME = "Surface Markings",
            MENU_DESC = "Road surface markings with customized text",
            MENU_FONT_SIZE = "Text height (m)",
            MENU_FONT_RATION = "Width/height ratio",
            MENU_LINE_SPACING = "Extra line spacing (% of h)",
            MENU_X_OFFSET = "Horizontal position adjustment (m)",
            MENU_Z_OFFSET = "Height adjustment (m)",
            MENU_TITL = "Titl (%)",
            MENU_COLOR = "Text color",
            MENU_WHITE = "White",
            MENU_YELLOW = "Yellow",
            TYPE_TEXT_BELOW = "Type marking text below\nUse \";\" as line feed"
        }
    }
    return profile
end
