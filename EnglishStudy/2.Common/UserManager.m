//
//  UserManager.m
//  EnglishStudy
//
//  Created by admin on 2/7/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import "UserManager.h"
#import "UtilImage.h"
#import "UtilFile.h"
#import "Global.h"

@implementation UserManager

+ (BOOL)createUserTable
{
    //const char *sql_stmt = "create table if not exists alarmlog_table (id integer primary key AUTOINCREMENT, timestamp text not null,humidity text not null,temperature text not null,mode text not null,callingnumber text not null,sentstatus text not null,remark text not null,timeinlong text not null);";
    
    // username : 유저이름
    // email : 이메일
    // password : 비밀번호
    // repeat1 : 학습 1단계 반복회수
    // repeat2 : 학습 2단계 반복회수
    // wordcolor : 단어색상
    // meancolor : 의미색상
    // testtime : 시험시간
    // testmode : 시험방법
    // studyspeed : 학습속도
    // level : 학습급수
    // star_rate : 별
    // daywords : 하루 학습할 단어량
    // studywords : 총 학습한 단어수

    NSString *strQuery = @"create table if not exists user_tbl (id integer primary key AUTOINCREMENT, username text not null, email text not null, password text not null, repeat1 integer, repeat2 integer, wordcolor integer, meancolor integer, testtime integer, testmode integer, studyspeed integer, level integer, star_rate integer, daywords integer, studywords integer, studywordbookid integer, startdate integer);";

    return [[Global sharedGlobal].dbManager excuteSQL:strQuery];
}

+ (BOOL)findUserEmail:(NSString *)email
{
    NSString     *strQuery = [NSString stringWithFormat:@"select * from user_tbl where email='%@'", email];
    NSDictionary *dicUser = [[Global sharedGlobal].dbManager queryOneData:strQuery];

    if( dicUser == nil )
        return NO;

    return YES;
}

+ (int)loginUserEmail:(NSString *)email password:(NSString *)password
{
    NSString     *strQuery = [NSString stringWithFormat:@"select * from user_tbl where email='%@'", email];
    NSDictionary *dicUser = [[Global sharedGlobal].dbManager queryOneData:strQuery];
    if( dicUser == nil )
        return -1;

    NSString    *strPassword = [dicUser objectForKey:@"password"];
    if( ![password isEqualToString:strPassword] )
        return -2;

    int nUserID = [[dicUser objectForKey:@"id"] intValue];

    return nUserID;
}

+ (BOOL)registerUser:(NSString *)username email:(NSString *)email password:(NSString *)password photo:(UIImage *)imgPhoto
{
    NSMutableDictionary *dicUser = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [dicUser setObject:username forKey:@"username"];
    [dicUser setObject:email forKey:@"email"];
    [dicUser setObject:password forKey:@"password"];
    [dicUser setObject:[NSNumber numberWithInt:1] forKey:@"repeat1"];
    [dicUser setObject:[NSNumber numberWithInt:1] forKey:@"repeat2"];
    [dicUser setObject:[NSNumber numberWithInt:1] forKey:@"wordcolor"];
    [dicUser setObject:[NSNumber numberWithInt:1] forKey:@"meancolor"];
    [dicUser setObject:[NSNumber numberWithInt:1] forKey:@"testtime"];
    [dicUser setObject:[NSNumber numberWithInt:TEST_METHOD_OPTION_ALL] forKey:@"testmode"];
    [dicUser setObject:[NSNumber numberWithInt:2] forKey:@"studyspeed"];
    
    [dicUser setObject:[NSNumber numberWithInt:0] forKey:@"level"];
    [dicUser setObject:[NSNumber numberWithDouble:0] forKey:@"startdate"];

    [dicUser setObject:[NSNumber numberWithInt:0] forKey:@"star_rate"];
    [dicUser setObject:[NSNumber numberWithInt:20] forKey:@"daywords"];
    [dicUser setObject:[NSNumber numberWithInt:0] forKey:@"studywords"];
    [dicUser setObject:[NSNumber numberWithInt:0] forKey:@"studywordbookid"];

    [[Global sharedGlobal].dbManager insertRecordInTable:@"user_tbl" dic:dicUser];
    
    NSString     *strQuery = [NSString stringWithFormat:@"select * from user_tbl where email='%@'", email];

    dicUser = [[Global sharedGlobal].dbManager queryOneData:strQuery];
    if( dicUser == nil )
        return NO;
    
    if( imgPhoto != nil )
    {
        int         nUserID = [[dicUser objectForKey:@"id"] intValue];

        NSString    *fileTitle = [NSString stringWithFormat:@"userphoto_%d", nUserID];
        NSString    *folderPath = [UtilFile getDirectoryPath];
    
        [UtilImage saveImage:imgPhoto withFileName:fileTitle ofType:@"jpg" inDirectory:folderPath];
    }

    return YES;
}

+ (NSDictionary *)getUserInfo
{
    NSString *strQuery = [NSString stringWithFormat:@"select * from user_tbl where id=%d", [Global sharedGlobal].nUserID];
    
    return [[Global sharedGlobal].dbManager queryOneData:strQuery];
}

+ (UIImage *)getUserPhoto
{
    NSString    *fileTitle = [NSString stringWithFormat:@"userphoto_%d", [Global sharedGlobal].nUserID];
    NSString    *folderPath = [UtilFile getDirectoryPath];

    UIImage *image = [UtilImage loadImage:fileTitle ofType:@"jpg" inDirectory:folderPath];

    return image;
}

+ (void)updateUserPhoto:(UIImage *)imgPhoto
{
    NSString    *fileTitle = [NSString stringWithFormat:@"userphoto_%d", [Global sharedGlobal].nUserID];
    NSString    *folderPath = [UtilFile getDirectoryPath];

    [UtilImage saveImage:imgPhoto withFileName:fileTitle ofType:@"jpg" inDirectory:folderPath];
}

+ (void)updateUserInfo:(NSDictionary *)dicUserInfo
{
    NSDictionary    *dicWhere = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:[Global sharedGlobal].nUserID], @"id", nil];

    [[Global sharedGlobal].dbManager updateRecordInTable:@"user_tbl" dicSET:dicUserInfo dicWHERE:dicWhere];
}

+ (void)updateUserName:(NSString *)username
{
    NSDictionary    *dicUpdate = [NSDictionary dictionaryWithObjectsAndKeys:username, @"username", nil];

    [UserManager updateUserInfo:dicUpdate];
}

//=================================================================================================================================//

+ (NSString *)getUserWordBookTblName
{
    return [NSString stringWithFormat:@"user_wordbook_tbl_%d", [Global sharedGlobal].nUserID];
}

+ (BOOL)createUserWordBookTable
{
    NSString *strQuery = @"create table if not exists";
    
    strQuery = [strQuery stringByAppendingString:[UserManager getUserWordBookTblName]];
    strQuery = [strQuery stringByAppendingString:@" (id integer primary key AUTOINCREMENT, wid integer, wkind integer);"];
    
    return [[Global sharedGlobal].dbManager excuteSQL:strQuery];
}

//=================================================================================================================================//

+ (NSString *)getUserScheduleTblName
{
    return [NSString stringWithFormat:@"user_shedule_tbl_%d", [Global sharedGlobal].nUserID];
}

+ (BOOL)createUserScheduleTable
{
    NSString *strQuery = @"create table if not exists ";

    strQuery = [strQuery stringByAppendingString:[UserManager getUserScheduleTblName]];
    strQuery = [strQuery stringByAppendingString:@" (id integer primary key AUTOINCREMENT, level integer, date integer, swid integer, count integer, score integer);"];

    return [[Global sharedGlobal].dbManager excuteSQL:strQuery];
}

+ (NSArray *)getScheduleInfo
{
    NSString *strQuery = [NSString stringWithFormat:@"select * from %@", [UserManager getUserScheduleTblName]];

    return [[Global sharedGlobal].dbManager queryArrayData:strQuery];
}

+ (NSDictionary *)getScheduleDayInfo:(int)nDayID
{
    NSString *strQuery = [NSString stringWithFormat:@"select * from %@ where id=%d", [UserManager getUserScheduleTblName], nDayID];

    return [[Global sharedGlobal].dbManager queryOneData:strQuery];
}

+ (void)addScheduleWordIdx:(int)nStartWordID count:(int)nCount score:(int)nScore
{
    NSMutableDictionary *dicSchedule = [NSMutableDictionary dictionaryWithCapacity:0];
    
    int     nDate = (int)[[NSDate date] timeIntervalSince1970];

    [dicSchedule setObject:[NSNumber numberWithInt:[Global sharedGlobal].nLevel] forKey:@"level"];
    [dicSchedule setObject:[NSNumber numberWithInt:nDate] forKey:@"date"];

    [dicSchedule setObject:[NSNumber numberWithInt:nStartWordID] forKey:@"swid"];
    [dicSchedule setObject:[NSNumber numberWithInt:nCount] forKey:@"count"];
    [dicSchedule setObject:[NSNumber numberWithInt:nScore] forKey:@"score"];

    [[Global sharedGlobal].dbManager insertRecordInTable:[UserManager getUserScheduleTblName] dic:dicSchedule];
}

+ (void)updateScheduleDate:(int)nDayID score:(int)nScore
{
    NSDictionary    *dicUpdate = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:nScore], @"score", nil];
    NSDictionary    *dicWhere = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:nDayID], @"id", nil];

    [[Global sharedGlobal].dbManager updateRecordInTable:[UserManager getUserScheduleTblName] dicSET:dicUpdate dicWHERE:dicWhere];
}

@end
