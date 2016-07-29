//
//  AppDelegate.h
//  PINKCampusRep
//
//  Created by IOT on 3/4/16.
//  Copyright © 2016 IronOneTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConstant.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

- (BOOL)isNetworkRechable;

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableArray *topRatedBookList, *topDownloadedBookList, *topReleaseBookList ;
@property (strong, nonatomic) NSMutableArray *bookCategories;
@property ServiceProvider serviceProvider;
@property (strong, nonatomic) NSString *lastPlayBookId;
//@property (strong,nonatomic)
//@property (strong, nonatomic) NSMutableArray *newReleaseBookList, *topRatedBookList, *topDownloadedBookList;

@end

