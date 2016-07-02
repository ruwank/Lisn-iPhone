//
//  Credentials.h
//  PINKCampusRep
//
//  Created by Nadun De Silva on 4/19/16.
//  Copyright © 2016 IronOneTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserProfile : NSObject<NSCoding>

//userName,password,userId,gcmRegId,fbId
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *fbId;

@end
