package main

import "core:fmt"
import rl "vendor:raylib"

SCREEN_WIDTH :: 1440
SCREEN_HEIGHT :: 720
SPEED :: 10

Player :: struct {
    pos: [2]i32,
    length, width: i32,
    color: rl.Color,
    x_velocity: i32,
}

Brick :: struct {
    pos: [2]i32,
    length, width: i32,
    rect: rl.Rectangle,
    visible: bool,
    color: rl.Color,
}

Ball :: struct {
    center: [2]i32,
    radius: f32,
    velocity: [2]i32,
    color: rl.Color,
}

build_stack :: proc() -> [16][6]Brick {
    stack: [16][6]Brick
    brick_width := SCREEN_WIDTH / 16
    brick_height := SCREEN_HEIGHT / 30

    for i in 0..< len(stack) {
        for j in 0..<len(stack[i]) {
            new_brick := Brick{}
            new_brick.length = i32(brick_width)
            new_brick.width = i32(brick_height)
            new_brick.pos = {i32(brick_width * i), i32(brick_height * j)}
            new_brick.visible = true
            new_brick.rect = rl.Rectangle{f32(new_brick.pos.x), f32(new_brick.pos.y), f32(new_brick.length), f32(new_brick.width)}
            stack[i][j] = new_brick
        }
    }
    return stack
}

draw_stack :: proc(stack: [16][6]Brick) {
    for i in 0..<len(stack) {
        for j in 0..<len(stack[i]) {
            if stack[i][j].visible {
                rl.DrawRectangleLinesEx(stack[i][j].rect, .5, rl.WHITE)
            }
        }
    }
}

smack_check :: proc(ball: ^Ball, stack: ^[16][6]Brick) {
    loop: for i in 0..<len(stack) {
        for j in 0..<len(stack[i]) {
            if rl.CheckCollisionCircleRec({f32(ball.center.x), f32(ball.center.y)}, ball.radius, stack[i][j].rect) && stack[i][j].visible {
                stack[i][j].visible = false
                ball.velocity.y *= -1
                break loop
            }
        }
    }
}

check_game_over :: proc(ball: Ball) {
    if ball.center.y + i32(ball.radius) > SCREEN_HEIGHT {
        fmt.println("GAME OVER YOU SUCK")
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

        if ball.center.y >= player.pos.y - player.width && ball.center.x < player.pos.x + player.length && ball.center.x > player.pos.x {
            ball.velocity.y *= -1
            ball.velocity.x = player.x_velocity
        }

        if ball.center.x >= SCREEN_WIDTH || ball.center.x <= 0 {
            ball.velocity.x *= -1
        }
        if ball.center.y - i32(ball.radius) <= 0 {
            ball.velocity.y *= -1
        }

        draw_stack(stack)

        smack_check(&ball, &stack)

        switch {
            case rl.IsKeyDown(.A):
                player.x_velocity = -1
            case rl.IsKeyDown(.D):
                player.x_velocity = 1
            case:
                player.x_velocity = 0
        }

        player.pos.x += player.x_velocity * SPEED
        if player.pos.x + player.length > SCREEN_WIDTH {
            player.pos.x = SCREEN_WIDTH - player.length
        }
        if player.pos.x < 0 {
            player.pos.x = 0
        }

        ball.center.x += ball.velocity.x * SPEED
        ball.center.y += ball.velocity.y * SPEED

        check_game_over(ball)

        rl.ClearBackground(rl.BLACK)

        rl.EndDrawing()
    }
}