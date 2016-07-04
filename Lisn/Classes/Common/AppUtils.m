//
//  AppUtils.m
//  PINKCampusRep
//
//  Created by IOT on 3/4/16.
//  Copyright © 2016 IronOneTech. All rights reserved.
//

#import "AppUtils.h"
#import "AppConstant.h"
#import "DataSource.h"
#import "Messages.h"

@implementation AppUtils

+ (AppDelegate *)appDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}
+(ServiceProvider)getServiceProvider{
    return [self appDelegate].serviceProvider;
}
+(NSString *)  getCredentialsData {
    NSString* USERNAME=@"app";
    NSString* PASSWORD=@"Kn@sw7*d#b";
    NSString* credentials =[NSString stringWithFormat:@"%@:%@",USERNAME,PASSWORD];
    return credentials;
    
    
}
+(AFHTTPSessionManager*)getAFHTTPSessionManager{
    NSData *plainData = [[self getCredentialsData] dataUsingEncoding:NSUTF8StringEncoding];
    NSString *encodedUsernameAndPassword = [plainData base64EncodedStringWithOptions:0];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    manager.securityPolicy.allowInvalidCertificates = YES; // not recommended for production
    manager.securityPolicy.validatesDomainName=NO;
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Basic %@", encodedUsernameAndPassword] forHTTPHeaderField:@"Authorization"];
    
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    return manager;
}
+ (BOOL)isNetworkRechable {
    
    if ([AFNetworkReachabilityManager sharedManager].reachable) {
        
        if ([AFNetworkReachabilityManager sharedManager].isReachableViaWiFi)
            NSLog(@"Network reachable via WWAN");
        else
            NSLog(@"Network reachable via Wifi");
        
        return YES;
    }
    else {
        
        NSLog(@"Network is not reachable");
        return NO;
    }
}

+ (BOOL)isValidString:(NSString *)str
{
    if (str != nil
        && ![str isKindOfClass:[NSNull class]]
        && [str isKindOfClass:[NSString class]]
        && str.length > 0) {
        return YES;
    }
    
    return NO;
}

+ (NSString *)trimmedStringOfString:(NSString *)string
{
    if ([AppUtils isValidString:string]) {
        return [string stringByTrimmingCharactersInSet:
                [NSCharacterSet whitespaceCharacterSet]];
    }
    
    return @"";
}

+ (BOOL) isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

+(UIActionSheet*)getActionSheetForAudioBook:(AudioBook*)audioBook{
    UIActionSheet *actionSheet;
    //login status also
    if(audioBook.isPurchase){
        actionSheet= [[UIActionSheet alloc] initWithTitle:@""
                                                 delegate:nil
                                        cancelButtonTitle:@"Cancel"
                                   destructiveButtonTitle:nil
                                        otherButtonTitles:@"Red", @"Green", @"Blue", @"Orange", @"Purple", nil];
    }else{
        actionSheet= [[UIActionSheet alloc] initWithTitle:@""
                                                 delegate:nil
                                        cancelButtonTitle:@"Cancel"
                                   destructiveButtonTitle:nil
                                        otherButtonTitles:@"Red", @"Green", @"Blue", @"Orange", @"Purple", nil];
    }
    
    
    return actionSheet;
    
}
+(NSString*)getDeviceId{
    UIDevice *device = [UIDevice currentDevice];
    
    NSString  *currentDeviceId = [[device identifierForVendor]UUIDString];
    return currentDeviceId;
}
+(BOOL)isBookPurchase:(NSString*)bookId{
    BOOL returnValue=NO;
    if([[DataSource sharedInstance] isUserLogin]){
    NSDictionary *userBook=[[DataSource sharedInstance] getUserBook];
    if(userBook){
        AudioBook *book=[userBook objectForKey:bookId];
        if(book){
            returnValue=YES;
        }

    }
    }
    return returnValue;
}
+(BOOL)isBookChapterPurchase:(NSString*)bookId andChapter:(int)index{
    BOOL returnValue=[self isBookPurchase:bookId];
    if (returnValue) {
        NSDictionary *userBook=[[DataSource sharedInstance] getUserBook];
        AudioBook *book=[userBook objectForKey:bookId];
        if(book.isTotalBookPurchased){
            returnValue=YES;
        }else{
        for (BookChapter *chapter in book.chapters) {
            if(chapter.chapter_id == index){
                returnValue=chapter.isPurchased;
                break;
            }
        }
        }

    }
    return returnValue;
}
+(void)showContentIsNotReadyAlert{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"This section is not available yet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
+(void)showCommonErrorAlert{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ALERT_TITLE_COMMON message:ALERT_MSG_COMMON delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];

}
@end
