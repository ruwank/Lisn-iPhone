/**
    LoadingIndicator.h
    Copyright (c) 2015 Eranga Prasad. All rights reserved.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  LoadingIndicatorDelegate methods
 */
@protocol LoadingIndicatorDelegate <NSObject>

- (void)willIndicatorViewShow;

- (void)didIndicatorViewShowed;

- (void)willIndicatorViewClose;

- (void)didIndicatorViewClosed;

- (void)didIndicatorViewTapped;

@end

@interface LoadingIndicator : NSObject <UIGestureRecognizerDelegate>

/**
 *  initialize
 *
 *  @param container containerView
 *  @param delegate  delegate
 *
 *  @return LoadingIndicatorView
 */
- (id)initWithDelegate:(id <LoadingIndicatorDelegate>)delegate;

/**
 *  show Indicator View
 */
- (void)show;

/**
 *  hide Indicator View
 */
- (void)hide;

@property (nonatomic, getter = isShowIndicatorView) BOOL showIndicatorView;
@property (nonatomic, assign) id <LoadingIndicatorDelegate> delegate;
@property (nonatomic, retain) NSString *loadingText;

@end
