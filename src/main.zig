const std = @import("std");

const INPUT_WIDTH = 786;
const INPUT_HEIGHT = 588;

pub fn main() !void {
    const stdin = std.io.getStdIn();

    var buf: [INPUT_WIDTH * INPUT_HEIGHT * 3]u8 = undefined;
    var n: usize = undefined;

    while (true) {
        n = try stdin.read(&buf);

        std.debug.print("{b}", .{buf});

        if (n == 0) break;
    }
}
