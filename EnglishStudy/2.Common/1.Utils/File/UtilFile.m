//
//  UtilFile.m
//  Community
//
//  Created by BST on 13-6-5.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "UtilFile.h"


@implementation UtilFile

+ (BOOL)isFileExits:(NSString*)filePath
{
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    
    return fileExists;
}

+ (NSString*)getFullPathOfResourceFile:(NSString*)fileTitle ofType:(NSString*)type
{
    return [[NSBundle mainBundle] pathForResource:fileTitle ofType:type];
}

+ (NSString*)getDirectoryPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (NSString*)getFullPathOfFile:(NSString*)fileName
{
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    return [NSString stringWithFormat:@"%@/%@", documentsDirectoryPath, fileName];
}

+ (NSString*)getFullPathOfFile:(NSString*)fileName ofType:(NSString*)type
{
    NSString * documentsDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    return [NSString stringWithFormat:@"%@/%@.%@", documentsDirectoryPath, fileName, type];
}

+ (NSString*)extractFileTitle:(NSString*)filePath
{
    NSRange     range = [filePath rangeOfString:@"/" options:NSBackwardsSearch];
    NSString*   fileName;
    if( range.length == 0 )
        fileName = filePath;
    else
        fileName = [filePath substringFromIndex:range.location+1];
    
    range = [fileName rangeOfString:@"." options:NSBackwardsSearch];
    if( range.length == 0 )
        return fileName;
    
    return [fileName substringToIndex:range.location];
}

+ (NSString*)extractFileName:(NSString*)filePath
{
    NSRange     range = [filePath rangeOfString:@"/" options:NSBackwardsSearch];
    if( range.length == 0 )
        return @"";

    return [filePath substringFromIndex:range.location+1];
}

+ (NSString*)extractFileExtension:(NSString*)filePath
{
    NSRange     range = [filePath rangeOfString:@"." options:NSBackwardsSearch];
    if( range.length == 0 )
        return @"";
    
    return [filePath substringFromIndex:range.location+1];
}

@end