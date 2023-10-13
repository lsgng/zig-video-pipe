const std = @import("std");
const raylib = @import("raylib/build.zig");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const mode = b.standardOptimizeOption(.{ .preferred_optimize_mode = std.builtin.OptimizeMode.ReleaseFast });

    const exe = b.addExecutable(.{
        .name = "zig-video-pipe",
        .root_source_file = std.build.FileSource.relative("src/main.zig"),
        .optimize = mode,
        .target = target,
    });

    raylib.addTo(b, exe, target, mode);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);
}
