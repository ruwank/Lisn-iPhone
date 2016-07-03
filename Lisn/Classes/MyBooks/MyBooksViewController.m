//
//  MyBooksViewController.m
//  Lisn
//
//  Created by Rasika Kumara on 3/25/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import "MyBooksViewController.h"
#import "MyBookCollectionViewCell.h"
#import "AppConstant.h"
#import "AppDelegate.h"
#import "AppUtils.h"
#import "WebServiceURLs.h"
#import "WebServiceManager.h"
#import "Messages.h"
#import "DataSource.h"
#import "BookDetailViewController.h"

@interface MyBooksViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *myBooksCollectionView;

@property (nonatomic, strong) NSArray *myBooksArray;

@property (nonatomic, assign) float cellW;
@property (nonatomic, assign) float cellH;

@end

@implementation MyBooksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadData];
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
    
    _cellH = imgH + 39;
}

- (void)loadData
{
    //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *userBook=[[DataSource sharedInstance] getUserBook];
   // NSArray *uesrBook=[userBook allValues];
    
    _myBooksArray = [userBook allValues];
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    //return 10;
    return _myBooksArray.count;
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
    return CGSizeMake(_cellW, _cellH);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyBookCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyBookCollectionViewCellId" forIndexPath:indexPath];
    int index = (int)[indexPath item];
    [cell setCellObject:[_myBooksArray objectAtIndex:index]];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyBookCollectionViewCell *cell = (MyBookCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    AudioBook *audioBook  = cell.cellObject;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BookDetailViewController * viewController = [storyboard instantiateViewControllerWithIdentifier:@"BookDetailViewControllerId"];
    viewController.audioBook=audioBook;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
