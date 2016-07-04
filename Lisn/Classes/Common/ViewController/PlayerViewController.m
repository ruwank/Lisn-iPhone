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

@import AVFoundation;

@interface PlayerViewController () <AVAudioPlayerDelegate>{
    NSString *bookId;
    int chapterIndex;
}

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLbl;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;


@property (nonatomic, strong) NSTimer *timer;
@property (assign) int totalTime;
@property (assign) int currentTime;

@end

@implementation PlayerViewController

- (IBAction)playButtonTapped:(id)sender {
    
    if (_playBtn.selected) {
        if (![[AudioPlayer getSharedInstance] playAudio]) {
            //ToDo show error msg on can't play
        }
        [self startTimer];
        _playBtn.selected = NO;
    }else {
        [[AudioPlayer getSharedInstance] pauseAudio];
        [self invalidateTimer];
        _playBtn.selected = YES;
    }
}

- (void)dealloc
{
    [self invalidateTimer];
    
    NSLog(@"dealloc : %@",[self description]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    AudioPlayer *player = [AudioPlayer getSharedInstance];
    if ([player isPlaying]) {
        [self timerFired:nil];
        [self startTimer];
    } else {
        
        BOOL canPlay = NO;
        
        NSData *data = [self getAudioData];
        if (data) {
            if ([player setAudioData:data]) {
                if ([player playAudio]) {
                    canPlay = YES;
                    [self startTimer];
                    _playBtn.selected = YES;
                }
            }
        }
        
        if (!canPlay) {
            //ToDo show error msg on can't play
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startTimer
{
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
    bookId = theBookId;
    chapterIndex = index;
}

- (NSData *)getAudioData
{
    NSString *audioFilePath = [FileOperator getAudioFilePath:bookId andFileIndex:chapterIndex];
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
