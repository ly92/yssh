//
//  NSDate+helper.h
//  EstateBiz
//
//  Created by Ender on 10/21/15.
//  Copyright © 2015 Magicsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

#define D_MINUTE	60
#define D_HOUR		3600
#define D_DAY		86400
#define D_WEEK		604800
#define D_YEAR		31556926

@interface NSDate(helper)
// Relative dates from the current date
+ (NSDate *) dateTomorrow;
+ (NSDate *) dateYesterday;
+ (NSDate *) dateWithDaysFromNow: (NSUInteger) days;
+ (NSDate *) dateWithDaysBeforeNow: (NSUInteger) days;
+ (NSDate *) dateWithHoursFromNow: (NSUInteger) dHours;
+ (NSDate *) dateWithHoursBeforeNow: (NSUInteger) dHours;
+ (NSDate *) dateWithMinutesFromNow: (NSUInteger) dMinutes;
+ (NSDate *) dateWithMinutesBeforeNow: (NSUInteger) dMinutes;



// Comparing dates
- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate;
- (BOOL) isToday;
- (BOOL) isTomorrow;
- (BOOL) isYesterday;
- (BOOL) isSameWeekAsDate: (NSDate *) aDate;
- (BOOL) isThisWeek;
- (BOOL) isNextWeek;
- (BOOL) isLastWeek;
- (BOOL) isSameYearAsDate: (NSDate *) aDate;
- (BOOL) isThisYear;
- (BOOL) isNextYear;
- (BOOL) isLastYear;
- (BOOL) isEarlierThanDate: (NSDate *) aDate;
- (BOOL) isLaterThanDate: (NSDate *) aDate;

// Adjusting dates
- (NSDate *) dateByAddingDays: (NSUInteger) dDays;
- (NSDate *) dateBySubtractingDays: (NSUInteger) dDays;
- (NSDate *) dateByAddingHours: (NSUInteger) dHours;
- (NSDate *) dateBySubtractingHours: (NSUInteger) dHours;
- (NSDate *) dateByAddingMinutes: (NSUInteger) dMinutes;
- (NSDate *) dateBySubtractingMinutes: (NSUInteger) dMinutes;
- (NSDate *) dateByAddingSeconds:(NSUInteger) dSeconds;
- (NSDate *) dateBySubtractingSeconds:(NSUInteger) dSeconds;
- (NSDate *) dateAtStartOfDay;

// Retrieving intervals
- (NSInteger) minutesAfterDate: (NSDate *) aDate;
- (NSInteger) minutesBeforeDate: (NSDate *) aDate;
- (NSInteger) hoursAfterDate: (NSDate *) aDate;
- (NSInteger) hoursBeforeDate: (NSDate *) aDate;
- (NSInteger) daysAfterDate: (NSDate *) aDate;
- (NSInteger) daysBeforeDate: (NSDate *) aDate;


-(NSString *) toStringWithDateFormat:(NSString *)dateFormat;

//stringToDate
+ (NSDate *)dateFromString:(NSString *)string;
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;

+ (NSDate *)dateFromStr:(NSString *)string withFormat:(NSString *)format;
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format;

+ (NSString *)dateExceptYearAndSecondFormatString;
+ (NSString *)dateExceptSecondFormatString;

//compare
- (NSDateComponents *)componentsWithOffsetFromDate: (NSDate *) aDate;


//FormatString
+ (NSString *)DayFormatString;
+ (NSString *)dateFormatString;
+ (NSString *)shortDateFormatString;
+ (NSString *)timeFormatString;
+ (NSString *)monthFormatString;
+ (NSString *)timestampFormatString;
+ (NSString *)datestampFormatString;
+ (NSString *)dbFormatString;

//php转换
+(NSString *)longlongToDate:(NSString *)sender;
+(NSString *)longlongToDateTime:(NSString *)sender;
+(NSString *)longlongToDateTimeRemoveSeconds:(NSString *)sender;
+(NSString *)longlongToDateTimeRemoveYear:(NSString *)sender;
+(NSString *)longlongToDayDateTime:(NSString *)sender;
+(NSString *)timeChargeToCustomDate:(NSString *)sender dateFormat:(NSString *)format;

//php时间戳
+(NSString *)phpTimestamp;
//时间戳
+(NSString *)phpTimestampFrom:(NSDate *)date;
//时间戳
+(NSString *)phpTimestampFromStartDate:(NSDate *)startDate ToDate:(NSDate *)endDate;

- (NSString *)timeAgo;

// Decomposing dates
@property (readonly) NSInteger nearestHour;
@property (readonly) NSInteger hour;
@property (readonly) NSInteger minute;
@property (readonly) NSInteger seconds;
@property (readonly) NSInteger day;
@property (readonly) NSInteger month;
@property (readonly) NSInteger week;
@property (readonly) NSInteger weekday;
@property (readonly) NSInteger nthWeekday; // e.g. 2nd Tuesday of the month == 2
@property (readonly) NSInteger year;
@end
