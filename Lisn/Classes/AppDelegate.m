//
//  AppDelegate.m
//  PINKCampusRep
//
//  Created by IOT on 3/4/16.
//  Copyright © 2016 IronOneTech. All rights reserved.
//

#import "AppDelegate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <AFNetworking/AFNetworking.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "FileOperator.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];

    [FileOperator checkAndCreateRootDirectory];

    
    [Fabric with:@[[Crashlytics class]]];

    // Override point for customization after application launch.
    
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    MainViewController *mainViewController = [[MainViewController alloc] init];
//    UINavigationController *mainNav = [[UINavigationController alloc] initWithRootViewController:mainViewController];
//    mainNav.navigationBar.hidden = YES;
//    self.window.rootViewController = mainNav;
//    [self.window makeKeyAndVisible];
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.backgroundColor = [UIColor whiteColor];
    
   // [self setServiceProvider];
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation
            ];
}
#pragma mark 
-(void)setServiceProvider{
    CTTelephonyNetworkInfo *netinfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [netinfo subscriberCellularProvider];
    NSString *mobileNetworkCode=[carrier mobileNetworkCode];
    NSLog(@"Carrier Name: %@", [carrier mobileNetworkCode]);
    if(mobileNetworkCode){
        if([mobileNetworkCode isEqualToString:@"01"]){
            _serviceProvider=PROVIDER_MOBITEL;
        }
        else if([mobileNetworkCode isEqualToString:@"02"]){
            _serviceProvider=PROVIDER_DIALOG;
        }
        else if([mobileNetworkCode isEqualToString:@"03"]){
            _serviceProvider=PROVIDER_ETISALAT;
        }

    }
}
@end
