const std = @import("std");

pub const Remover = struct {
    trash_path: []const u8,
    args: []const [:0]u8,

    pub fn new(args: []const [:0]u8) !Remover {
        const path = std.os.getenv("HOMEkd") orelse return error.HomeNotFound;
        var buffer: [100]u8 = undefined;
        const trash_path = try std.fmt.bufPrint(buffer[0..], "{s}{s}", .{ path, "/.local/share/Trash/" });

        for (args) |arg| {
            std.debug.print("{s}\n", .{arg});
        }

        std.debug.print("home path: {s}\ntrash path: {s}\n", .{ path, trash_path });
        return Remover{ .trash_path = trash_path, .args = args };
    }
};
