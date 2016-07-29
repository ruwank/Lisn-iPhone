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
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVPlayer.h>
#import <AVFoundation/AVPlayerItem.h>
#import <AVFoundation/AVAsset.h>
#import "AppUtils.h"
#import "BookDetailViewController.h"
#import "DataSource.h"
#import <Crashlytics/Crashlytics.h>

@interface HomeViewController () <UICollectionViewDataSource, UICollectionViewDelegate, StoreBookCollectionViewCellDelegate,UIActionSheetDelegate>{
    NSTimer *_timer;
}

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

@property (nonatomic, strong) StoreBookCollectionViewCell *selectedStoreBookCell;
@property (nonatomic, strong) AVPlayer *previewPlayer;

@end

@implementation HomeViewController
- (IBAction)storeButtonTapped:(id)sender {
   [ self.tabBarController setSelectedIndex:1];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self adjustViewHeights];
    [self loadData];
    

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadMyBookData];

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removePreviewPlayer];
    
}

- (void)adjustViewHeights
{
    _cellW = (SCREEN_WIDTH - 40)/3.0;
    
    float imgW = _cellW - 12;
    float imgH = imgW * 1.5;
    
    _cellH = imgH + 39;
    _cellHLong = imgH + 89 - 15;
    
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
    
    int count = 0;
    for (NSDictionary *dic in appDelegate.topReleaseBookList) {
        [_nReleseArray addObject:[[AudioBook alloc] initWithDataDictionary:dic]];
        count ++;
        if (count >= 3) {
            break;
        }
    }
    
    count = 0;
    for (NSDictionary *dic in appDelegate.topRatedBookList) {
        [_topRatedArray addObject:[[AudioBook alloc] initWithDataDictionary:dic]];
        count ++;
        if (count >= 3) {
            break;
        }
    }
    
    count = 0;
    for (NSDictionary *dic in appDelegate.topDownloadedBookList) {
        [_topDownArray addObject:[[AudioBook alloc] initWithDataDictionary:dic]];
        count ++;
        if (count >= 3) {
            break;
        }
    }
   // [self loadMyBookData];
    
    
}

-(void)loadMyBookData{
    [_myBooksArray removeAllObjects ];

    if([[DataSource sharedInstance] isUserLogin]){
        NSMutableDictionary *userBook=[[DataSource sharedInstance] getUserBook];
        NSInteger count=3;
        NSArray *uesrBook=[userBook allValues];
        
        if([uesrBook count]<3){
            count=[uesrBook count];
        }
        for (int index=0; index<count; index++) {
            [_myBooksArray addObject:[uesrBook objectAtIndex:index]];
        }
    }
    if (_myBooksArray.count == 0) {
        _myBookLayConstHeight.constant = 0;
    }else {
        _myBookLayConstHeight.constant = 254;
    }
    [_myBooksCollectionView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
//    if(self.previewPlayer != NULL){
//        [self.previewPlayer removeObserver:self forKeyPath:@"status"];
//        
//    }
}
-(void)removePreviewPlayer{
    if(self.selectedStoreBookCell != NULL){
        [_selectedStoreBookCell showPrivewView:NO];
        [_selectedStoreBookCell setPlayButtonStateTo:NO];
    }
    if(self.previewPlayer){
        [self.previewPlayer pause];
    }
    if ([_timer isValid]) {
        [_timer invalidate];
    }
    _timer = nil;
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
    return 10.0;
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
    AudioBook *audioBook = nil;
    
    if ([collectionView isEqual:_myBooksCollectionView]) {
        MyBookCollectionViewCell *cell = (MyBookCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        audioBook = cell.cellObject;
    }else {
        StoreBookCollectionViewCell *cell = (StoreBookCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        audioBook = cell.cellObject;
    }
    
    [self performSegueWithIdentifier:@"book_detail_segue" sender:audioBook];
}

#pragma mark - StoreBookCollectionViewCellDelegate

- (void)storeBookCollectionViewCellPlayButtontapped:(StoreBookCollectionViewCell *)storeBookCollectionViewCell lastState:(BOOL)playing {
    
    
    [self removePreviewPlayer];

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
- (void)storeBookCollectionViewCellMenuButtontapped:(StoreBookCollectionViewCell *)storeBookCollectionViewCell{
    self.selectedStoreBookCell=storeBookCollectionViewCell;
    
    UIActionSheet *actionSheet = [AppUtils getActionSheetForAudioBook:self.selectedStoreBookCell.cellObject];
    actionSheet.delegate=self;
    [actionSheet showInView:self.view];
}
#pragma mark - Preview Play

-(void)playSelectedPreview{
//    if(self.previewPlayer != NULL){
//        [self.previewPlayer removeObserver:self forKeyPath:@"status"];
//        
//    }
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
    //[self.previewPlayer removeObserver:self forKeyPath:@"status"];
    [_selectedStoreBookCell showPrivewView:NO];
    [_selectedStoreBookCell setPlayButtonStateTo:NO];

    if ([_timer isValid]) {
        [_timer invalidate];
    }
    _timer = nil;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == self.previewPlayer && [keyPath isEqualToString:@"status"]) {
        [self.previewPlayer removeObserver:self forKeyPath:@"status"];

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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"book_detail_segue"]) {
        BookDetailViewController *detailController = segue.destinationViewController;
        detailController.audioBook = sender;
    }
}

@end
