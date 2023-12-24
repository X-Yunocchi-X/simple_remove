const std = @import("std");

const Date = @import("date.zig").Date;

const Dir = std.fs.Dir;
const File = std.fs.File;

const Allocator = std.mem.Allocator;

pub const Remover = struct {
    trash_dir: Dir,
    args: []const [:0]u8,
    allocator: std.mem.Allocator,

    pub fn new(args: []const [:0]u8) !Remover {
        const allocator = std.heap.GeneralPurposeAllocator(){};
        const home = std.os.getenv("HOME") orelse return error.HomeNotFound;
        const trash_path = try std.fmt.allocPrint(allocator, "{}{}", .{ home, "/.local/share/Trash/" });
        const trash_dir = try std.fs.openDirAbsolute(trash_path, .{ .access_sub_paths = true });
        std.debug.print("home path: {s}\ntrash path: {s}\n", .{ home, trash_path });
        return Remover{
            .trash_dir = trash_dir,
            .args = args,
            .allocator = allocator,
        };
    }

    pub fn deinit(self: Remover) void {
        self.trash_dir.close();
    }

    pub fn createFileInfo(self: Remover, path: []const u8) void {
        const file_name = std.fs.path.basename(path);
        const info_dir = try self.trash_dir.openDir("info", .{});
        defer info_dir.close();
        std.debug.print("file name: {s}\n", .{file_name});
        var buffer: [100]u8 = undefined;
        const trash_path = try std.fmt.bufPrint(buffer[0..], "{s}{s}", .{ file_name, ".trashinfo" });
        const file = try info_dir.createFile(trash_path, .{});
        defer file.close();
        // const now_time: i64 = try std.time.milliTimestamp();
        // const info_str = try std.fmt.allocPrint(std.heap.page_allocator, "[Trash Info]\nPath={s}\nDeletionDate={}", .{
        //     path
        //});
    }
};

fn getFormattedTime() ![]const u8 {
    const allocator = std.heap.GeneralPurposeAllocator(.{}){};
    defer allocator.deinit();

    const now_time = std.time.milliTimestamp();
    _ = now_time;
    const str = try std.fmt.allocPrint(allocator, "{} = {}\n", .{ 1, 2 });
    _ = str;
}
