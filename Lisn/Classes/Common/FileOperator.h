//
//  FileOperator.h
//  One Touch Law
//
//  Created by Ruchira on 6/13/15.
//  Copyright (c) 2015 IronOne Technologies. All rights reserved.
//


#define PATH_LOG_FILE               @"logger.txt"
#define PATH_BOOK                   @"book.plist"
#define PATH_PROFILE                @"profile.plist"

#import <Foundation/Foundation.h>

@interface FileOperator : NSObject

+(NSString *) getRootDirectory;
+(NSString *) getRootSavePath;
+(void) checkAndCreateRootDirectory;
+(NSString *)getImageSavePath;
+(void)checkAndCreateImageSavePath;

+(NSString *) pathForType:(NSString *)type;
+(NSString *)profileFilePath;
+(NSString *) bookSavePath;

+(BOOL) fileExists:(NSString *)type;
+(void)deleteFileType:(NSString *)type;

@end