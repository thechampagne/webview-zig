const std = @import("std");

pub fn build(b: *std.Build) void {
    _ = b.addModule("webview", .{
        .source_file = .{ .path = "src/webview.zig" },
        .dependencies = &[_]std.Build.ModuleDependency{},
    });
}
