//
//  DataSource.h
//  One Touch Law
//
//  Created by Ruchira Randana on 6/12/15.
//  Copyright (c) 2015 IronOne Technologies. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AudioBook.h"
#import "UserProfile.h"

@interface DataSource : NSObject

+(instancetype)sharedInstance;
-(NSMutableDictionary *)getUserBook;
-(void)saveUserBook:(NSMutableDictionary *)theBook;
-(UserProfile*)getProfileInfo;
-(void)saveProfileInfo:(UserProfile*)profileInfo;
-(BOOL)isUserLogin;
-(void)addBookToUserBookList:(AudioBook*)theBook;
-(void)logOutUser;

-(void)addToStoreBookDic:(NSMutableArray*)bookData andCatId:(NSString*)catId;
-(NSMutableArray*)getStoreBookFarCatergoy:(NSString*)catId;
@end