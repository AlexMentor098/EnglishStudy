//
//  UserManager.h
//  EnglishStudy
//
//  Created by admin on 2/7/16.
//  Copyright (c) 2016 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserManager : NSObject

//================== 유저정보 ========================//

+ (BOOL)createUserTable;

+ (BOOL)findUserEmail:(NSString *)email;

+ (BOOL)registerUser:(NSString *)username email:(NSString *)email password:(NSString *)password photo:(UIImage *)imgPhoto;

+ (int)loginUserEmail:(NSString *)email password:(NSString *)password;

+ (NSDictionary *)getUserInfo;

+ (UIImage *)getUserPhoto;

+ (void)updateUserPhoto:(UIImage *)imgPhoto;

+ (void)updateUserInfo:(NSDictionary *)dicUserInfo;

+ (void)updateUserName:(NSString *)username;

//==================== 유저단어장 ========================//

+ (NSString *)getUserWordBookTblName;

+ (BOOL)createUserWordBookTable;

//====================== 일정정보 =======================//

+ (NSString *)getUserScheduleTblName;

+ (BOOL)createUserScheduleTable;

+ (NSArray *)getScheduleInfo;

+ (NSDictionary *)getScheduleDayInfo:(int)nDayID;

+ (void)addScheduleWordIdx:(int)nStartWordID count:(int)nCount score:(int)nScore;

+ (void)updateScheduleDate:(int)nDayID score:(int)nScore;

@end
