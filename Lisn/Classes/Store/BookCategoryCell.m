//
//  BookCategoryCell.m
//  Lisn
//
//  Created by A M S Sumanasooriya on 4/4/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import "BookCategoryCell.h"
#import "StoreBookCollectionViewCell.h"
#import "AppConstant.h"
#import "AppDelegate.h"

@interface BookCategoryCell() <UICollectionViewDataSource, UICollectionViewDelegate, StoreBookCollectionViewCellDelegate>

@property (weak, nonatomic) IBOutlet UIView *cellView;
@property (weak, nonatomic) IBOutlet UICollectionView *cellCollectionView;

@property (nonatomic, strong) NSMutableArray *booksArray;
@property (nonatomic, assign) float cellW;
@property (nonatomic, assign) float cellHLong;

@property (nonatomic, strong) StoreBookCollectionViewCell *selectedStoreBookCell;

@end

@implementation BookCategoryCell

- (void)awakeFromNib
{
    [self adjustViewHeights];
    
    _booksArray = [[NSMutableArray alloc] init];
}

- (void)adjustViewHeights
{
    _cellW = (SCREEN_WIDTH - 30)/3.0;
    
    float imgW = _cellW - 12;
    float imgH = imgW * 1.5;
    
    _cellHLong = imgH + 89 - 15;
}

- (void)setBookCategory:(BookCategory *)bookCategory
{
    _bookCategory = bookCategory;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
    //return _booksArray.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(8, 5, 8, 5);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(_cellW, _cellHLong);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StoreBookCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StoreBookCollectionViewCellId" forIndexPath:indexPath];
    cell.bookCellType = BookCellTypeNewReleased;
    cell.delegate = self;
//    int index = (int)[indexPath item];
//    [cell setCellObject:[_booksArray objectAtIndex:index]];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - StoreBookCollectionViewCellDelegate

- (void)storeBookCollectionViewCellPlayButtontapped:(StoreBookCollectionViewCell *)storeBookCollectionViewCell lastState:(BOOL)playing {
    
    
}


@end
