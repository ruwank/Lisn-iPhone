//
//  AudioPlayer.m

//  Created by Md Farhad Hossain,XOR Co. Ltd. on 3/29/16.
//  Copyright © 2016 XOR Co. Ltd. All rights reserved.
//

#import "AudioPlayer.h"
#import "AppConstant.h"
#import "FileOperator.h"
#import "AppUtils.h"
#import "DataSource.h"

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

- (void)startPlayerWithBook:(NSString *)bookId andChapterIndex:(int)chapterIndex
{
    BOOL isNewFile = YES;
    
    if (_currentBookId != nil) {
        NSString *cBookId = [NSString stringWithFormat:@"%@", _currentBookId];
        if ([cBookId isEqualToString:bookId] && _currentChapterIndex == chapterIndex) {
            isNewFile = NO;
        }
    }
    
    if (isNewFile) {
        [self stopAudio];
        NSDictionary *infoDic = @{PlayerNotificationTypeKey : [NSNumber numberWithInt:PlayerNotificationTypePlayingPaused]};
        [[NSNotificationCenter defaultCenter] postNotificationName:PLAYER_NOTIFICATION object:nil userInfo:infoDic];
    }
    
    _currentBookId = bookId;
    _currentChapterIndex = chapterIndex;
    
    if (!isNewFile && [self isPlaying]) {
        
        NSDictionary *infoDic = @{PlayerNotificationTypeKey : [NSNumber numberWithInt:PlayerNotificationTypePlayingResumed],
                                  PlayerNotificationBookIdKey : _currentBookId,
                                  PlayerNotificationChapterIndexKey : [NSNumber numberWithInt:_currentChapterIndex]};
        
        [[NSNotificationCenter defaultCenter] postNotificationName:PLAYER_NOTIFICATION object:nil userInfo:infoDic];
        
    }else if (!isNewFile && ![self isPlaying]) {
        [self playAudio];
        
        NSDictionary *infoDic = @{PlayerNotificationTypeKey : [NSNumber numberWithInt:PlayerNotificationTypePlayingResumed],
                                  PlayerNotificationBookIdKey : _currentBookId,
                                  PlayerNotificationChapterIndexKey : [NSNumber numberWithInt:_currentChapterIndex]};
        
        [[NSNotificationCenter defaultCenter] postNotificationName:PLAYER_NOTIFICATION object:nil userInfo:infoDic];
        
    } else {
        NSData *data = [self getAudioData];
        if (data) {
            if ([self setAudioData:data]) {
                if ([self playAudio]) {
                    
                    NSMutableDictionary *userBook = [[DataSource sharedInstance] getUserBook];
                    AudioBook *audioBook = [userBook objectForKey:_currentBookId];
                    
                    NSArray *chapters = audioBook.chapters;
                    if (chapters && chapters.count >= _currentChapterIndex) {
                        BookChapter *chapter = [chapters objectAtIndex:_currentChapterIndex-1];
                        if (chapter.lastSeekPoint > 0) {
                            [self seekTo:chapter.lastSeekPoint];
                        }
                    }
                    
                    NSDictionary *infoDic = @{PlayerNotificationTypeKey : [NSNumber numberWithInt:PlayerNotificationTypePlayingResumed],
                                              PlayerNotificationBookIdKey : _currentBookId,
                                              PlayerNotificationChapterIndexKey : [NSNumber numberWithInt:_currentChapterIndex]};
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:PLAYER_NOTIFICATION object:nil userInfo:infoDic];
                    
                }
            }
        }
    }
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
    NSMutableDictionary *userBook = [[DataSource sharedInstance] getUserBook];
    AudioBook *audioBook = [userBook objectForKey:_currentBookId];
    audioBook.lastPlayChapterIndex = _currentChapterIndex;
    
    NSArray *chapters = audioBook.chapters;
    if (chapters && chapters.count >= _currentChapterIndex) {
        BookChapter *chapter = [chapters objectAtIndex:_currentChapterIndex-1];
        chapter.lastSeekPoint = self.audioPlayer.currentTime;
    }
    
    [[DataSource sharedInstance] saveUserBook:userBook];
    
    [self.audioPlayer pause];
    _backgroundMusicPlaying = NO;
}

- (void)stopAudio
{
    if (_currentBookId) {
        NSMutableDictionary *userBook = [[DataSource sharedInstance] getUserBook];
        AudioBook *audioBook = [userBook objectForKey:_currentBookId];
        audioBook.lastPlayChapterIndex = _currentChapterIndex;
        
        NSArray *chapters = audioBook.chapters;
        if (chapters && chapters.count >= _currentChapterIndex) {
            BookChapter *chapter = [chapters objectAtIndex:_currentChapterIndex-1];
            chapter.lastSeekPoint = self.audioPlayer.currentTime;
            if (self.audioPlayer.currentTime == self.audioPlayer.duration) {
                chapter.lastSeekPoint = 0;
            }
        }else {
            audioBook.lastPlayChapterIndex = 1;
        }
        
        [[DataSource sharedInstance] saveUserBook:userBook];
    }
    
    [self.audioPlayer stop];
    _backgroundMusicPlaying = NO;
}

- (void)seekTo:(int)timeGap
{
    if ([self isPlaying]) {
        int totalT = _audioPlayer.duration;
        int currentT = _audioPlayer.currentTime;
        
        int newTime = currentT + timeGap;
        
        if (newTime < 0) {
            _audioPlayer.currentTime = 0;
        }else if (newTime > totalT) {
            _audioPlayer.currentTime = totalT - 2;
        }else {
            _audioPlayer.currentTime = newTime;
        }
    }
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

- (NSData *)getAudioData
{
    NSString *audioFilePath = [FileOperator getAudioFilePath:_currentBookId andFileIndex:_currentChapterIndex];
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

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    NSLog(@"audioPlayerDidFinishPlaying successfully");
    
    //Get chapter list
    NSMutableDictionary *userBook = [[DataSource sharedInstance] getUserBook];
    AudioBook *audioBook = [userBook objectForKey:_currentBookId];
    NSArray *chapters = audioBook.chapters;
    
    if (chapters && chapters.count >= _currentChapterIndex) {
        
        NSLog(@"Next chapter exist");
        
        BookChapter *nextChapter = [chapters objectAtIndex:_currentChapterIndex];
        nextChapter.lastSeekPoint = 0;
        [[DataSource sharedInstance] saveUserBook:userBook];
        
        NSLog(@"Next chapter will play from 0 time");
        
        [self startPlayerWithBook:_currentBookId andChapterIndex:_currentChapterIndex + 1];
        return;
    }
    
    NSLog(@"All book read complete. No more chapters.");
    
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
        
        NSDictionary *infoDic = @{PlayerNotificationTypeKey : [NSNumber numberWithInt:PlayerNotificationTypePlayingResumed],
                                  PlayerNotificationBookIdKey : _currentBookId,
                                  PlayerNotificationChapterIndexKey : [NSNumber numberWithInt:_currentChapterIndex]};
        
        [[NSNotificationCenter defaultCenter] postNotificationName:PLAYER_NOTIFICATION object:nil userInfo:infoDic];
    }
}


@end
