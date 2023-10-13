const std = @import("std");

const R = @import("raylib");

const INPUT_WIDTH = 786;
const INPUT_HEIGHT = 588;

pub fn main() !void {
    R.SetConfigFlags(R.ConfigFlags{});
    R.InitWindow(INPUT_WIDTH, INPUT_HEIGHT, "zig-video-pipe!");
    R.SetTargetFPS(60);

    defer R.CloseWindow();

    const stdin = std.io.getStdIn();

    var buf = [_]u8{0} ** (INPUT_WIDTH * INPUT_HEIGHT * 3);
    var n: usize = undefined;

    while (!R.WindowShouldClose()) {
        R.BeginDrawing();
        defer R.EndDrawing();

        n = try stdin.read(&buf);
        std.debug.print("{}\n", .{n});

        var i: usize = 0;
        while (i < buf.len) : (i += 3) {
            const color = R.Color{
                .r = buf[i],
                .g = buf[i + 1],
                .b = buf[i + 2],
                .a = 255,
            };

            const x = i / 3 % INPUT_WIDTH;
            const y = i / 3 / INPUT_WIDTH;
            R.DrawPixel(@as(i32, @intCast(x)), @as(i32, @intCast(y)), color);
        }

        // for (buf) |a| {
        //     std.debug.print("{c}", .{a});
        // }

        // R.ClearBackground(R.BLACK);
        R.DrawFPS(10, 10);

        // while (true) {
        //     n = try stdin.read(&buf);

        //     for (buf) |a| {
        //         std.debug.print("{c}", .{a});
        //     }

        //     if (n == 0) break;
        // }
    }
}
