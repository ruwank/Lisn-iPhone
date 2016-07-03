//
//  PlayerViewController.m
//  Lisn
//
//  Created by A M S Sumanasooriya on 7/2/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import "PlayerViewController.h"
#import "NSData+AES.h"
#import "FileOperator.h"

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

@property (strong, nonatomic) AVAudioSession *audioSession;
@property (strong, nonatomic) AVAudioPlayer *backgroundMusicPlayer;
@property (assign) BOOL backgroundMusicPlaying;
@property (assign) BOOL backgroundMusicInterrupted;

@end

@implementation PlayerViewController

- (IBAction)playButtonTapped:(id)sender {
    
    if (!_backgroundMusicPlaying) {
        [self tryPlayMusic];
        [self startTimer];
        [_playBtn setTitle:@"Pau" forState:UIControlStateNormal];
    }else {
        [self pauseAudio];
        [self invalidateTimer];
        [_playBtn setTitle:@"Ply" forState:UIControlStateNormal];
    }
}

- (void)dealloc
{
    [self invalidateTimer];
    [self stopAudio];
    
    NSLog(@"dealloc : %@",[self description]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if([self configureAudioSession]) {
        [self configureAudioPlayer];
    }else {
        //TODO show message on cannot play at the moment
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self stopAudio];
    [self invalidateTimer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.9 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
}

- (void)timerFired:(NSTimer *)timer
{
    _currentTime = _backgroundMusicPlayer.currentTime;
    _totalTime = _backgroundMusicPlayer.duration;
    
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

#pragma mark - PayerCodes

/*
 * Simply fire the pause Event
 */
- (void)pauseAudio {
    [self.backgroundMusicPlayer pause];
    _backgroundMusicPlaying = NO;
}
/*
 * Simply fire the stop Event
 */
- (void)stopAudio{
    [self.backgroundMusicPlayer stop];
}

- (void)tryPlayMusic
{
    // If background music or other music is already playing, nothing more to do here
    if (self.backgroundMusicPlaying || [self.audioSession isOtherAudioPlaying]) {
        return;
    }
    
    // Play background music if no other music is playing and we aren't playing already
    //Note: prepareToPlay preloads the music file and can help avoid latency. If you don't
    //call it, then it is called anyway implicitly as a result of [self.backgroundMusicPlayer play];
    //It can be worthwhile to call prepareToPlay as soon as possible so as to avoid needless
    //delay when playing a sound later on.
    [self.backgroundMusicPlayer prepareToPlay];
    [self.backgroundMusicPlayer play];
    self.backgroundMusicPlaying = YES;
}

- (BOOL)configureAudioSession
{
    // Implicit initialization of audio session
    self.audioSession = [AVAudioSession sharedInstance];
    
    // Set category of audio session
    // See handy chart on pg. 46 of the Audio Session Programming Guide for what the categories mean
    // Not absolutely required in this example, but good to get into the habit of doing
    // See pg. 10 of Audio Session Programming Guide for "Why a Default Session Usually Isn't What You Want"
    
    NSError *setCategoryError = nil;
    [self.audioSession setCategory:AVAudioSessionCategoryAmbient error:&setCategoryError];
    
    if (setCategoryError) {
        NSLog(@"Error setting category! %ld", (long)[setCategoryError code]);
        return NO;
    }
    
    return YES;
}
-(void)setAudioBook:(NSString*)theBookId andFileIndex:(int)index{
    bookId=theBookId;
    chapterIndex=index;
}
- (void)configureAudioPlayer {
    // Create audio player with background music

    NSString *audioFilePath=[FileOperator getAudioFilePath:bookId andFileIndex:chapterIndex];
    NSError* error = nil;
    NSData *fileData = [NSData dataWithContentsOfFile:audioFilePath options: 0 error: &error];
    if (fileData == nil)
    {
        NSLog(@"Failed to read file, error %@", error);
    }
    else
    {
     
        NSData* audioFileData = [self decryptData:fileData  WithKey:@"K66wl3d43I$P0937"];
        
        self.backgroundMusicPlayer=[[AVAudioPlayer alloc] initWithData:audioFileData fileTypeHint:AVFileTypeMPEGLayer3 error:&error];

        if (self.backgroundMusicPlayer == nil) {
            NSLog(@"AudioPlayer did not load properly: %@", [error description]);
        } else {
            [self.backgroundMusicPlayer play];
        }
      
        if(error){
            NSLog(@"error %@",error);
        }
        self.backgroundMusicPlayer.delegate = self;  // We need this so we can restart after interruptions
    }
    _currentTime = 0;
    _totalTime = _backgroundMusicPlayer.duration;
    _totalTimeLbl.text = [self timeStringOfSeconds:_totalTime];
}

#pragma mark - AVAudioPlayerDelegate methods

- (void)audioPlayerBeginInterruption: (AVAudioPlayer *) player {
    //It is often not necessary to implement this method since by the time
    //this method is called, the sound has already stopped. You don't need to
    //stop it yourself.
    //In this case the backgroundMusicPlaying flag could be used in any
    //other portion of the code that needs to know if your music is playing.
    
    self.backgroundMusicInterrupted = YES;
    self.backgroundMusicPlaying = NO;
}

- (void)audioPlayerEndInterruption: (AVAudioPlayer *) player withOptions:(NSUInteger) flags{
    //Since this method is only called if music was previously interrupted
    //you know that the music has stopped playing and can now be resumed.
    [self tryPlayMusic];
    self.backgroundMusicInterrupted = NO;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [_playBtn setTitle:@"Ply" forState:UIControlStateNormal];
    self.backgroundMusicPlaying = NO;
    player.currentTime = 0;
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    //TODO
}

//decrypt audio file
- (NSData *)decryptData:(NSData *)data WithKey:(NSString *)key
{
    char keyPtr[kCCKeySizeAES256+1];
    bzero(keyPtr, sizeof(keyPtr));
    
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr, kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer);
    return nil;
}

@end
