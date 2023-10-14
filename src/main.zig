const std = @import("std");

const R = @import("raylib");

const INPUT_WIDTH = 786;
const INPUT_HEIGHT = 588;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();

    const argv = [_][]const u8{
        "ffmpeg",
        "-i",
        "in.mov",
        "-f",
        "rawvideo",
        "-pix_fmt",
        "rgb24",
        "-",
    };

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
        .format = 4,
    };
    var texture = R.LoadTextureFromImage(image);
    defer R.UnloadTexture(texture);

    var process = std.process.Child.init(&argv, allocator);
    process.stdout_behavior = .Pipe;
    try process.spawn();

    while (!R.WindowShouldClose()) {
        R.BeginDrawing();
        defer R.EndDrawing();

        R.ClearBackground(R.BLACK);

        _ = try process.stdout.?.readAll(&pixels);

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

    _ = try process.kill();
}
