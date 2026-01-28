return {
    image = "cthullu_sprites.png",

    direction = 'left',
    state = 'idle',

    life = 100,

    frame = {
        w = 192,
        h = 112,
        ofx = 0,
        ofy = 0,
        sx = 0,
        sy = 0
    },

    hitbox = {
        x = 62,
        y = 41,
        w = 66,
        h = 56
    },

    animation = {
        idle = { row = 1, frames = '1-15', speed = 0.2 },
        walk = { row = 2, frames = '1-12', speed = 0.3 },
        fly = { row = 3, frames = '1-6', speed = 0.15 },
        attack1 = { row = 4, frames = '1-7', speed = 0.3 },
        attack2 = { row = 5, frames = '1-9', speed = 0.3 },
        hit = { row = 6, frames = '1-6', speed = 0.3},
        dead = { row = 7, frames = '1-11', speed = 0.3 }
    }
}