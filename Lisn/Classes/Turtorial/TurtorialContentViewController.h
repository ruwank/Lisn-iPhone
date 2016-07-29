//
//  TurtorialContentViewController.h
//  Lisn
//
//  Created by Rasika Kumara on 7/29/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TurtorialContentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property NSUInteger pageIndex;
@property NSString *imageFile;
@end
