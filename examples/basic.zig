const WebView = @import("webview").WebView;

pub fn main() !void {
    const w = WebView.create(false, null);
    try w.setTitle("Basic Example");
    try w.setSize(480, 320, .none);
    try w.setHtml("Thanks for using webview!");
    try w.run();
    try w.destroy();
}
