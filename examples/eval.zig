const std = @import("std");
const WebView = @import("webview").WebView;

const JS =
    \\var h1 = document.createElement("h1")
    \\h1.innerHTML = "Hello webview from Zig!"
    \\document.body.appendChild(h1)
;

pub fn main() !void {
    const w = WebView.create(false, null);
    try w.setTitle("Calling Javascript");
    try w.setSize(480, 320, .none);
    try w.eval(JS);
    try w.run();
    try w.destroy();
}
