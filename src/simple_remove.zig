const std = @import("std");

const Date = @import("date.zig").Date;

const Dir = std.fs.Dir;
const File = std.fs.File;

const Allocator = std.mem.Allocator;

pub const Remover = struct {
    trash_dir: Dir,
    args: []const []u8,
    allocator: std.mem.Allocator,

    pub fn new(args: []const []u8, allocator: std.mem.Allocator) !Remover {
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

    pub fn remove(self: Remover, path: []const u8) !void {
        try self.createInfo(path);
        const stat = try std.fs.cwd().statFile(path);
        switch (stat.kind) {
            .directory => {
                std.debug.print("target {s} is {s}\n", .{ path, @tagName(stat.kind) });
                self.createDirCache(path);
            },
            .file => {
                std.debug.print("target {s} is {s}\n", .{ path, @tagName(stat.kind) });
            },
            else => {
                std.debug.print("target is {s}\n", .{@tagName(stat.kind)});
                return error.TargetNotSupported;
            },
        }
        const file_name = std.fs.path.basename(path);
        var bin_dir = try self.trash_dir.openDir("files", .{});
        const bin_path = try bin_dir.realpathAlloc(self.allocator, ".");
        const destination = try std.fmt.allocPrint(self.allocator, "{s}/{s}", .{ bin_path, file_name });
        defer {
            bin_dir.close();
            self.allocator.free(bin_path);
            self.allocator.free(destination);
        }
        std.debug.print("destination: {s}\n", .{destination});
        try std.fs.renameAbsolute(path, destination);
    }

    // used after createInfo method invoked
    pub fn createDirCache(self: Remover, path: []const u8) !void {
        var file = try self.trash_dir.createFile("directorysizes", .{
            .truncate = false,
        });
        var target_dir = try std.fs.cwd().openIterableDir(path, .{});
        const file_name = std.fs.path.basename(path);
        const trash_path = try self.trash_dir.realpathAlloc(self.allocator, ".");
        const info_path = std.fmt.allocPrint(self.allocator, "{}/info/{}.{}", .{ trash_path, file_name, "trashinfo" });
        var info_file = try std.fs.cwd().openFile(info_path, .{});
        const mtime = getInfoModifiedTime(&info_file);
        const dir_size = calculateDirSize(&target_dir);
        const cache_str = try std.fmt.allocPrint(self.allocator, "{d} {d} {s}\n", .{ dir_size, mtime, file_name });
        _ = try file.write(cache_str);
        defer {
            target_dir.close();
            self.allocator.free(trash_path);
            self.allocator.free(info_path);
            info_file.close();
            file.close();
            self.allocator.free(cache_str);
        }
    }

    fn getInfoModifiedTime(file: *File) !u64 {
        const stat = try file.stat();
        const result = @divTrunc(stat.mtime, std.time.ns_per_ms);
        return @intCast(result);
    }

    fn calculateDirSize(dir: *std.fs.IterableDir, allocator: std.mem.Allocator) !u64 {
        var size = @as(u64, 0);

        const stat = try dir.dir.stat();
        size += stat.size;
        var walker = try dir.walk(allocator);
        _ = walker;
        return size;
    }

    fn createInfo(self: Remover, path: []const u8) !void {
        const file_name = std.fs.path.basename(path);
        var info_dir = try self.trash_dir.openDir("info", .{});
        defer info_dir.close();

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
