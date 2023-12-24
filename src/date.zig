const std = @import("std");

pub const Date = struct {
    year: u16,
    month: u4,
    day: u5,
    hour: u5,
    minute: u6,
    second: u6,

    pub fn new(secs: i64) Date {
        const epoch = std.time.epoch.EpochSeconds{ .secs = secs };
        const epoch_day = epoch.getEpochDay();
        const year_day = epoch_day.calculateYearDay();
        const month_day = year_day.calculateMonthDay();
        const day_seconds = epoch.getDaySeconds();

        const year = year_day.year;
        const month = month_day.month.numeric();
        const day = month_day.day_index + 1;
        const hour = day_seconds.getHoursIntoDay();
        const minute = day_seconds.getMinutesIntoHour();
        const second = day_seconds.getSecondsIntoMinute();

        return Date{ .year = year, .month = month, .day = day, .hour = hour, .minute = minute, .second = second };
    }
};
