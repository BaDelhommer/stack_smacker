package main

import rl "vendor:raylib"

SCREEN_WIDTH :: 1440
SCREEN_HEIGHT :: 720

Player :: struct {
    pos: [2]i32,
    length, width: i32,
    color: rl.Color,
    x_velocity: i32,
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

    ball := Ball{}
    ball.center = {SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2}
    ball.radius = 10.0
    ball.velocity = {0, 1}
    ball.color = rl.WHITE

    player := Player{}
    player.pos = {(SCREEN_WIDTH / 2) -50, (SCREEN_HEIGHT / 4) * 3}
    player.length = 100
    player.width = 10
    player.color = rl.RED
    player.x_velocity = 0

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.DrawRectangle(player.pos.x, player.pos.y, player.length, player.width, player.color)
        rl.DrawCircle(ball.center.x, ball.center.y, ball.radius, ball.color)
        ball.center.x += ball.velocity.x
        ball.center.y += ball.velocity.y

        if ball.center.y >= player.pos.y - player.width {
            ball.velocity.y *= -1
            ball.velocity.x = player.x_velocity
        }

        switch {
            case rl.IsKeyDown(.A):
                player.x_velocity = -1
            case rl.IsKeyDown(.D):
                player.x_velocity = 1
            case:
                player.x_velocity = 0
        }

        player.pos.x += player.x_velocity

        rl.ClearBackground(rl.BLACK)

        rl.EndDrawing()
    }
}