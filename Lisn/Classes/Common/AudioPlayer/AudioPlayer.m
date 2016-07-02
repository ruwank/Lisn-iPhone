//
//  AudioPlayer.m

//  Created by Md Farhad Hossain,XOR Co. Ltd. on 3/29/16.
//  Copyright © 2016 XOR Co. Ltd. All rights reserved.
//

#import "AudioPlayer.h"

@interface AudioPlayer()

@end

@implementation AudioPlayer

@synthesize  audioDelegate;

- (void)initPlayer:(NSString*) audioFile fileExtension:(NSString*)fileExtension
{
    NSURL *audioFileLocationURL = [[NSBundle mainBundle] URLForResource:audioFile withExtension:fileExtension];
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFileLocationURL error:&error];
    self.audioPlayer.delegate = self;
}
-(void)playAudioFile:(NSString*)filePath{
    if(self.audioPlayer ){
        
    }
}
/*
 * Simply fire the play Event
 */
- (void)playAudio {
    [self.audioPlayer prepareToPlay];
    [self.audioPlayer play];
}

/*
 * Simply fire the pause Event
 */
- (void)pauseAudio {
    [self.audioPlayer pause];
}
/*
 * Simply fire the stop Event
 */
- (void)stopAudio{
    [self.audioPlayer stop];
}

/*
 * Simply check audio is currently playing or not
 */
- (BOOL)isPlaying {
    return self.audioPlayer.playing;
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    //NSLog(@"finished");
    [self.audioDelegate performSelector:@selector(audioFinishPlaying)];
}


@end
