//
//  TabButtonView.m
//  Lisn
//
//  Created by A M S Sumanasooriya on 4/3/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import "TabButtonView.h"
#import "AppConstant.h"

@interface TabButtonView()

@property (nonatomic, strong) UIView *selectView;
@property (nonatomic, strong) UIView *separateView;

@end

@implementation TabButtonView

- (instancetype)initWithTitle:(NSString *)title
{
    self = [super initWithFrame:CGRectMake(0, 0, 0, 44)];
    if (self) {
        
        title = [title uppercaseString];
        
        NSDictionary *ats = @{NSForegroundColorAttributeName : RGBA(255, 255, 255, 1),
                              NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:12.0f]
                              };
        CGRect textRect = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 44) options:NSStringDrawingUsesLineFragmentOrigin attributes:ats context:nil];
        
        NSAttributedString *attribTitle = [[NSAttributedString alloc] initWithString:title attributes:ats];
        
        float textW = textRect.size.width;
        float viewW = textW + 16 + 1;
        _width = viewW;
        
        _selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 42, viewW-1, 2)];
        _selectView.backgroundColor = RGBA(238, 159, 31, 1);
        [self addSubview:_selectView];
        
        _separateView = [[UIView alloc] initWithFrame:CGRectMake(viewW-1, 14, 1, 16)];
        _separateView.backgroundColor = RGBA(255, 255, 255, 255);
        [self addSubview:_separateView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        button.frame = CGRectMake(0, 0, viewW, 44);
        [button setAttributedTitle:attribTitle forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    
    return self;
}

- (void)buttonTapped
{
    if (_selected) {
        _selectView.backgroundColor = RGBA(238, 159, 31, 1);
    }else {
        _selectView.backgroundColor = RGBA(255, 255, 255, 1);
    }
    
    _selected = !_selected;
    
    if (_delegate) {
        [_delegate tabButtonViewTapped:self];
    }
}

- (void)setHideSeparator:(BOOL)hideSeparator
{
    _hideSeparator = hideSeparator;
    _separateView.hidden = hideSeparator;
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    if (_selected) {
        _selectView.backgroundColor = RGBA(255, 255, 255, 1);
    }else {
        _selectView.backgroundColor = RGBA(238, 159, 31, 1);
    }
}

@end
