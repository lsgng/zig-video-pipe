const std = @import("std");

const R = @import("raylib");

const INPUT_WIDTH = 786;
const INPUT_HEIGHT = 588;

pub fn main() !void {
    R.SetConfigFlags(R.ConfigFlags{});
    R.InitWindow(INPUT_WIDTH, INPUT_HEIGHT, "zig-video-pipe!");
    R.SetTargetFPS(60);

    defer R.CloseWindow();

    var pixels = [_]u8{0} ** (INPUT_WIDTH * INPUT_HEIGHT * 3);
    var image = R.Image{
        .data = @ptrCast(&pixels),
        .width = INPUT_WIDTH,
        .height = INPUT_HEIGHT,
        .mipmaps = 1,
        .format = 7,
    };
    var texture = R.LoadTextureFromImage(image);
    defer R.UnloadTexture(texture);

    const reader = std.io.getStdIn().reader();
    var stream = std.io.bufferedReader(reader);
    var r = stream.reader();

    var buf = [_]u8{0} ** (INPUT_WIDTH * INPUT_HEIGHT * 3);
    var n: usize = undefined;
    _ = n;

    while (!R.WindowShouldClose()) {
        R.BeginDrawing();
        defer R.EndDrawing();

        R.ClearBackground(R.BLACK);

        _ = try r.read(&buf);

        pixels = buf;

        R.UpdateTexture(texture, &pixels);
        R.DrawTexturePro(
            texture,
            R.Rectangle{
                .x = 0,
                .y = 0,
                .width = INPUT_WIDTH,
                .height = INPUT_HEIGHT,
            },
            R.Rectangle{
                .x = 0,
                .y = 0,
                .width = @as(f32, @floatFromInt(R.GetScreenWidth())),
                .height = @as(f32, @floatFromInt(R.GetScreenHeight())),
            },
            R.Vector2{ .x = 0, .y = 0 },
            0,
            R.WHITE,
        );

        R.DrawFPS(10, 10);
    }
}
