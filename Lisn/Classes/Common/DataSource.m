//
//  DataSource.m
//  One Touch Law
//
//  Created by Ruchira Randana on 6/12/15.
//  Copyright (c) 2015 IronOne Technologies. All rights reserved.
//

#import "DataSource.h"
#import "FileOperator.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>


@interface DataSource(){
    NSMutableDictionary *userAudioBook;
    UserProfile *userProfile;
    NSMutableDictionary *storeBoookDic;

}
@end

@implementation DataSource

-(id)init{
    
    if(self=[super init]){
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

-(NSMutableDictionary *)getUserBook{
    
    if(!userAudioBook ){
            userAudioBook=[NSKeyedUnarchiver unarchiveObjectWithFile:[FileOperator bookSavePath]];
    }
    return userAudioBook;
    //return [NSKeyedUnarchiver unarchiveObjectWithFile:[FileOperator credentialsPath]];
}
-(void)addBookToUserBookList:(AudioBook*)theBook{
    userAudioBook=[self getUserBook];
    [userAudioBook setValue:theBook forKey:theBook.book_id];
    [self saveUserBook:userAudioBook];
}
-(void)addToStoreBookDic:(NSMutableArray*)bookData andCatId:(NSString*)catId{
    if(!storeBoookDic){
        storeBoookDic = [[NSMutableDictionary alloc] init];

    }
    [storeBoookDic setValue:bookData forKey:catId];
}
-(NSMutableArray*)getStoreBookFarCatergoy:(NSString*)catId{
    if ([storeBoookDic objectForKey:catId]) {
        return [storeBoookDic objectForKey:catId];
    } else {
        return [[NSMutableArray alloc] init];
    }
}



//SAVE METHODS

-(void)saveUserBook:(NSMutableDictionary *)theBook{
    
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

-(BOOL)isUserLogin{
    BOOL returnValue=false;
    UserProfile *profile=[self getProfileInfo];
    if(profile && profile.userId && profile.userId.length>0){
        returnValue=true;
    }
    return returnValue;
}
-(void)logOutUser{
    if ([FBSDKAccessToken currentAccessToken]) {

    [[FBSDKLoginManager new] logOut];
    }

    UserProfile *profile=[[UserProfile alloc] init];
    [self saveProfileInfo:profile];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
    [self saveUserBook:dic];
    
    
}

-(UserProfile*)getProfileInfo{
    if(!userProfile){
    userProfile=[NSKeyedUnarchiver unarchiveObjectWithFile:[FileOperator profileFilePath]];
    }
    return userProfile;
}

-(void)saveProfileInfo:(UserProfile*)profileInfo{
    
    userProfile=profileInfo;
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
