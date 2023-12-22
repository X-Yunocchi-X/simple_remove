const std = @import("std");

const fs = std.fs;
const Dir = fs.Dir;
const File = fs.File;

const Allocator = std.mem.Allocator;

pub const Remover = struct {
    trash_dir: Dir,
    args: []const [:0]u8,

    pub fn new(args: []const [:0]u8) !Remover {
        const path = std.os.getenv("HOME") orelse return error.HomeNotFound;
        var buffer: [100]u8 = undefined;
        const trash_path = try std.fmt.bufPrint(buffer[0..], "{s}{s}", .{ path, "/.local/share/Trash/" });
        const trash_dir = try fs.openDirAbsolute(trash_path, .{ .access_sub_paths = true });
        std.debug.print("home path: {s}\ntrash path: {s}\n", .{ path, trash_path });
        return Remover{ .trash_dir = trash_dir, .args = args };
    }

    fn create_file_info(self: @This(), file: File) !void {
        _ = file;
        var info_dir = try self.trash_dir.openDir("info");
        defer info_dir.close();
    }
};
