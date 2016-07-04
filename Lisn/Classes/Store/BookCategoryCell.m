//
//  BookCategoryCell.m
//  Lisn
//
//  Created by A M S Sumanasooriya on 4/4/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import "BookCategoryCell.h"
#import "AppConstant.h"
#import "AppDelegate.h"
#import "AppUtils.h"
#import "WebServiceURLs.h"
#import "DataSource.h"

@interface BookCategoryCell() <UICollectionViewDataSource, UICollectionViewDelegate>{
    UIActivityIndicatorView *activityIndicator;

}

@property (weak, nonatomic) IBOutlet UIView *cellView;
@property (weak, nonatomic) IBOutlet UICollectionView *cellCollectionView;

@property (nonatomic, strong) NSMutableArray *booksArray;
@property (nonatomic, assign) float cellW;
@property (nonatomic, assign) float cellHLong;



@end

@implementation BookCategoryCell

- (void)awakeFromNib
{
    [self adjustViewHeights];
    activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    activityIndicator.center = self.center;
    [self addSubview:activityIndicator];
    
    //_booksArray = [[NSMutableArray alloc] init];
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
    AFHTTPSessionManager *manager = [AppUtils getAFHTTPSessionManager];
    
//    if(_booksArray && [_booksArray count]>0)
//    [_booksArray removeAllObjects];
//     [_cellCollectionView reloadData];
    _booksArray=[[DataSource sharedInstance] getStoreBookFarCatergoy:_bookCategory._id];
     [_cellCollectionView reloadData];
    [activityIndicator stopAnimating];
    if([_booksArray count] ==0){
       
        NSDictionary *params = @ {@"cat" :_bookCategory._id};
[activityIndicator startAnimating];
        
        [manager POST:book_category_url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [activityIndicator stopAnimating];
            if(responseObject != NULL && [responseObject isKindOfClass:[NSArray class]]){
                
                NSMutableArray *booksDataArray=(NSMutableArray*)responseObject;
                NSMutableArray *dataArray=[[NSMutableArray alloc] init];
                for (NSDictionary *dic in booksDataArray) {
                    AudioBook *audioBook=[[AudioBook alloc] initWithDataDictionary:dic];
                    [dataArray addObject:audioBook];
                
                }
                NSString *catId=[params objectForKey:@"cat"];
                [[DataSource sharedInstance] addToStoreBookDic:[dataArray copy] andCatId:catId];
                if([catId intValue] ==[_bookCategory._id intValue]){
                self.booksArray=dataArray;
                [self finishDownload];
                }else{
                    NSLog(@"not equal");
                }
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error %@",error);
            [activityIndicator stopAnimating];
            [self finishDownload];
            
        }];
    }
}
-(void)finishDownload{
    [_cellCollectionView reloadData];

}
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   // return 10;
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
    cell.delegate = self.delegate;
    int index = (int)[indexPath item];
    [cell setCellObject:[_booksArray objectAtIndex:index]];
    [cell showPrivewView:NO];
    [cell setPlayButtonStateTo:NO];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    StoreBookCollectionViewCell *cell = (StoreBookCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    AudioBook *audioBook = cell.cellObject;
    
    if(_delegate){
        [_delegate storeBookCollectionViewCellSelect:audioBook];
    }


}




@end
