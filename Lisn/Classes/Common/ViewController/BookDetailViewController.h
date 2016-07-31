//
//  BookDetailViewController.h
//  Lisn
//
//  Created by A M S Sumanasooriya on 5/23/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioBook.h"
#import <StoreKit/StoreKit.h>

@interface BookDetailViewController : UIViewController

@property (nonatomic, strong) AudioBook *audioBook;
@property (nonatomic, strong) SKProductsRequest *productsRequest;
@property (nonatomic, strong) SKProduct *product;

@end
