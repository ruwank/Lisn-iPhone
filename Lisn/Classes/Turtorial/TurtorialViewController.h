//
//  TurtorialViewController.h
//  Lisn
//
//  Created by Rasika Kumara on 7/29/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TurtorialViewController : UIViewController<UIPageViewControllerDataSource>
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageImages;


@end
