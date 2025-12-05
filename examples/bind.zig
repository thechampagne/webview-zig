const std = @import("std");
const WebView = @import("webview").WebView;

const html = 
        \\ <button id="increment">Click me</button>
        \\ <div>You clicked <span id="count">0</span> time(s).</div>
        \\ <script>
        \\ const [incrementElement, countElement] = document.querySelectorAll("#increment, #count");
        \\ document.addEventListener("DOMContentLoaded", () => {
        \\   incrementElement.addEventListener("click", () => {
        \\     window.increment(countElement.innerText).then(result => {
        \\       countElement.textContent = result;
        \\     });
        \\   });
        \\ });
        \\ </script>
;

pub fn increment(id: [*:0]const u8, req: [*:0]const u8, ctx: ?*anyopaque) callconv(.c) void {
    var webview: *const WebView = @ptrCast(@alignCast(ctx));
    const num_str = std.mem.trim(u8, std.mem.sliceTo(req, 0), "[\"\"]");
    var num = std.fmt.parseInt(i32, num_str, 10) catch {
        std.debug.print("cant not parse int.\n", .{});
        unreachable;
    };
    num += 1;
    var buf: [10]u8 = undefined;
    const result = std.fmt.bufPrintZ(&buf, "{d}", .{num}) catch {
        std.debug.print("cant not copy to result.\n", .{});
        unreachable;
    };
    webview.ret(std.mem.sliceTo(id, 0), 0, result) catch {
        std.debug.print("cant not return from increment function.\n", .{});
        unreachable;
    };
    std.debug.print("req: {s}, result: {s}\n", .{req, result});
}

pub fn main() !void {
    var w = WebView.create(true, null);
    try w.setTitle("Bind Example");
    try w.setSize(480, 320, .none);

    try w.bind("increment", &increment, &w);
    
    try w.setHtml(html);
    try w.run();
    try w.destroy();
}
