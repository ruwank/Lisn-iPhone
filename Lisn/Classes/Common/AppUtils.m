//
//  AppUtils.m
//  PINKCampusRep
//
//  Created by IOT on 3/4/16.
//  Copyright © 2016 IronOneTech. All rights reserved.
//

#import "AppUtils.h"
#import "AppConstant.h"
#import <AFNetworking/AFNetworking.h>

@implementation AppUtils


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
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Basic %@", encodedUsernameAndPassword] forHTTPHeaderField:@"Authorization"];
    return manager;
}
@end
