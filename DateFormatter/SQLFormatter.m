//
//  nic.m
//  DateFormatter
//
//  Created by Marcin Pędzimąż on 05.08.2015.
//  Copyright (c) 2015 Marcin Małysz. All rights reserved.
//

#import "SQLFormatter.h"
#import "sqlite3.h"

typedef int64_t kTimeStamp;

@implementation SQLFormatter

+ (NSArray *)parseDatesUsingStringArray:(NSArray *)stringsArray
{
    sqlite3 *db = NULL;
    sqlite3_open(":memory:", &db);
    
    sqlite3_stmt *statement = NULL;
    sqlite3_prepare_v2(db, "SELECT strftime('%s', ?);", -1, &statement, NULL);
    
    NSMutableArray *datesArray = [NSMutableArray array];
    
    for (NSInteger i = 0; i < stringsArray.count; i++)
    {
        NSString *dateString = stringsArray[i];
        
        sqlite3_bind_text(statement, 1, [dateString UTF8String], -1, SQLITE_STATIC);
        sqlite3_step(statement);
        
        kTimeStamp value = sqlite3_column_int64(statement, 0);
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:value];
        
        [datesArray addObject:date];
        
        sqlite3_clear_bindings(statement);
        sqlite3_reset(statement);
    }
    
    sqlite3_close(db);
    
    return datesArray;
}

@end
