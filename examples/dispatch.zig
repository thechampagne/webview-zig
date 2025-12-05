const std = @import("std");
const WebView = @import("webview").WebView;

fn dispatch(w: ?*anyopaque, _: ?*anyopaque) callconv(.c) void {
    const webview: WebView = .{.webview = w};
    webview.setTitle("Calling Dispatch") catch @panic("oh");
}

pub fn main() !void {
    const w = WebView.create(false, null);
    try w.setSize(480, 320, .none);
    try w.dispatch(&dispatch, null);
    try w.run();
    try w.destroy();
}
