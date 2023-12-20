const std = @import("std");
const fs = std.fs;
const os = std.os;

pub const SimpleRemove = struct {
    trash_path: fs.Path,
    args: []const []const u8,

    pub fn new(args: []const []const u8) SimpleRemove {
        const home = try os.getenv("HOME");
        _ = home;
        _ = args;
    }
};
