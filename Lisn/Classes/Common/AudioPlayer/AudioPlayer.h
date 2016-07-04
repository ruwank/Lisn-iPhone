//
//  AudioPlayer.h
//  Created by Md Farhad Hossain,XOR Co. Ltd. on 3/29/16.
//  Copyright © 2016 XOR Co. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


@interface AudioPlayer : NSObject

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

+ (AudioPlayer *)getSharedInstance;

- (BOOL)setAudioData:(NSData *)audioData;

- (BOOL)playAudio;

- (void)pauseAudio;

- (void)stopAudio;

- (BOOL)isPlaying;

@end