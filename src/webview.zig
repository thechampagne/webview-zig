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
const mem = @import("std").mem;
pub const raw = @import("raw.zig");

pub const WebView = struct {
    
    webview: raw.webview_t,

    const Self = @This();

    pub const WebViewVersionInfo = raw.webview_version_info_t;

    pub const DispatchCallback = *const fn (WebView, ?*anyopaque) callconv(.C) void;

    pub const BindCallback = *const fn ([:0]const u8, [:0]const u8, ?*anyopaque) callconv(.C) void;

    pub const WindowSizeHint = enum(c_int) {
        None,
        Min,
        Max,
        Fixed
    };

    pub fn create(debug: bool, window: ?*anyopaque) Self {
        return Self{ .webview = raw.webview_create(@intFromBool(debug), window) };
    }

    pub fn run(self: Self) void {
        raw.webview_run(self.webview);
    }

    pub fn terminate(self: Self) void {
        raw.webview_terminate(self.webview);
    }
    
    pub fn dispatch(self: Self, func: DispatchCallback, arg: ?*anyopaque) void {
        const register = struct {
            var callback: DispatchCallback = undefined;
            fn call(w: raw.webview_t, ctx: ?*anyopaque) callconv(.C) void {
                callback(.{ .webview = w}, ctx);
            }
        };
        register.callback = func;
        raw.webview_dispatch(self.webview, register.call, arg);
    }
    
    pub fn getWindow(self: Self) ?*anyopaque {
        return raw.webview_get_window(self.webview);
    }
    
    pub fn setTitle(self: Self, title: [:0]const u8) void {
        raw.webview_set_title(self.webview, title.ptr);
    }
    
    pub fn setSize(self: Self, width: i32, height: i32, hint: WindowSizeHint) void {
        raw.webview_set_size(self.webview, width, height, @intFromEnum(hint));
    }
    
    pub fn navigate(self: Self, url: [:0]const u8) void {
        raw.webview_navigate(self.webview, url.ptr);
    }
    
    pub fn setHtml(self: Self, html: [:0]const u8) void {
        raw.webview_set_html(self.webview, html.ptr);
    }
    
    pub fn init(self: Self, js: [:0]const u8) void {
        raw.webview_init(self.webview, js.ptr);
    }
    
    pub fn eval(self: Self, js: [:0]const u8) void {
        raw.webview_eval(self.webview, js.ptr);
    }
    
    pub fn bind(self: Self, name: [:0]const u8, func: BindCallback, arg: ?*anyopaque) void {
        const register = struct {
            var callback: BindCallback = undefined;
            fn call(seq: [*c]const u8, req: [*c]const u8, ctx: ?*anyopaque) callconv(.C) void {
                callback(mem.sliceTo(seq), mem.sliceTo(req), ctx);
            }
        };
        register.callback = func;
        raw.webview_bind(self.webview, name.ptr, register.call, arg);
    }
    
    pub fn unbind(self: Self, name: [:0]const u8) void {
        raw.webview_unbind(self.webview, name.ptr);
    }
    
    pub fn ret(self: Self ,seq: [:0]const u8, status: i32, result: [:0]const u8) void {
        raw.webview_return(self.webview, seq.ptr, status, result.ptr);
    }
    
    pub fn version() *const WebViewVersionInfo {
        return raw.webview_version();
    }

    pub fn destroy(self: Self) void {
        raw.webview_destroy(self.webview);
    }
};
