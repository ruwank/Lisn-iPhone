//
//  StoreViewController.m
//  Lisn
//
//  Created by Rasika Kumara on 3/25/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import "StoreViewController.h"
#import "TopTabsScrollView.h"
#import "AppConstant.h"
#import "TabButtonView.h"
#import "AppDelegate.h"
#import "BookCategory.h"
#import "BookCategoryCell.h"

@interface StoreViewController () <TabButtonViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet TopTabsScrollView *topTabScrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *categoriesCollView;

@property (nonatomic, strong) NSMutableArray *tabsButtonArray;
@property (nonatomic, strong) NSMutableArray *categoriesArray;

@end

@implementation StoreViewController

#pragma mark - TabButtonViewDelegate
- (void)tabButtonViewTapped:(TabButtonView *)tabButtonView
{
    for (TabButtonView *btnView in _tabsButtonArray) {
        btnView.selected = NO;
        if (btnView.tag == tabButtonView.tag) {
            btnView.selected = YES;
            [_categoriesCollView selectItemAtIndexPath:[NSIndexPath indexPathForItem:btnView.tag inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
            BookCategory *bookCat = [_categoriesArray objectAtIndex:btnView.tag];
            [self bookCategorySelected:bookCat];
            
            [_topTabScrollView scrollRectToVisible:btnView.frame animated:YES];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _categoriesArray = [[NSMutableArray alloc] init];
    [_categoriesArray addObjectsFromArray:appDelegate.bookCategories];
    
    float scrollContentW = 0;
    int i = 0;
    _tabsButtonArray = [[NSMutableArray alloc] init];
    for (BookCategory *bookCat in _categoriesArray) {
        TabButtonView *btnView = [[TabButtonView alloc] initWithTitle:bookCat.english_name];
        btnView.tag = i;
        [_tabsButtonArray addObject:btnView];
        btnView.frame = CGRectMake(scrollContentW, 0, btnView.width, 44);
        btnView.delegate = self;
        if (i == _categoriesArray.count-1) {
            btnView.hideSeparator = YES;
        }
        
        if (i == 0) {
            btnView.selected = YES;
        }
        
        scrollContentW += btnView.width;
        [_topTabScrollView addSubview:btnView];
        
        i++;
    }
    
    _topTabScrollView.contentSize = CGSizeMake(scrollContentW, 44);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)bookCategorySelected:(BookCategory *)bookCategory
{
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _categoriesArray.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return _categoriesCollView.frame.size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BookCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BookCategoryCellId" forIndexPath:indexPath];
    cell.bookCategory = [_categoriesArray objectAtIndex:[indexPath item]];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = _categoriesCollView.frame.size.width;
    float currentPage = _categoriesCollView.contentOffset.x / pageWidth;
    
    TabButtonView *btnView = [_tabsButtonArray objectAtIndex:(int)currentPage];
    [self tabButtonViewTapped:btnView];
    
    [_topTabScrollView scrollRectToVisible:btnView.frame animated:YES];
}

@end
