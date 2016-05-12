//
//  BookSearchViewController.m
//  Lisn
//
//  Created by A M S Sumanasooriya on 5/7/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import "BookSearchViewController.h"
#import "StoreBookCollectionViewCell.h"
#import "AppConstant.h"
#import "AppDelegate.h"
#import "AppUtils.h"
#import "WebServiceURLs.h"

@interface BookSearchViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, StoreBookCollectionViewCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *cellCollectionView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic, strong) NSMutableArray *booksArray;
@property (nonatomic, assign) float cellW;
@property (nonatomic, assign) float cellHLong;

@property (nonatomic, strong) StoreBookCollectionViewCell *selectedStoreBookCell;

@end

@implementation BookSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _booksArray = [[NSMutableArray alloc] init];
    [self adjustViewHeights];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)adjustViewHeights
{
    _cellW = (SCREEN_WIDTH - 30)/3.0;
    
    float imgW = _cellW - 12;
    float imgH = imgW * 1.5;
    
    _cellHLong = imgH + 89 - 15;
}

- (void)finishDownload
{
    [_cellCollectionView reloadData];
}

- (void)searchBooksFor:(NSString *)searchText
{
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //return 10;
    return _booksArray.count;
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
    int index = (int)[indexPath item];
    [cell setCellObject:[_booksArray objectAtIndex:index]];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - StoreBookCollectionViewCellDelegate

- (void)storeBookCollectionViewCellPlayButtontapped:(StoreBookCollectionViewCell *)storeBookCollectionViewCell lastState:(BOOL)playing {
    
    
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchText = [AppUtils trimmedStringOfString:searchBar.text];
    if (searchText.length > 0) {
        [searchBar resignFirstResponder];
        [self searchBooksFor:searchText];
    }
}

@end
