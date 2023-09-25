const WebView = @import("webview").WebView;

const JS =
    \\var h1 = document.createElement("h1")
    \\h1.innerHTML = "Hello webview from Zig!"
    \\document.body.appendChild(h1)
;

pub fn main() void {
    const w = WebView.create(false, null);
    defer w.destroy();
    w.setTitle("Calling Javascript");
    w.setSize(480, 320, WebView.WindowSizeHint.None);
    w.eval(JS);
    w.run();
}
