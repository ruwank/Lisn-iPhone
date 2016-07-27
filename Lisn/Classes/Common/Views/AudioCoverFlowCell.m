//
//  AudioCoverFlowCell.m
//  Lisn
//
//  Created by A M S Sumanasooriya on 7/27/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import "AudioCoverFlowCell.h"
#import "UIImageView+AFNetworking.h"

@interface AudioCoverFlowCell()

@property (nonatomic, strong) UILabel *chapterLbl;
@property (nonatomic, strong) UIImageView *thumbImageView;

@end

@implementation AudioCoverFlowCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.image = [UIImage imageNamed:@"img_temp_thumb"];
        [self addSubview:imgView];
        _thumbImageView = imgView;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 21)];
        label.backgroundColor = [UIColor lightGrayColor];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        _chapterLbl = label;
    }
    
    return self;
}

- (void)setThumbUrl:(NSString *)thumbUrl
{
    _thumbUrl = thumbUrl;
    
    NSMutableURLRequest *imageRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:thumbUrl]
                                                                cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                            timeoutInterval:60];
    [_thumbImageView setImageWithURLRequest:imageRequest
                           placeholderImage:[UIImage imageNamed:@"img_temp_thumb"]
                                    success:nil
                                    failure:nil];
}

- (void)setChapterId:(int)chapterId
{
    _chapterId = chapterId;
    _chapterLbl.text = [NSString stringWithFormat:@"Chapter %d", chapterId];
}

@end
