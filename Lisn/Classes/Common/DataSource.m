//
//  DataSource.m
//  One Touch Law
//
//  Created by Ruchira Randana on 6/12/15.
//  Copyright (c) 2015 IronOne Technologies. All rights reserved.
//

#import "DataSource.h"
#import "FileOperator.h"


@interface DataSource(){
    NSMutableArray<AudioBook *> *userAudioBook;
    UserProfile *userProfile;

}
@end

@implementation DataSource

-(id)init{
    
    if(self=[super init]){
        userAudioBook = [[NSMutableArray alloc] init];
    }
    return self;
}

+(instancetype)sharedInstance{
    
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}


//GET METHODS

-(NSMutableArray *)getUserBook{
    
    if(!userAudioBook ){
            userAudioBook=[NSKeyedUnarchiver unarchiveObjectWithFile:[FileOperator bookSavePath]];
    }
    return userAudioBook;
    //return [NSKeyedUnarchiver unarchiveObjectWithFile:[FileOperator credentialsPath]];
}



//SAVE METHODS

-(void)saveUserBook:(NSMutableArray *)theBook{
    
    userAudioBook=theBook;

    if ([NSKeyedArchiver archiveRootObject:userAudioBook toFile:[FileOperator bookSavePath]])
    {
        NSLog(@"SAVED!");
    }
    else{
        NSLog(@"Something went wrong...");
    }
    
}

//Image cache realted methods



-(UserProfile*)getProfileInfo{
    if(!userProfile){
    userProfile=[NSKeyedUnarchiver unarchiveObjectWithFile:[FileOperator profileFilePath]];
    }
    return userProfile;
}

-(void)saveProfileInfo:(UserProfile*)profileInfo{
    
    if ([NSKeyedArchiver archiveRootObject:profileInfo toFile:[FileOperator profileFilePath]])
    {
        NSLog(@"SAVED profile! %@",profileInfo);
    }
    else{
        NSLog(@"Something went wrong...");
    }
    // [NSKeyedArchiver archiveRootObject:credentials toFile:[FileOperator credentialsPath]];
}
@end
