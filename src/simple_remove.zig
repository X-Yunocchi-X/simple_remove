const std = @import("std");

const Date = @import("date.zig").Date;

const Dir = std.fs.Dir;
const File = std.fs.File;

const Allocator = std.mem.Allocator;

pub const Remover = struct {
    trash_dir: Dir,
    args: []const [:0]u8,
    allocator: std.mem.Allocator,

    pub fn new(args: []const [:0]u8, allocator: std.mem.Allocator) !Remover {
        const home = std.os.getenv("HOME") orelse return error.HomeNotFound;
        const trash_path = try std.fmt.allocPrint(allocator, "{s}{s}", .{ home, "/.local/share/Trash/" });
        defer allocator.free(trash_path);
        var trash_dir = try std.fs.openDirAbsolute(trash_path, .{ .access_sub_paths = true });
        std.debug.print("home path: {s}\ntrash path: {s}\n", .{ home, trash_path });
        return Remover{ .trash_dir = trash_dir, .args = args, .allocator = allocator };
    }

    pub fn deinit(self: *Remover) void {
        self.trash_dir.close();
    }

    pub fn createFileInfo(self: Remover, path: []const u8) !void {
        const file_name = std.fs.path.basename(path);
        var info_dir = try self.trash_dir.openDir("info", .{});
        defer info_dir.close();

        std.debug.print("file name: {s}\n", .{file_name});
        const trash_path = try std.fmt.allocPrint(self.allocator, "{s}{s}", .{ file_name, ".trashinfo" });
        defer self.allocator.free(trash_path);
        var file = try info_dir.createFile(trash_path, .{});
        defer file.close();

        const date = Date.new(std.time.timestamp());
        const file_info = try std.fmt.allocPrint(self.allocator, "[Trash Info]\nPath={s}\nDeletionDate={d}-{d}-{d}T{d}:{d}:{d}", .{ path, date.year, date.month, date.day, date.hour, date.minute, date.second });
        defer self.allocator.free(file_info);
        _ = try file.write(file_info);
    }
};
