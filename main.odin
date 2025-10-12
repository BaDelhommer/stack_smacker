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

build_stack :: proc() -> [16][12]Brick {
    stack: [16][12]Brick
    brick_width := SCREEN_WIDTH / 16
    brick_height := SCREEN_HEIGHT / 60

    for i in 0..< len(stack) {
        for j in 0..<len(stack[i]) {
            new_brick := Brick{}
            new_brick.length = i32(brick_width)
            new_brick.width = i32(brick_height)
            new_brick.pos = {i32(brick_width * i), i32(brick_height * j)}
            stack[i][j] = new_brick
        }
    }
    return stack
}

draw_stack :: proc(stack: [16][12]Brick) {
    for i in 0..<len(stack) {
        for j in 0..<len(stack[i]) {
            new_rect := rl.Rectangle{f32(stack[i][j].pos.x), f32(stack[i][j].pos.y), f32(stack[i][j].length), f32(stack[i][j].width)}
            rl.DrawRectangleLinesEx(new_rect, .5, rl.WHITE)
        }
    }
}

main :: proc() {
    rl.SetTraceLogLevel(.ERROR)
    rl.SetConfigFlags({.MSAA_4X_HINT, .WINDOW_HIGHDPI, .VSYNC_HINT})

    rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Stack Smacker")

    stack := build_stack()

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

        draw_stack(stack)

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