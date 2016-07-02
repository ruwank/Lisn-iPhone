//
//  PurchaseViewController.h
//  Lisn
//
//  Created by Rasika Kumara on 7/2/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConstant.h"
@protocol PurchaseViewControllerDelegate;

@interface PurchaseViewController : UIViewController
-(void)loadUrl:(NSString*)urlAddress;
@property (nonatomic, assign) id<PurchaseViewControllerDelegate> delegate;

@end

@protocol PurchaseViewControllerDelegate  <NSObject>

- (void)purchaseComplete:(PaymentStatus)status;

@end