//
//  AppUtils.h
//  PINKCampusRep
//
//  Created by IOT on 3/4/16.
//  Copyright © 2016 IronOneTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "AppDelegate.h"
#import "AudioBook.h"

@interface AppUtils : NSObject
+ (AppDelegate *)appDelegate;
+(NSString *)  getCredentialsData;
+(AFHTTPSessionManager*)getAFHTTPSessionManager;
+ (BOOL)isNetworkRechable;
+ (BOOL)isValidString:(NSString *)str;
+ (NSString *)trimmedStringOfString:(NSString *)string;
+ (UIActionSheet*)getActionSheetForAudioBook:(AudioBook*)audioBook;
+ (BOOL) isValidEmail:(NSString *)checkString;
+(NSString*)getDeviceId;
+(ServiceProvider)getServiceProvider;
+(BOOL)isBookPurchase:(NSString*)bookId;
+(BOOL)isBookChapterPurchase:(NSString*)bookId andChapter:(int)index;
+(void)showContentIsNotReadyAlert;
+(void)showCommonErrorAlert;

+ (NSData *)getDecryptedDataOf:(NSData *)audioData;

@end
