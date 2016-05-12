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

#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVPlayer.h>
#import <AVFoundation/AVPlayerItem.h>
#import <AVFoundation/AVAsset.h>

@interface StoreViewController () <TabButtonViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate,StoreBookCollectionViewCellDelegate>{
    NSTimer *_timer;

}

@property (weak, nonatomic) IBOutlet TopTabsScrollView *topTabScrollView;
@property (weak, nonatomic) IBOutlet UICollectionView *categoriesCollView;

@property (nonatomic, strong) NSMutableArray *tabsButtonArray;
@property (nonatomic, strong) NSMutableArray *categoriesArray;

@property (nonatomic, strong) StoreBookCollectionViewCell *selectedStoreBookCell;
@property (nonatomic, strong) AVPlayer *previewPlayer;
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
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}
- (void)bookCategorySelected:(BookCategory *)bookCategory
{
    //[self removeSelectedPreviewCell];
    [self removePlayer];

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
    [cell setBookCategory:[_categoriesArray objectAtIndex:[indexPath item]]];
    cell.delegate=self;
    //cell.bookCategory = [_categoriesArray objectAtIndex:[indexPath item]];
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

#pragma mark - StoreBookCollectionViewCellDelegate

- (void)storeBookCollectionViewCellPlayButtontapped:(StoreBookCollectionViewCell *)storeBookCollectionViewCell lastState:(BOOL)playing {
    
    if(self.selectedStoreBookCell != NULL){
        [_selectedStoreBookCell showPrivewView:NO];
        [_selectedStoreBookCell setPlayButtonStateTo:NO];
        if(self.previewPlayer){
            [self.previewPlayer pause];
        }
        if ([_timer isValid]) {
            [_timer invalidate];
        }
        _timer = nil;
    }
    self.selectedStoreBookCell=storeBookCollectionViewCell;
    
    if(playing){
        [_selectedStoreBookCell showPrivewView:NO];
        
        NSLog(@"playing");
    }else{
        [_selectedStoreBookCell showPrivewView:YES];
        
        [self playSelectedPreview];
        NSLog(@"not playing");
        
    }
    /*
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
     */
}
#pragma mark - Preview Play
-(void)removePlayer{
    if(self.selectedStoreBookCell != NULL){
        [_selectedStoreBookCell showPrivewView:NO];
        [_selectedStoreBookCell setPlayButtonStateTo:NO];
        if(self.previewPlayer){
                if ([self observationInfo]!=nil)
                {
                    [self.previewPlayer removeObserver:self forKeyPath:@"status"];
                }
            
            [self.previewPlayer pause];
        }
        if ([_timer isValid]) {
            [_timer invalidate];
        }
        _timer = nil;
    }
}

-(void)playSelectedPreview{
    if (self.previewPlayer) {
        if ([self observationInfo]!=nil)
        {
            [self.previewPlayer removeObserver:self forKeyPath:@"status"];
        }
    }
    NSString *audioFileUrl=_selectedStoreBookCell.cellObject.preview_audio;
    AVPlayer *player = [[AVPlayer alloc]initWithURL:[NSURL URLWithString:audioFileUrl]];
    self.previewPlayer = player;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[_previewPlayer currentItem]];
    [self.previewPlayer addObserver:self forKeyPath:@"status" options:0 context:nil];
    // [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgress:) userInfo:nil repeats:YES];
    
    
    
}
-(void)updateSelectedPreviewCell{
    [_selectedStoreBookCell setPlayButtonStateTo:YES];
    [_selectedStoreBookCell setLoadingLableText:@"Preview"];
    [_selectedStoreBookCell showActivityIndicator:NO];
}
-(void)removeSelectedPreviewCell{
    if (self.previewPlayer) {
            if ([self observationInfo]!=nil)
            {
                [self.previewPlayer removeObserver:self forKeyPath:@"status"];
            }
    }
    if(_selectedStoreBookCell){
        [_selectedStoreBookCell setPlayButtonStateTo:NO];
        [_selectedStoreBookCell showPrivewView:NO];
    }
    if ([_timer isValid]) {
        [_timer invalidate];
    }
    _timer = nil;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == self.previewPlayer && [keyPath isEqualToString:@"status"]) {
        if (_previewPlayer.status == AVPlayerStatusFailed) {
            NSLog(@"AVPlayer Failed");
            [self removeSelectedPreviewCell];
            
        } else if (_previewPlayer.status == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
            [self updateSelectedPreviewCell];
            [self.previewPlayer play];
            if (!_timer) {
                _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                          target:self
                                                        selector:@selector(updateProgress:)
                                                        userInfo:nil
                                                         repeats:YES];
            }
            
            
        } else if (_previewPlayer.status == AVPlayerItemStatusUnknown) {
            NSLog(@"AVPlayer Unknown");
            [self removeSelectedPreviewCell];
            
            
        }
    }
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    [self removeSelectedPreviewCell];
    
    //  code here to play next sound file
    
}
- (void)updateProgress:(NSTimer *)timer {
    //    AVPlayerItem *currentItem = _previewPlayer.currentItem;
    //    CMTime duration = currentItem.duration; //total time
    CMTime currentTime = self.previewPlayer.currentItem.currentTime; //playing time
    //    NSLog(@"ping %lld",duration.value -currentTime.value);
    CMTime duration = self.previewPlayer.currentItem.asset.duration;
    int durationSeconds = CMTimeGetSeconds(duration);
    int currentTimeSeconds = CMTimeGetSeconds(currentTime);
    int remainTime=durationSeconds-currentTimeSeconds;
    int minutes = remainTime / 60;
    int seconds = remainTime % 60;
    
    NSString *time = [NSString stringWithFormat:@"%d:%02d", minutes, seconds];
    [_selectedStoreBookCell setTime:time];
    
    NSLog(@"duration: %@ ", time);
    // NSLog(@"remain time: %.2f",(seconds-currentTimeSeconds)/100.0);
}


@end
