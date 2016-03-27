//
//  HomeViewController.m
//  Lisn
//
//  Created by Rasika Kumara on 3/16/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import "HomeViewController.h"
#import "MyBookCollectionViewCell.h"
#import "StoreBookCollectionViewCell.h"
#import "AppConstant.h"
#import "AppDelegate.h"

@interface HomeViewController () <UICollectionViewDataSource, UICollectionViewDelegate, StoreBookCollectionViewCellDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

@property (weak, nonatomic) IBOutlet UIView *myBooksView;
@property (weak, nonatomic) IBOutlet UICollectionView *myBooksCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *myBookLayConstHeight;

@property (weak, nonatomic) IBOutlet UIView *nReleasesView;
@property (weak, nonatomic) IBOutlet UICollectionView *nRelCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nRelLayoutConstHeight;

@property (weak, nonatomic) IBOutlet UIView *topRatedView;
@property (weak, nonatomic) IBOutlet UICollectionView *topRatedCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topRatedLayoutConstHeight;

@property (weak, nonatomic) IBOutlet UIView *topDownView;
@property (weak, nonatomic) IBOutlet UICollectionView *topDownCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDownLayoutConstHeight;

@property (nonatomic, strong) NSMutableArray *myBooksArray;
@property (nonatomic, strong) NSMutableArray *nReleseArray;
@property (nonatomic, strong) NSMutableArray *topRatedArray;
@property (nonatomic, strong) NSMutableArray *topDownArray;

@property (nonatomic, assign) float cellW;
@property (nonatomic, assign) float cellH;
@property (nonatomic, assign) float cellHLong;


@end

@implementation HomeViewController
- (IBAction)storeButtonTapped:(id)sender {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self adjustViewHeights];
    [self loadData];
}

- (void)adjustViewHeights
{
    _cellW = (SCREEN_WIDTH - 60)/3.0;
    
    float imgW = _cellW - 12;
    float imgH = imgW * 1.5;
    
    _cellH = imgH + 39;
    _cellHLong = imgH + 89;
    
    float myViewH = _cellH + 54;
    float othersH = _cellHLong + 54;
    
    _myBookLayConstHeight.constant = myViewH;
    _nRelLayoutConstHeight.constant = othersH;
    _topRatedLayoutConstHeight.constant = othersH;
    _topDownLayoutConstHeight.constant = othersH;
}

- (void)loadData
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    _myBooksArray = [[NSMutableArray alloc] init];
    _nReleseArray = [[NSMutableArray alloc] init];
    _topRatedArray = [[NSMutableArray alloc] init];
    _topDownArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dic in appDelegate.topReleaseBookList) {
        [_nReleseArray addObject:[[AudioBook alloc] initWithDataDictionary:dic]];
    }
    
    for (NSDictionary *dic in appDelegate.topRatedBookList) {
        [_topRatedArray addObject:[[AudioBook alloc] initWithDataDictionary:dic]];
    }
    
    for (NSDictionary *dic in appDelegate.topDownloadedBookList) {
        [_topDownArray addObject:[[AudioBook alloc] initWithDataDictionary:dic]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([collectionView isEqual:_myBooksCollectionView]) {
        return _myBooksArray.count;
    }else if ([collectionView isEqual:_nRelCollectionView]) {
        return _nReleseArray.count;
    }else if ([collectionView isEqual:_topRatedCollectionView]) {
        return _topRatedArray.count;
    }else if ([collectionView isEqual:_topDownCollectionView]) {
        return _topDownArray.count;
    }
    
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 4, 0, 4);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 20.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:_myBooksCollectionView]) {
        return CGSizeMake(_cellW, _cellH);
    }
    return CGSizeMake(_cellW, _cellHLong);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([collectionView isEqual:_myBooksCollectionView]) {
        MyBookCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyBookCollectionViewCellId" forIndexPath:indexPath];
        int index = (int)[indexPath item];
        [cell setCellObject:[_myBooksArray objectAtIndex:index]];
        return cell;
    }else if ([collectionView isEqual:_nRelCollectionView]) {
        StoreBookCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StoreBookCollectionViewCellId" forIndexPath:indexPath];
        cell.bookCellType = BookCellTypeNewReleased;
        cell.delegate = self;
        int index = (int)[indexPath item];
        [cell setCellObject:[_nReleseArray objectAtIndex:index]];
        return cell;
    }else if ([collectionView isEqual:_topRatedCollectionView]) {
        StoreBookCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StoreBookCollectionViewCellId" forIndexPath:indexPath];
        cell.bookCellType = BookCellTypeTopRated;
        cell.delegate = self;
        int index = (int)[indexPath item];
        [cell setCellObject:[_topRatedArray objectAtIndex:index]];
        return cell;
    }else if ([collectionView isEqual:_topDownCollectionView]) {
        StoreBookCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"StoreBookCollectionViewCellId" forIndexPath:indexPath];
        cell.bookCellType = BookCellTypeTopDownload;
        cell.delegate = self;
        int index = (int)[indexPath item];
        [cell setCellObject:[_topDownArray objectAtIndex:index]];
        return cell;
    }
    
    return nil;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - StoreBookCollectionViewCellDelegate

- (void)storeBookCollectionViewCellPlayButtontapped:(StoreBookCollectionViewCell *)storeBookCollectionViewCell lastState:(BOOL)playing {
    if (storeBookCollectionViewCell.bookCellType == BookCellTypeNewReleased) {
        if (playing) {
            [storeBookCollectionViewCell setPlayButtonStateTo:NO];
            [storeBookCollectionViewCell showPrivewView:NO];
        }else {
            [storeBookCollectionViewCell setPlayButtonStateTo:YES];
            [storeBookCollectionViewCell showPrivewView:YES];
        }
    }else if (storeBookCollectionViewCell.bookCellType == BookCellTypeTopRated) {
        
    }else if (storeBookCollectionViewCell.bookCellType == BookCellTypeTopDownload) {
        
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
