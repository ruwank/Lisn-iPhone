//
//  MyBookCollectionViewCell.m
//  Lisn
//
//  Created by A M S Sumanasooriya on 3/26/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import "MyBookCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"
#import <ResponsiveLabel.h>

@interface MyBookCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet ResponsiveLabel *bookName;
@property (weak, nonatomic) IBOutlet ResponsiveLabel *bookAuther;


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
