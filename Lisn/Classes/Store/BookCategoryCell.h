//
//  BookCategoryCell.h
//  Lisn
//
//  Created by A M S Sumanasooriya on 4/4/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookCategory.h"
#import "StoreBookCollectionViewCell.h"

@interface BookCategoryCell : UICollectionViewCell

@property (nonatomic, strong) BookCategory *bookCategory;
@property (nonatomic, assign) id<StoreBookCollectionViewCellDelegate> delegate;

@end
