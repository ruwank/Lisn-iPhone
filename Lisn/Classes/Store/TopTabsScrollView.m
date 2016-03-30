//
//  TopTabsScrollView.m
//  Lisn
//
//  Created by A M S Sumanasooriya on 3/30/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import "TopTabsScrollView.h"

@implementation TopTabsScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    if ( [view isKindOfClass:[UIButton class]] ) {
        return YES;
    }
    
    return [super touchesShouldCancelInContentView:view];
}

@end
