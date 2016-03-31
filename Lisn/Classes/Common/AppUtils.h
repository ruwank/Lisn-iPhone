//
//  AppUtils.h
//  PINKCampusRep
//
//  Created by IOT on 3/4/16.
//  Copyright © 2016 IronOneTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface AppUtils : NSObject
+(NSString *)  getCredentialsData;
+(AFHTTPSessionManager*)getAFHTTPSessionManager;
+ (BOOL)isNetworkRechable;
@end
