package main

import rl "vendor:raylib"

SCREEN_WIDTH :: 1440
SCREEN_HEIGHT :: 720

Player :: struct {
    pos: [2]i32,
    length, width: i32,
    color: rl.Color,
}

Brick :: struct {
    pos: [2]i32,
    length, width: i32,
    color: rl.Color,
}

Ball :: struct {
    center: [2]i32,
    radius: f32,
    velocity: [2]i32,
    color: rl.Color,
}

main :: proc() {
    rl.SetTraceLogLevel(.ERROR)
    rl.SetConfigFlags({.MSAA_4X_HINT, .WINDOW_HIGHDPI, .VSYNC_HINT})

    rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Stack Smacker")

    player := Player{}
    player.pos = {(SCREEN_WIDTH / 2) -50, (SCREEN_HEIGHT / 4) * 3}
    player.length = 100
    player.width = 10
    player.color = rl.RED

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.DrawRectangle(player.pos.x, player.pos.y, player.length, player.width, player.color)

        if rl.IsKeyDown(.D) {
            player.pos.x += 1
        }

        if rl.IsKeyDown(.A) {
            player.pos.x -= 1
        }

        rl.ClearBackground(rl.BLACK)

        rl.EndDrawing()
    }
}