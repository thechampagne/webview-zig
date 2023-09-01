// Copyright (c) 2023 XXIV
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
pub const WEBVIEW_VERSION_MAJOR = @as(c_int, 0);
pub const WEBVIEW_VERSION_MINOR = @as(c_int, 10);
pub const WEBVIEW_VERSION_PATCH = @as(c_int, 0);

pub const WEBVIEW_VERSION_NUMBER = "0.10.0";

pub const WEBVIEW_HINT_NONE = @as(c_int, 0);
pub const WEBVIEW_HINT_MIN = @as(c_int, 1);
pub const WEBVIEW_HINT_MAX = @as(c_int, 2);
pub const WEBVIEW_HINT_FIXED = @as(c_int, 3);

pub const webview_version_t = extern struct {
    major: c_uint,
    minor: c_uint,
    patch: c_uint,
};
pub const webview_version_info_t = extern struct {
    version: webview_version_t,
    version_number: [32]u8,
    pre_release: [48]u8,
    build_metadata: [48]u8,
};
pub const webview_t = ?*anyopaque;
pub extern fn webview_create(debug: c_int, window: ?*anyopaque) webview_t;
pub extern fn webview_destroy(w: webview_t) void;
pub extern fn webview_run(w: webview_t) void;
pub extern fn webview_terminate(w: webview_t) void;
pub extern fn webview_dispatch(w: webview_t, @"fn": ?*const fn (webview_t, ?*anyopaque) callconv(.C) void, arg: ?*anyopaque) void;
pub extern fn webview_get_window(w: webview_t) ?*anyopaque;
pub extern fn webview_set_title(w: webview_t, title: [*c]const u8) void;
pub extern fn webview_set_size(w: webview_t, width: c_int, height: c_int, hints: c_int) void;
pub extern fn webview_navigate(w: webview_t, url: [*c]const u8) void;
pub extern fn webview_set_html(w: webview_t, html: [*c]const u8) void;
pub extern fn webview_init(w: webview_t, js: [*c]const u8) void;
pub extern fn webview_eval(w: webview_t, js: [*c]const u8) void;
pub extern fn webview_bind(w: webview_t, name: [*c]const u8, @"fn": ?*const fn ([*c]const u8, [*c]const u8, ?*anyopaque) callconv(.C) void, arg: ?*anyopaque) void;
pub extern fn webview_unbind(w: webview_t, name: [*c]const u8) void;
pub extern fn webview_return(w: webview_t, seq: [*c]const u8, status: c_int, result: [*c]const u8) void;
pub extern fn webview_version() [*c]const webview_version_info_t;
