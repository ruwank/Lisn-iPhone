//
//  Credentials.m
//
//  Copyright © 2016 IronOneTech. All rights reserved.
//


#import "UserProfile.h"

@implementation UserProfile

//userName,password,userId,gcmRegId,fbId

-(void)encodeWithCoder:(NSCoder *)encoder{
    
    [encoder encodeObject:self.userName forKey:@"userName"];
    [encoder encodeObject:self.password forKey:@"password"];
    [encoder encodeObject:self.userId forKey:@"userId"];
    [encoder encodeObject:self.fbId forKey:@"fbId"];
}

-(instancetype)initWithCoder:(NSCoder *)decoder{
    self = [super init];
    if(self){
        self.userName    = [decoder decodeObjectForKey:@"userName"];
        self.password      = [decoder decodeObjectForKey:@"password"];
        self.userId      = [decoder decodeObjectForKey:@"userId"];
        self.fbId       = [decoder decodeObjectForKey:@"fbId"];
    }
    return self;
}
@end
