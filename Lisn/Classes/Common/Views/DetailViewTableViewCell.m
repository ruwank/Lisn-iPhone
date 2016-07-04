//
//  DetailViewTableViewCell.m
//  Lisn
//
//  Created by A M S Sumanasooriya on 6/26/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import "DetailViewTableViewCell.h"
#import "FileOperator.h"
#import "AppUtils.h"

@interface DetailViewTableViewCell()

@property (nonatomic, weak) IBOutlet UILabel *chapterNameLbl;
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UIButton *buyButton;

@end

@implementation DetailViewTableViewCell

- (IBAction)buyButtonTapped:(id)sender
{
    if (_delegate) {
        [_delegate detailViewTableViewCellButtonTapped:self];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setChapter:(BookChapter *)chapter andBookId:(NSString*)bookId andLanguageCode:(LanguageCode)languageCode
{
    _chapter = chapter;
    if (_chapter == nil) {
        return;
    }

    if(languageCode == LAN_SI){
        _chapterNameLbl.font = [UIFont fontWithName:@"FMAbhaya" size:18];
    }else{
        _chapterNameLbl.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
    }
    
    NSString *buttonText=@"Download";
    if(_chapter.isPurchased || [AppUtils isBookChapterPurchase:bookId andChapter:_chapter.chapter_id]){
        _chapter.isPurchased=YES;
        if([FileOperator isAudioFileExists:bookId andFileIndex:_chapter.chapter_id]){
            buttonText=@"Play";
        }
    }else{
        if(_chapter.price>0){
            buttonText=@"Buy";
        }
    }
    _chapterNameLbl.text = @"";
    _priceLabel.text = @"";
    
    [_buyButton setTitle:buttonText forState:UIControlStateNormal];
    
    

    _chapterNameLbl.text = _chapter.title ? _chapter.title : @"";
    _priceLabel.text = _chapter.price ? [NSString stringWithFormat:@"Rs: %.02f",_chapter.price] : @"Free";
//    [_buyButton setTitle: (_chapter.isBuy || _chapter.isFree) ? @"DOWNLOAD" : @"BUY" forState:UIControlStateNormal];
//    
//    if (_chapter.isFree) {
//        _priceLabel.text = @"Free";
//    }
}

@end
