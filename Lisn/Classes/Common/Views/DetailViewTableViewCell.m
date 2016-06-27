//
//  DetailViewTableViewCell.m
//  Lisn
//
//  Created by A M S Sumanasooriya on 6/26/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import "DetailViewTableViewCell.h"

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

- (void)setChapter:(BookChapter *)chapter
{
    _chapter = chapter;
    
    _chapterNameLbl.text = @"";
    _priceLabel.text = @"";
    [_buyButton setTitle:@"BUY" forState:UIControlStateNormal];
    
    if (_chapter == nil) {
        return;
    }
    
    _chapterNameLbl.text = _chapter.chapterName ? _chapter.chapterName : @"";
    _priceLabel.text = _chapter.chapterPrice ? _chapter.chapterPrice : @"";
    [_buyButton setTitle: (_chapter.isBuy || _chapter.isFree) ? @"DOWNLOAD" : @"BUY" forState:UIControlStateNormal];
    
    if (_chapter.isFree) {
        _priceLabel.text = @"Free";
    }
}

@end
