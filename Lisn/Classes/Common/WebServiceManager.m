//
//  WebServiceManager.m
//  Lisn
//
//  Created by Rasika Kumara on 7/1/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import "WebServiceManager.h"
#import "UserProfile.h"
#import "DataSource.h"

@implementation WebServiceManager

+(void)createUserAcoount:(NSDictionary*)params withResponseHandler:(CreateUserResponseHandler)block{
    AFHTTPSessionManager *manager = [AppUtils getAFHTTPSessionManager];
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    responseSerializer.acceptableContentTypes = nil;
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
       NSLog(@"params %@",params);
    [manager POST:user_add_url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //TODO
        NSString* responseString = [NSString stringWithUTF8String:[responseObject bytes]];
        // EXIST: UID=5:USERNAME=Rasika Ruwan Kumara:STATUS=pending:TYPE=fb:FBID=10206798599830095
        
        NSArray* createResponse = [responseString componentsSeparatedByString: @":"];
        NSString *status=[createResponse objectAtIndex:0];
        if(status && ([status isEqualToString:@"SUCCESS"] || [status isEqualToString:@"EXIST"])){
            
            NSString *uid = @"";
            NSString *fbId = @"";
            NSString *userName = @"";
            NSString *type = @"";
            NSString *statusString = @"";
            for (int i=1; i<[createResponse count]; i++) {
                NSString *separate1=[createResponse objectAtIndex:i];
                NSArray* separate2 = [separate1 componentsSeparatedByString: @"="];
                NSString *key=[separate2 objectAtIndex:0];
               key= [key stringByTrimmingCharactersInSet:
                 [NSCharacterSet whitespaceCharacterSet]];
                NSLog(@"separate3 %@",key);
                if(key && [key isEqualToString:@"UID"]){
                    uid=[separate2 objectAtIndex:1];
                }
                if(key && [key isEqualToString:@"USERNAME"]){
                    userName=[separate2 objectAtIndex:1];
                }
                if(key && [key isEqualToString:@"FBID"]){
                    fbId=[separate2 objectAtIndex:1];
                }
                if(key && [key isEqualToString:@"TYPE"]){
                    type=[separate2 objectAtIndex:1];
                }
                if(key && [key isEqualToString:@"STATUS"]){
                    statusString=[separate2 objectAtIndex:1];
                }

            }
            if([type isEqualToString:@"fb"]){
                UserProfile *userProfile=[[UserProfile alloc] init];
                userProfile.fbId=fbId;
                userProfile.userName=userName;
                userProfile.userId=uid;
                [[DataSource sharedInstance] saveProfileInfo:userProfile];
            }
            block(YES,statusString,ErrorTypeNone);
            
        }else{
            if (block) {
                block(NO,@"",ErrorTypeInternalError);
            }
        }

        
        NSLog(@"responseObject %@",responseObject);
        NSLog(@"responseObject class %@",responseString);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error %@",error);
        if (block) {
            block(NO,@"",ErrorTypeInternalError);
        }

        
    }];
    
}

+(void)loginUser:(NSDictionary*)params withResponseHandeler:(LoginUserResponseHandler)block{
    AFHTTPSessionManager *manager = [AppUtils getAFHTTPSessionManager];
    
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    responseSerializer.acceptableContentTypes = nil;
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSLog(@"params %@",params);
    [manager POST:user_login_url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //TODO
        NSString* responseString = [NSString stringWithUTF8String:[responseObject bytes]];
        // EXIST: UID=5:USERNAME=Rasika Ruwan Kumara:STATUS=pending:TYPE=fb:FBID=10206798599830095
        
        NSArray* createResponse = [responseString componentsSeparatedByString: @":"];
        NSString *status=[createResponse objectAtIndex:0];
        if(status && [status isEqualToString:@"SUCCESS"]){
            
            NSString *uid = @"";
            NSString *fbId = @"";
            NSString *userName = @"";
            NSString *type = @"";
            NSString *statusString = @"";
            for (int i=1; i<[createResponse count]; i++) {
                NSString *separate1=[createResponse objectAtIndex:i];
                NSArray* separate2 = [separate1 componentsSeparatedByString: @"="];
                NSString *key=[separate2 objectAtIndex:0];
                key= [key stringByTrimmingCharactersInSet:
                      [NSCharacterSet whitespaceCharacterSet]];
                NSLog(@"separate3 %@",key);
                if(key && [key isEqualToString:@"UID"]){
                    uid=[separate2 objectAtIndex:1];
                }
                if(key && [key isEqualToString:@"USERNAME"]){
                    userName=[separate2 objectAtIndex:1];
                }
                if(key && [key isEqualToString:@"FBID"]){
                    fbId=[separate2 objectAtIndex:1];
                }
                if(key && [key isEqualToString:@"TYPE"]){
                    type=[separate2 objectAtIndex:1];
                }
                if(key && [key isEqualToString:@"STATUS"]){
                    statusString=[separate2 objectAtIndex:1];
                }
                
            }
                UserProfile *userProfile=[[UserProfile alloc] init];
                userProfile.fbId=fbId;
                userProfile.userName=userName;
                userProfile.userId=uid;
                [[DataSource sharedInstance] saveProfileInfo:userProfile];
            
            block(YES,ErrorTypeNone);
            
        }else{
            if (block) {
                block(NO,ErrorTypeInternalError);
            }
        }
        
        
        NSLog(@"responseObject %@",responseObject);
        NSLog(@"responseObject class %@",responseString);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error %@",error);
        if (block) {
            block(NO,ErrorTypeInternalError);
        }
        
        
    }];

}
@end
