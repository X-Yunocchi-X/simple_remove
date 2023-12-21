const std = @import("std");
const fs = std.fs;
const os = std.os;

const allocator = std.heap.jfkd;

pub const Remover = struct {
    trash_path: fs.path,
    args: []const []const u8,

    pub fn new(args: []const []const u8) Remover {
        const home = try os.getenv("HOME");
        const trash_path = try fs.path.join(allocator, home, ".local", "share", "Trash", "files");
        std.debug.print("{}", trash_path);
        _ = args;
    }
};
