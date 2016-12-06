//
//  PhoneUtil.m
//  Community
//
//  Created by BST on 13-6-8.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "UtilPhone.h"

#define REG_EXP_MOBILE          @"^0?1([3,5,8]{1}[0-9]{1})[0-9]{8}$"
#define REG_EXP_TEL             @"^([0-9][1-9][0-9]{1,2}-)?[0-9]{7,8}$"
#define REG_EXP_CELLPHONE       @"^(((\\+86)|(86))?(\\s)*((13[0-9])|(15[^4,\\D])|(18[0,5-9])))\\d{8}$"

@implementation UtilPhone

+ (NSString *)getDevicePhoneNumber
{
    NSString *phoneNum = [[NSUserDefaults standardUserDefaults] stringForKey:@"SBFormattedPhoneNumber"];

    return phoneNum;
}

+ (void)sendCall:(NSString *)phoneNumber
{
    if( [UtilPhone checkMobileNumber:phoneNumber] == FALSE &&
        [UtilPhone checkTelNumber:phoneNumber] == FALSE )
        return;
    
    NSString *callURL = [@"telprompt://" stringByAppendingString:phoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callURL]];
}

+ (void)sendCallWithOutGoBack:(NSString *)phoneNumber
{
    if( [UtilPhone checkMobileNumber:phoneNumber] == FALSE &&
        [UtilPhone checkTelNumber:phoneNumber] == FALSE )
        return;
    
    NSString *callURL = [@"tel://" stringByAppendingString:phoneNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callURL]];
}

+ (BOOL)checkMobileNumber:(NSString *)mobileNumber
{
    NSError *error = NULL;

    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:REG_EXP_MOBILE options:NSRegularExpressionCaseInsensitive error:&error];
    
    __block BOOL bOK = FALSE;
    [regex enumerateMatchesInString:mobileNumber
                            options:NSMatchingReportCompletion
                              range:NSMakeRange(0, [mobileNumber length])
                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop ) {
                             NSRange range = [result rangeAtIndex:0];
                             
                             if( range.location == 0 && range.length == [mobileNumber length] )
                                 bOK = TRUE;
                         }];
    
    return bOK;
}

+ (BOOL)checkTelNumber:(NSString *)telNumber
{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:REG_EXP_TEL options:NSRegularExpressionCaseInsensitive error:&error];
    
    __block BOOL bOK = FALSE;
    [regex enumerateMatchesInString:telNumber
                            options:NSMatchingReportCompletion
                              range:NSMakeRange(0, [telNumber length])
                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop ) {
                             NSRange range = [result rangeAtIndex:0];
                             
                             if( range.location == 0 && range.length == [telNumber length] )
                                 bOK = TRUE;
                         }];
    
    return bOK;
}

+ (BOOL)checkCellPhone:(NSString *)cellNumber
{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:REG_EXP_CELLPHONE options:NSRegularExpressionCaseInsensitive error:&error];
    
    __block BOOL bOK = FALSE;
    [regex enumerateMatchesInString:cellNumber
                            options:NSMatchingReportCompletion
                              range:NSMakeRange(0, [cellNumber length])
                         usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop ) {
                             NSRange range = [result rangeAtIndex:0];
                             
                             if( range.location == 0 && range.length == [cellNumber length] )
                                 bOK = TRUE;
                         }];
    
    return bOK;
}

@end
