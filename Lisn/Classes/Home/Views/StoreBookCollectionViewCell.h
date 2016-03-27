//
//  StoreBookCollectionViewCell.h
//  Lisn
//
//  Created by A M S Sumanasooriya on 3/26/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioBook.h"
#import "AppConstant.h"

@protocol StoreBookCollectionViewCellDelegate;

@interface StoreBookCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) AudioBook *cellObject;
@property (nonatomic, assign) BookCellType bookCellType;

@property (nonatomic, assign) id<StoreBookCollectionViewCellDelegate> delegate;

- (void)setPlayButtonStateTo:(BOOL)play;
- (void)showPrivewView:(BOOL)show;
- (void)showLoadingLabel:(BOOL)show;
- (void)setTime:(NSString *)time;

@end

@protocol StoreBookCollectionViewCellDelegate <NSObject>

- (void)storeBookCollectionViewCellPlayButtontapped:(StoreBookCollectionViewCell *)storeBookCollectionViewCell lastState:(BOOL)playing;

@end
