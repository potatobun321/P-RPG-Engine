return {
    Transform = function(x, y, w, h) return {x=x, y=y, w=w, h=h} end,
    Velocity = function(dx, dy, speed) return {dx=dx or 0, dy=dy or 0, baseSpeed=speed or 100, currentSpeed=speed or 100} end,
    Renderable = function(type, colorKey, texture, draw_style) return {type=type, colorKey=colorKey, texture=texture, draw_style=draw_style or "fill"} end,
    PlayerInput = function() return {} end,
    Health = function(hp, maxHp) return {current = hp or 100, max = maxHp or 100} end,
    CharacterStats = function(template) return {stats = template} end,
    TileData = function(data) return data end
}
