/**
    LoadingIndicator.m
    Copyright (c) 2015 Eranga Prasad. All rights reserved.
 */

#import "LoadingIndicator.h"

@interface LoadingIndicator () {
    UIActivityIndicatorView *indicatorView;
    UIView *backgroundView;
    UILabel *loadingLabel;
}

@end

const CGFloat kCenterViewWidth = 100.f;
const CGFloat kCenterViewHeight = 100.f;
const CGFloat kCenterViewCornerRadious = 10.f;
const CGFloat kLoadingLabelHeight = 12.f;
const CGFloat kLoadingLabelFontSize = 9.f;

@implementation LoadingIndicator

- (id)init {
    NSException *exception = [[NSException alloc] initWithName:@"NotSupportedOperation" reason:@"This method is not supported in IndicatorView class." userInfo:@{ }];
    @throw exception;
}

- (id)initWithDelegate:(id <LoadingIndicatorDelegate>)delegate {
    if ((self = [super init]) != nil) {
        // initialize
        _delegate = delegate;
        _loadingText = @"Loading...";
        [self setShowIndicatorView:NO];
        [self configureIndicatorView];
    }
    
    return self;
}

/**
 *  configure Indicator
 */
- (void)configureIndicatorView {
    CGFloat backgroundViewX = 0;
    CGFloat backgroundViewY = 0;
    /*
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    statusBarHeight += 44; */
    CGRect screenSize = [[UIScreen mainScreen]bounds];
    
    
    // background view
    backgroundView = [[UIView alloc] init];
    [backgroundView setUserInteractionEnabled:YES];
    backgroundView.backgroundColor =  [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    backgroundView.frame = CGRectMake(backgroundViewX, backgroundViewY, screenSize.size.width, screenSize.size.height);
    backgroundView.alpha = 0;
    
    // center view
    UIView *centerView = [[UIView alloc] init];
    CGRect rect = centerView.frame;
    rect.size.width = kCenterViewWidth;
    rect.size.height = kCenterViewHeight;
    centerView.frame = rect;
    
    [centerView setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, [[UIScreen mainScreen] bounds].size.height / 2 )];
    centerView.layer.cornerRadius = kCenterViewCornerRadious;
    centerView.backgroundColor =  [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
    
    [backgroundView insertSubview:centerView aboveSubview:backgroundView];
    
    // loading label
    UILabel *label = [[UILabel alloc] init];
    CGRect labelRect = label.frame;
    labelRect.size.width = kCenterViewWidth - 20;
    labelRect.size.height = kLoadingLabelHeight;
    label.frame = labelRect;
    
    label.backgroundColor = [UIColor clearColor];
    label.center = CGPointMake(CGRectGetMidX(centerView.frame), CGRectGetMaxY(centerView.frame) - kLoadingLabelHeight);
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Helvetica-Bold" size:kLoadingLabelFontSize];
    label.textAlignment = NSTextAlignmentCenter;
    loadingLabel = label;
    
    [backgroundView insertSubview:label aboveSubview:centerView];
    
    // indicator view
    indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicatorView.center = centerView.center;
    [backgroundView insertSubview:indicatorView aboveSubview:centerView];
    
    // gesture
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOvelayView:)];
    [tapGesture setNumberOfTapsRequired:1];
    [backgroundView addGestureRecognizer:tapGesture];
}

-(void)setLoadingText:(NSString *)loadingText {
    _loadingText = loadingText;
}
- (void)tapOvelayView:(UITapGestureRecognizer *)gesture {
    [self notifyDidIndicatorViewTapped];
}

- (void)show {
    [self notifyWillIndicatorViewShow];
    if (self.isShowIndicatorView) {
        return;
    }
    [self setShowIndicatorView:YES];
    [loadingLabel setText:_loadingText];
    [UIView animateWithDuration:.5  animations:^{
        backgroundView.alpha = 1;
        [[[UIApplication sharedApplication] keyWindow] addSubview:backgroundView];
        [indicatorView startAnimating];
        
    } completion:^(BOOL finished) {
        [self notifyDidIndicatorViewShowed];
    }];
    
}

- (void)hide {
    [self notifyWillIndicatorViewClose];
    if (!self.isShowIndicatorView) {
        return;
    }
    
    [UIView animateWithDuration:.5  animations:^{
        backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [indicatorView stopAnimating];
        [backgroundView removeFromSuperview];
        [self setShowIndicatorView:NO];
        [self notifyDidIndicatorViewClosed];
    }];
}

- (void)notifyDidIndicatorViewTapped {
    if ([self.delegate respondsToSelector:@selector(didIndicatorViewTapped)]) {
        [self.delegate didIndicatorViewTapped];
    }
}

- (void)notifyWillIndicatorViewShow {
    if ([self.delegate respondsToSelector:@selector(willIndicatorViewShow)]) {
        [self.delegate willIndicatorViewShow];
    }
}

- (void)notifyDidIndicatorViewShowed {
    if ([self.delegate respondsToSelector:@selector(didIndicatorViewShowed)]) {
        [self.delegate didIndicatorViewShowed];
    }
}

- (void)notifyWillIndicatorViewClose {
    if ([self.delegate respondsToSelector:@selector(willIndicatorViewClose)]) {
        [self.delegate willIndicatorViewClose];
    }
}

- (void)notifyDidIndicatorViewClosed {
    if ([self.delegate respondsToSelector:@selector(didIndicatorViewClosed)]) {
        [self.delegate didIndicatorViewClosed];
    }
}

@end
