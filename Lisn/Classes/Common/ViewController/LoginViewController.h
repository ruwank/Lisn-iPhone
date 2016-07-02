//
//  LoginViewController.h
//  Lisn
//
//  Created by A M S Sumanasooriya on 7/2/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginViewControllerDelegate;

@interface LoginViewController : UIViewController

@property (nonatomic, assign) id<LoginViewControllerDelegate> delegate;

+ (LoginViewController *)getInstance;

@end

@protocol LoginViewControllerDelegate  <NSObject>

- (void)loginSucceeded;
- (void)loginCancelled;

@end
