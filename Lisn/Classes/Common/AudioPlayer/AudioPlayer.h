//
//  AudioPlayer.h
//  Created by Md Farhad Hossain,XOR Co. Ltd. on 3/29/16.
//  Copyright © 2016 XOR Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface AudioPlayer : NSObject

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (nonatomic, strong) NSString *currentBookId;
@property (nonatomic, assign) int currentChapterIndex;

+ (AudioPlayer *)getSharedInstance;

- (BOOL)playAudio;

- (void)pauseAudio;

- (void)stopAudio;

- (BOOL)isPlaying;

- (void)seekTo:(int)timeGap;
- (void)seekToTime:(int)newTime;
- (void)startPlayerWithBook:(NSString *)bookId andChapterIndex:(int)chapterIndex;

@end