//
//  PlayerViewController.m
//  Lisn
//
//  Created by A M S Sumanasooriya on 7/2/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import "PlayerViewController.h"
#import "FileOperator.h"
#import "AudioPlayer.h"
#import "AppUtils.h"
#import "DataSource.h"
#import "UIImageView+AFNetworking.h"
#import "iCarousel.h"
#import "AudioCoverFlowCell.h"
#import <ResponsiveLabel.h>

@import AVFoundation;

@interface PlayerViewController () <iCarouselDataSource, iCarouselDelegate>

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLbl;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet ResponsiveLabel *bookNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *chapterLbl;
@property (weak, nonatomic) IBOutlet iCarousel *iCarouselView;


@property (nonatomic, strong) NSString *bookId;
@property (assign) int chapterIndex;
@property (nonatomic, strong) NSTimer *timer;
@property (assign) int totalTime;
@property (assign) int currentTime;

@property (nonatomic, strong) NSArray *chapterArray;
@property (assign) float cellW;
@property (assign) float cellH;
@property (nonatomic, strong) NSString *bookImgUrl;

@end

@implementation PlayerViewController

- (IBAction)closeButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)playButtonTapped:(id)sender {
    
    if (!_playBtn.selected) {
        if (![[AudioPlayer getSharedInstance] playAudio]) {
            //ToDo show error msg on can't play
        }
        [self startTimer];
        _playBtn.selected = YES;
    }else {
        [[AudioPlayer getSharedInstance] pauseAudio];
        [self invalidateTimer];
        _playBtn.selected = NO;
    }
}

- (IBAction)fowerdButtonTapped:(id)sender
{
    [[AudioPlayer getSharedInstance] seekTo:30];
}

- (IBAction)replayButtonTapped:(id)sender
{
    [[AudioPlayer getSharedInstance] seekTo:-30];
}

- (void)dealloc
{
    [self invalidateTimer];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"dealloc : %@",[self description]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerNotificationReceived:) name:PLAYER_NOTIFICATION object:nil];
    
    _cellH = 220;
    _cellW = _cellH/1.5;
    
    if(!_bookId || _bookId.length<1){
        AudioPlayer *player = [AudioPlayer getSharedInstance];

        if(player.isPlaying){
            _bookId=player.currentBookId;
            _chapterIndex=player.currentChapterIndex;
        }
    }else{
        
    }
    NSMutableDictionary *userBook = [[DataSource sharedInstance] getUserBook];
    AudioBook *audioBook = [userBook objectForKey:_bookId];
    _bookImgUrl = audioBook.cover_image;
    
    _chapterArray = audioBook.chapters;
    _iCarouselView.type = iCarouselTypeCoverFlow2;
    [_iCarouselView reloadData];
    
    [_iCarouselView scrollToItemAtIndex:0 animated:YES];
    
    NSMutableURLRequest *imageRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_bookImgUrl]
                                                                cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                            timeoutInterval:60];
    [_bgImageView setImageWithURLRequest:imageRequest
                        placeholderImage:[UIImage imageNamed:@"AppIcon"]
                                 success:nil
                                 failure:nil];
    
    if(audioBook.lanCode == LAN_SI){
        _bookNameLbl.font = [UIFont fontWithName:@"FMAbhaya" size:18];
        [_bookNameLbl setTruncationToken:@"'''"];
        
    }else{
        _bookNameLbl.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
        [_bookNameLbl setTruncationToken:@"..."];
    }
    
    _bookNameLbl.text = audioBook.title;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    AudioPlayer *player = [AudioPlayer getSharedInstance];

    if (!player.isPlaying) {
        [player startPlayerWithBook:_bookId andChapterIndex:_chapterIndex];

    }else{
        _currentTime = [AudioPlayer getSharedInstance].audioPlayer.currentTime;
        
        [self startPlaying];
        
        _chapterLbl.text = [NSString stringWithFormat:@"Chapter %d", _chapterIndex];
        [_iCarouselView scrollToItemAtIndex:_chapterIndex-1 animated:NO];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)startPlaying
{
    [self startTimer];
    _playBtn.selected = YES;
}

- (void)stopPlaying
{
    [self invalidateTimer];
    _currentTime = 0;
    
    [self updateSlider];
    [self updateElapsedTime];
    _playBtn.selected = NO;
}

- (void)pausePlaying
{
    [self invalidateTimer];
    _playBtn.selected = NO;
}

- (void)playerNotificationReceived:(NSNotification *)notification
{
    NSNumber *number = [notification.userInfo objectForKey:PlayerNotificationTypeKey];
    if (number.intValue == PlayerNotificationTypePlayingFinished) {
        [self stopPlaying];
    }else if (number.intValue == PlayerNotificationTypePlayingPaused) {
        _currentTime = [AudioPlayer getSharedInstance].audioPlayer.currentTime;
        [self pausePlaying];
    }else if (number.intValue == PlayerNotificationTypePlayingResumed) {
        _currentTime = [AudioPlayer getSharedInstance].audioPlayer.currentTime;
        
        [self startPlaying];
        
        //NSString *bookId = [notification.userInfo objectForKey:PlayerNotificationBookIdKey];
        int chapterIndex = [[notification.userInfo objectForKey:PlayerNotificationChapterIndexKey] intValue];
        
        _chapterLbl.text = [NSString stringWithFormat:@"Chapter %d", chapterIndex];
        [_iCarouselView scrollToItemAtIndex:chapterIndex-1 animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startTimer
{
    [self invalidateTimer];
    
    _totalTime = [AudioPlayer getSharedInstance].audioPlayer.duration;
    _totalTimeLbl.text = [self timeStringOfSeconds:_totalTime];
    
    [self updateSlider];
    [self updateElapsedTime];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.9 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
}

- (void)timerFired:(NSTimer *)timer
{
    _currentTime = [AudioPlayer getSharedInstance].audioPlayer.currentTime;
    
    [self updateSlider];
    [self updateElapsedTime];
}

- (void)invalidateTimer
{
    if (_timer.isValid) {
        [_timer invalidate];
    }
}

- (void)updateSlider
{
    if (_totalTime <= 0 || _currentTime <= 0) {
        _slider.value = 0.0f;
        return;
    }
    
    _slider.value = _currentTime / (_totalTime * 1.0f);
}

- (void)updateElapsedTime
{
    _currentTimeLbl.text = [self timeStringOfSeconds:_currentTime];
}

- (NSString *)timeStringOfSeconds:(int)seconds
{
    if (seconds < 0) {
        return @"0.00";
    }
    
    int minutes = 0;
    if (seconds > 59) {
        minutes = seconds/60;
        seconds = seconds - minutes * 60;
    }
    
    if (seconds < 10) {
        return [NSString stringWithFormat:@"%d.0%d", minutes, seconds];
    }
    
    return [NSString stringWithFormat:@"%d.%d", minutes, seconds];
}

#pragma mark - PlayerCodes

-(void)setAudioBook:(NSString*)theBookId andFileIndex:(int)index{
    _bookId = theBookId;
    _chapterIndex = index;
}

- (NSData *)getAudioData
{
    NSString *audioFilePath = [FileOperator getAudioFilePath:_bookId andFileIndex:_chapterIndex];
    NSError* error = nil;
    NSData *fileData = [NSData dataWithContentsOfFile:audioFilePath options: 0 error: &error];
    
    if (fileData == nil) {
        return nil;
    }
    
    NSData *decryptedData = [AppUtils getDecryptedDataOf:fileData];
    if (decryptedData == nil) {
        return nil;
    }
    
    return decryptedData;
}

#pragma mark -
#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    //return the total number of items in the carousel
    return [_chapterArray count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    //create new view if no view is available for recycling
    if (view == nil)
    {
        AudioCoverFlowCell *cell = [[AudioCoverFlowCell alloc] initWithFrame:CGRectMake(0, 0, _cellW, _cellW)];
        cell.thumbUrl = _bookImgUrl;
        cell.chapterId = (int)index + 1;
        view = cell;
    }
    else
    {
        AudioCoverFlowCell *cell = (AudioCoverFlowCell *)view;
        cell.chapterId = (int)index + 1;
    }
    
    return view;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return 200;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (option == iCarouselOptionSpacing)
    {
        return value * 1.1;
    }
    return value;
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    if (_chapterIndex != (int)index - 1) {
        AudioPlayer *player = [AudioPlayer getSharedInstance];
        [player startPlayerWithBook:_bookId andChapterIndex:(int)index + 1];
    }
}

@end