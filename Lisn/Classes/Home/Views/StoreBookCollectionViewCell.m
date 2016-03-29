//
//  StoreBookCollectionViewCell.m
//  Lisn
//
//  Created by A M S Sumanasooriya on 3/26/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import "StoreBookCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"
#import <ResponsiveLabel.h>

@interface StoreBookCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UIView *previewView;
@property (weak, nonatomic) IBOutlet UIView *alphaView;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet ResponsiveLabel *bookName;
@property (weak, nonatomic) IBOutlet UILabel *bookAuther;
@property (weak, nonatomic) IBOutlet UIView *rankView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


@end

@implementation StoreBookCollectionViewCell

- (IBAction)playButtonTapped:(id)sender {
    if (_delegate) {
        [_delegate storeBookCollectionViewCellPlayButtontapped:self lastState:_playButton.selected];
    }
}

- (IBAction)menuButtonTapped:(id)sender {
    
}

- (void)setPlayButtonStateTo:(BOOL)play
{
    _playButton.selected = play;
}

- (void)showPrivewView:(BOOL)show
{
    _previewView.hidden = !show;
}

- (void)showLoadingLabel:(BOOL)show
{
    _loadingLabel.hidden = !show;
}

- (void)setTime:(NSString *)time
{
    _timeLabel.text = time ? time : @"";
}

- (void)awakeFromNib {
    
    _bgView.layer.cornerRadius = 2.0;
    _bgView.layer.masksToBounds = YES;
    
    _previewView.hidden = YES;
}

- (void)setCellObject:(AudioBook *)cellObject
{
    _cellObject = cellObject;
    
    if(_cellObject.lanCode == LAN_SI){
        _bookName.font = [UIFont fontWithName:@"FMAbhaya" size:10];
        [self.bookName setTruncationToken:@"'''"];


    }else{
        _bookName.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
        [self.bookName setTruncationToken:@"..."];
  
    }
    _bookName.text=_cellObject.title;
    NSString *imageURL=_cellObject.cover_image;
    
    NSMutableURLRequest *imageRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imageURL]
                                                                cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                            timeoutInterval:60];
    [_thumbImageView setImageWithURLRequest:imageRequest
                          placeholderImage:[UIImage imageNamed:@"AppIcon"]
                                   success:nil
                                   failure:nil];
    
    
    
}

@end
