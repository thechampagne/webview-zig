const std = @import("std");
const webview = @import("./webview.zig");

test {
    std.testing.refAllDecls(webview);
}
