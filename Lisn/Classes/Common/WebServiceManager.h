//
//  WebServiceManager.h
//  Lisn
//
//  Created by Rasika Kumara on 7/1/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppConstant.h"
#import "AppUtils.h"
#import "WebServiceURLs.h"

typedef void (^CreateUserResponseHandler)(BOOL success, NSString *statusText, ErrorType errorType);

@interface WebServiceManager : NSObject
+(void)createUserAcoount:(NSDictionary*)params withResponseHandler:(CreateUserResponseHandler)block;

@end
