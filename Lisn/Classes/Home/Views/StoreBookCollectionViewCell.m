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
#import "AppUtils.h"
#import "Messages.h"
#import "DataSource.h"

@interface StoreBookCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UIView *previewView;
@property (weak, nonatomic) IBOutlet UIView *alphaView;
@property (weak, nonatomic) IBOutlet UILabel *loadingLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet ResponsiveLabel *bookName;
@property (weak, nonatomic) IBOutlet ResponsiveLabel *bookAuther;
@property (weak, nonatomic) IBOutlet UIView *rankView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *imgAwardIcon;
@property (weak, nonatomic) IBOutlet UIImageView *imgDownloadedIcon;

@end

@implementation StoreBookCollectionViewCell


- (IBAction)playButtonTapped:(id)sender {
    if([AppUtils isNetworkRechable]){
    if (_delegate) {
        [_delegate storeBookCollectionViewCellPlayButtontapped:self lastState:_playButton.selected];
        //[self showPrivewView:!_playButton.selected];
        [self setTime:@""];
        
    }
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NO_INTERNET_TITLE message:NO_INTERNET_MESSAGE delegate:nil cancelButtonTitle:BUTTON_OK otherButtonTitles:nil];
        [alert show];
      
    }
}

- (IBAction)menuButtonTapped:(id)sender {
    if(_delegate){
        [_delegate storeBookCollectionViewCellMenuButtontapped:self];
    }
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
- (void)showActivityIndicator:(BOOL)show{
    _activityIndicator.hidden=!show;
}

- (void)setLoadingLableText:(NSString *)text
{
    _loadingLabel.text = text ? text : @"";
}

- (void)setTime:(NSString *)time
{
    _timeLabel.text = time ? time : @"";
}

- (void)awakeFromNib {
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(yourmethod) name:@"notificationName" object:nil];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"notificationName" object:nil];

    _bgView.layer.cornerRadius = 2.0;
    _bgView.layer.masksToBounds = YES;
    
    _previewView.hidden = YES;
    _imgAwardIcon.hidden = YES;
    
    _imgDownloadedIcon.hidden = YES;
}

- (void)setCellObject:(AudioBook *)cellObject
{
    _cellObject = cellObject;
    
    if(_cellObject.lanCode == LAN_SI){
        _bookName.font = [UIFont fontWithName:@"FMAbhaya" size:9];
        [_bookName setTruncationToken:@"'''"];
        
        _bookAuther.font = [UIFont fontWithName:@"FMAbhaya" size:9];
        [_bookAuther setTruncationToken:@"'''"];


    }else{
        _bookName.font = [UIFont fontWithName:@"HelveticaNeue" size:9];
        [_bookName setTruncationToken:@"..."];
        
        _bookAuther.font = [UIFont fontWithName:@"HelveticaNeue" size:9];
        [_bookAuther setTruncationToken:@"..."];

  
    }
    
    if(_cellObject.isAwarded){
        _imgAwardIcon.hidden=NO;
        
    }else{
        _imgAwardIcon.hidden=YES;
    }
   
    NSString *priceText=@"Free";
    if([_cellObject.price floatValue]>0 ){
        priceText=[NSString stringWithFormat:@"Rs. %@",_cellObject.price];
    }
    _priceLabel.text=priceText;

    if([[DataSource sharedInstance] isUserLogin] && (_cellObject.isPurchase || [AppUtils isBookPurchase:_cellObject.book_id])){
        _cellObject.isPurchase=YES;
        _imgDownloadedIcon.hidden=NO;
        _priceLabel.hidden=YES;
    }else {
        _imgDownloadedIcon.hidden=YES;
        _priceLabel.hidden=NO;
    }
    
    NSLog(@"_cellObject.title %@",_cellObject.title);
    _bookName.text=_cellObject.title;
    _bookAuther.text=_cellObject.author;
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
