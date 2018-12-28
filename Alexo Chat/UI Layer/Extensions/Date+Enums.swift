//
//  Date+Enums.swift
//  Alexo Chat
//
//  Created by Emil Karimov on 14/11/2018.
//  Copyright © 2018 Emil Karimov. All rights reserved.
//

import Foundation

// MARK: Enums used

/**
 The string format used for date string conversion.
 
 ````
 case isoYear: i.e. 1997
 case isoYearMonth: i.e. 1997-07
 case isoDate: i.e. 1997-07-16
 case isoDateTime: i.e. 1997-07-16T19:20+01:00
 case isoDateTimeSec: i.e. 1997-07-16T19:20:30+01:00
 case isoDateTimeMilliSec: i.e. 1997-07-16T19:20:30.45+01:00
 case dotNet: i.e. "/Date(1268123281843)/"
 case rss: i.e. "Fri, 09 Sep 2011 15:26:08 +0200"
 case altRSS: i.e. "09 Sep 2011 15:26:08 +0200"
 case httpHeader: i.e. "Tue, 15 Nov 1994 12:45:26 GMT"
 case standard: "EEE MMM dd HH:mm:ss Z yyyy"
 case custom(String): a custom date format string
 ````
 
 */
public enum DateFormatType {

    /// The ISO8601 formatted year "yyyy" i.e. 1997
    case isoYear

    /// The ISO8601 formatted year and month "yyyy-MM" i.e. 1997-07
    case isoYearMonth

    /// The ISO8601 formatted date "yyyy-MM-dd" i.e. 1997-07-16
    case isoDate

    /// The ISO8601 formatted date and time "yyyy-MM-dd'T'HH:mmZ" i.e. 1997-07-16T19:20+01:00
    case isoDateTime

    /// The ISO8601 formatted date, time and sec "yyyy-MM-dd'T'HH:mm:ssZ" i.e. 1997-07-16T19:20:30+01:00
    case isoDateTimeSec

    /// The ISO8601 formatted date, time and millisec "yyyy-MM-dd'T'HH:mm:ss.SSSZ" i.e. 1997-07-16T19:20:30.45+01:00
    case isoDateTimeMilliSec

    /// The dotNet formatted date "/Date(%d%d)/" i.e. "/Date(1268123281843)/"
    case dotNet

    /// The RSS formatted date "EEE, d MMM yyyy HH:mm:ss ZZZ" i.e. "Fri, 09 Sep 2011 15:26:08 +0200"
    case rss

    /// The Alternative RSS formatted date "d MMM yyyy HH:mm:ss ZZZ" i.e. "09 Sep 2011 15:26:08 +0200"
    case altRSS

    /// The http header formatted date "EEE, dd MM yyyy HH:mm:ss ZZZ" i.e. "Tue, 15 Nov 1994 12:45:26 GMT"
    case httpHeader

    /// A generic standard format date i.e. "EEE MMM dd HH:mm:ss Z yyyy"
    case standard

    /// A custom date format string
    case custom(String)

    var stringFormat: String {
        switch self {
        case .isoYear: return "yyyy"
        case .isoYearMonth: return "yyyy-MM"
        case .isoDate: return "yyyy-MM-dd"
        case .isoDateTime: return "yyyy-MM-dd'T'HH:mmZ"
        case .isoDateTimeSec: return "yyyy-MM-dd'T'HH:mm:ssZ"
        case .isoDateTimeMilliSec: return "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        case .dotNet: return "/Date(%d%f)/"
        case .rss: return "EEE, d MMM yyyy HH:mm:ss ZZZ"
        case .altRSS: return "d MMM yyyy HH:mm:ss ZZZ"
        case .httpHeader: return "EEE, dd MM yyyy HH:mm:ss ZZZ"
        case .standard: return "EEE MMM dd HH:mm:ss Z yyyy"
        case .custom(let customFormat): return customFormat
        }
    }
}

/// The time zone to be used for date conversion
public enum TimeZoneType {
    case local, utc

    var timeZone: TimeZone {
        switch self {
        case .local: return NSTimeZone.local
        case .utc: return TimeZone(secondsFromGMT: 0)!
        }
    }
}

// The string keys to modify the strings in relative format
public enum RelativeTimeStringType {
    case nowPast, nowFuture, secondsPast, secondsFuture, oneMinutePast, oneMinuteFuture, minutesPast, minutesFuture, oneHourPast, oneHourFuture, hoursPast, hoursFuture, oneDayPast, oneDayFuture, daysPast, daysFuture, oneWeekPast, oneWeekFuture, weeksPast, weeksFuture, oneMonthPast, oneMonthFuture, monthsPast, monthsFuture, oneYearPast, oneYearFuture, yearsPast, yearsFuture
}

// The type of comparison to do against today's date or with the suplied date.
public enum DateComparisonType {

    // Days

    /// Checks if date today.
    case isToday
    /// Checks if date is tomorrow.
    case isTomorrow
    /// Checks if date is yesterday.
    case isYesterday
    /// Compares date days
    case isSameDay(as:Date)

    // Weeks

    /// Checks if date is in this week.
    case isThisWeek
    /// Checks if date is in next week.
    case isNextWeek
    /// Checks if date is in last week.
    case isLastWeek
    /// Compares date weeks
    case isSameWeek(as:Date)

    // Months

    /// Checks if date is in this month.
    case isThisMonth
    /// Checks if date is in next month.
    case isNextMonth
    /// Checks if date is in last month.
    case isLastMonth
    /// Compares date months
    case isSameMonth(as:Date)

    // Years

    /// Checks if date is in this year.
    case isThisYear
    /// Checks if date is in next year.
    case isNextYear
    /// Checks if date is in last year.
    case isLastYear
    /// Compare date years
    case isSameYear(as:Date)

    // Relative Time

    /// Checks if it's a future date
    case isInTheFuture
    /// Checks if the date has passed
    case isInThePast
    /// Checks if earlier than date
    case isEarlier(than:Date)
    /// Checks if later than date
    case isLater(than:Date)
    /// Checks if it's a weekday
    case isWeekday
    /// Checks if it's a weekend
    case isWeekend

}

// The date components available to be retrieved or modifed
public enum DateComponentType {
    case second, minute, hour, day, weekday, nthWeekday, week, month, year
}

// The type of date that can be used for the dateFor function.
public enum DateForType {
    case startOfDay, endOfDay, startOfWeek, endOfWeek, startOfMonth, endOfMonth, tomorrow, yesterday, nearestMinute(minute:Int), nearestHour(hour:Int)
}

// Convenience types for date to string conversion
public enum DateStyleType {
    /// Short style: "2/27/17, 2:22 PM"
    case short
    /// Medium style: "Feb 27, 2017, 2:22:06 PM"
    case medium
    /// Long style: "February 27, 2017 at 2:22:06 PM EST"
    case long
    /// Full style: "Monday, February 27, 2017 at 2:22:06 PM Eastern Standard Time"
    case full
    /// Ordinal day: "27th"
    case ordinalDay
    /// Weekday: "Monday"
    case weekday
    /// Short week day: "Mon"
    case shortWeekday
    /// Very short weekday: "M"
    case veryShortWeekday
    /// Month: "February"
    case month
    /// Short month: "Feb"
    case shortMonth
    /// Very short month: "F"
    case veryShortMonth
}

extension Date {
    private static var timeUTCFormatter: DateFormatter {
        let fr = DateFormatter()
        fr.dateFormat = "HH:mm"
        fr.timeZone = TimeZone(secondsFromGMT: 0)

        return fr
    }

    private static var timeFormatter: DateFormatter {
        let fr = DateFormatter()
        fr.dateFormat = "HH:mm"
        fr.timeZone = TimeZone.current

        return fr
    }

    private static var edmyUTCFormatter: DateFormatter {
        let fr = DateFormatter()
        fr.dateFormat = "E, dd.MM.yyyy"
        fr.timeZone = TimeZone(secondsFromGMT: 0)

        return fr
    }

    private static var edmyFormatter: DateFormatter {
        let fr = DateFormatter()
        fr.dateFormat = "E, dd.MM.yyyy"
        fr.timeZone = TimeZone.current

        return fr
    }

    private static var timeAndDateFormatter: DateFormatter {
        let fr = DateFormatter()
        fr.dateFormat = "HH:mm dd.MM.yyyy"
        fr.timeZone = TimeZone.current
        return fr
    }

    private static var timeAndDateUTCFormatter: DateFormatter {
        let fr = DateFormatter()
        fr.dateFormat = "HH:mm dd.MM.yyyy"
        fr.timeZone = TimeZone(secondsFromGMT: 0)
        return fr
    }

    func formatHHMM(systemTZ: Bool = true) -> String {
        let formatter = systemTZ ? Date.timeFormatter : Date.timeUTCFormatter
        return formatter.string(from: self)
    }

    func formatTimeAndDate(systemTZ: Bool = false) -> String {
        let formatter = systemTZ ? Date.timeAndDateFormatter : Date.timeAndDateUTCFormatter
        return formatter.string(from: self)
    }

    func formatDMYRelative(systemTZ: Bool = false) -> String {
        var calendar = Calendar.current
        calendar.timeZone = systemTZ ? TimeZone.current : TimeZone(secondsFromGMT: 0)!

        var dateComps = calendar.dateComponents([.year, .month, .day], from: Date())
        dateComps.hour = 0
        dateComps.minute = 0
        dateComps.second = 0
        let today = calendar.date(from: dateComps)!

        if today.compare(self) == ComparisonResult.orderedSame {
            return "Сегодня"
        }

        var yesterdayComps = DateComponents()
        yesterdayComps.day = -1
        let yesterday = calendar.date(byAdding: yesterdayComps, to: today)
        if yesterday!.compare(self) == ComparisonResult.orderedSame {
            return "Вчера"
        }

        return (systemTZ ? Date.edmyFormatter: Date.edmyUTCFormatter).string(from: self)
    }

    func formatEDMY(systemTZ: Bool = false) -> String {
        return (systemTZ ? Date.edmyFormatter: Date.edmyUTCFormatter).string(from: self)
    }
}
