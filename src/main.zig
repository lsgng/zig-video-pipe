const std = @import("std");

const INPUT_WIDTH = 786;
const INPUT_HEIGHT = 588;

pub fn main() !void {
    const stdin = std.io.getStdIn();

    var buf = [_]u8{0} ** (INPUT_HEIGHT * INPUT_HEIGHT * 3);

    var n: usize = undefined;

    while (true) {
        n = try stdin.read(&buf);

        for (buf) |a| {
            std.debug.print("{c}", .{a});
        }

        if (n == 0) break;
    }
}
