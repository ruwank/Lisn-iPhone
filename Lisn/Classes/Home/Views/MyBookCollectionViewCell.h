//
//  MyBookCollectionViewCell.h
//  Lisn
//
//  Created by A M S Sumanasooriya on 3/26/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioBook.h"
#import "AppConstant.h"

@interface MyBookCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) AudioBook *cellObject;
@property (nonatomic, assign) BookCellType bookCellType;

@end
