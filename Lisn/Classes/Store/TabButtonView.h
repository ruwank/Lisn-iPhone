//
//  TabButtonView.h
//  Lisn
//
//  Created by A M S Sumanasooriya on 4/3/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TabButtonViewDelegate;

@interface TabButtonView : UIView

- (instancetype)initWithTitle:(NSString *)title;

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL hideSeparator;
@property (nonatomic, assign) float width;
@property (nonatomic, assign) id<TabButtonViewDelegate>delegate;

@end

@protocol TabButtonViewDelegate <NSObject>

@optional
- (void)tabButtonViewTapped:(TabButtonView *)tabButtonView;

@end
