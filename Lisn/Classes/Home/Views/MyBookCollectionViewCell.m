//
//  MyBookCollectionViewCell.m
//  Lisn
//
//  Created by A M S Sumanasooriya on 3/26/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import "MyBookCollectionViewCell.h"

@interface MyBookCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *bookName;
@property (weak, nonatomic) IBOutlet UILabel *bookAuther;


@end

@implementation MyBookCollectionViewCell

- (IBAction)menuButtonTapped:(id)sender {
    
}

- (void)awakeFromNib {
    _bgView.layer.cornerRadius = 2.0;
    _bgView.layer.masksToBounds = YES;
    _bookCellType = BookCellTypeMy;
}

- (void)setCellObject:(AudioBook *)cellObject
{
    _cellObject = cellObject;
}

@end
