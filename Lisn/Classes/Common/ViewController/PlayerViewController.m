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

@import AVFoundation;

@interface PlayerViewController ()

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLbl;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;


@property (nonatomic, strong) NSString *bookId;
@property (assign) int chapterIndex;
@property (nonatomic, strong) NSTimer *timer;
@property (assign) int totalTime;
@property (assign) int currentTime;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerNotificationReceived:) name:PLAYER_NOTIFICATION object:nil];
    
    //Get chapter list
//    NSMutableDictionary *userBook=[[DataSource sharedInstance] getUserBook];
//
//    AudioBook *audioBook=[userBook objectForKey:_bookId];
//    NSArray *chaptes=audioBook.chapters;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    AudioPlayer *player = [AudioPlayer getSharedInstance];
    [player startPlayerWithBook:_bookId andChapterIndex:_chapterIndex];
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
        
        NSString *bookId = [notification.userInfo objectForKey:PlayerNotificationBookIdKey];
        int chapterIndex = [[notification.userInfo objectForKey:PlayerNotificationChapterIndexKey] intValue];
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
    NSLog(@"SliderTime: %d", _currentTime);
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

@end