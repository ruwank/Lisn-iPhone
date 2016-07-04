//
//  AudioPlayer.m

//  Created by Md Farhad Hossain,XOR Co. Ltd. on 3/29/16.
//  Copyright © 2016 XOR Co. Ltd. All rights reserved.
//

#import "AudioPlayer.h"
#import "AppConstant.h"

@interface AudioPlayer() <AVAudioPlayerDelegate>

@property (strong, nonatomic) AVAudioSession *audioSession;
@property (assign) BOOL backgroundMusicPlaying;
@property (assign) BOOL backgroundMusicInterrupted;

@property (assign) BOOL canPlayAudio;

@end

static AudioPlayer *instance;

@implementation AudioPlayer

+ (AudioPlayer *)getSharedInstance
{
    if (instance == nil) {
        instance = [[AudioPlayer alloc] init];
    }
    
    return instance;
}

- (void)dealloc
{
    [self stopAudio];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioSessionNotificationReceived:) name:AVAudioSessionInterruptionNotification object:nil];
    }
    
    return self;
}

- (BOOL)setAudioData:(NSData *)audioData
{
    [self configureAudioSession];
    
    NSError* error = nil;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:audioData fileTypeHint:AVFileTypeMPEGLayer3 error:&error];
    
    if (self.audioPlayer == nil) {
        NSLog(@"AudioPlayer did not load properly: %@", [error description]);
    }
    
    if(error){
        NSLog(@"error %@",error);
        return NO;
    }
    
    self.audioPlayer.delegate = self;
    
    return YES;
}

- (BOOL)playAudio {
    
    if (!_canPlayAudio) {
        return NO;
    }
    
    if ([self.audioSession isOtherAudioPlaying]) {
        return NO;
    }
    
    if (self.backgroundMusicPlaying) {
        return YES;
    }
    
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
    _backgroundMusicPlaying = YES;
    _backgroundMusicInterrupted = NO;
    
    return YES;
}

- (void)pauseAudio
{
    [self.audioPlayer pause];
    _backgroundMusicPlaying = NO;
}

- (void)stopAudio
{
    _currentBookId = nil;
    
    [self.audioPlayer stop];
    _backgroundMusicPlaying = NO;
}

- (BOOL)isPlaying
{
    return self.audioPlayer.playing;
}

- (void)configureAudioSession
{
    self.audioSession = [AVAudioSession sharedInstance];

    NSError *setCategoryError = nil;
    [self.audioSession setCategory:AVAudioSessionCategoryAmbient error:&setCategoryError];
    
    if (setCategoryError) {
        NSLog(@"Error setting category! %ld", (long)[setCategoryError code]);
        _canPlayAudio = NO;
    }
    
    _canPlayAudio = YES;
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    _backgroundMusicPlaying = NO;
    [self stopAudio];
    
    NSDictionary *infoDic = @{PlayerNotificationTypeKey : [NSNumber numberWithInt:PlayerNotificationTypePlayingFinished]};
    [[NSNotificationCenter defaultCenter] postNotificationName:PLAYER_NOTIFICATION object:nil userInfo:infoDic];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    [self pauseAudio];
    NSDictionary *infoDic = @{PlayerNotificationTypeKey : [NSNumber numberWithInt:PlayerNotificationTypePlayingPaused]};
    [[NSNotificationCenter defaultCenter] postNotificationName:PLAYER_NOTIFICATION object:nil userInfo:infoDic];
}

- (void)audioSessionNotificationReceived:(NSNotification *)notification
{
    NSNumber *number = [notification.userInfo objectForKey:AVAudioSessionInterruptionTypeKey];
    if (number.intValue == AVAudioSessionInterruptionTypeBegan) {
        _backgroundMusicInterrupted = YES;
        _backgroundMusicPlaying = NO;
        [self pauseAudio];
        
        NSDictionary *infoDic = @{PlayerNotificationTypeKey : [NSNumber numberWithInt:PlayerNotificationTypePlayingPaused]};
        [[NSNotificationCenter defaultCenter] postNotificationName:PLAYER_NOTIFICATION object:nil userInfo:infoDic];
        
    }else if (number.intValue == AVAudioSessionInterruptionTypeEnded) {
        [self playAudio];
        
        NSDictionary *infoDic = @{PlayerNotificationTypeKey : [NSNumber numberWithInt:PlayerNotificationTypePlayingResumed]};
        [[NSNotificationCenter defaultCenter] postNotificationName:PLAYER_NOTIFICATION object:nil userInfo:infoDic];
    }
}


@end
