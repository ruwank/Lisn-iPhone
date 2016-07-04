//
//  PlayerBarView.m
//  Lisn
//
//  Created by A M S Sumanasooriya on 7/4/16.
//  Copyright © 2016 Lisn. All rights reserved.
//

#import "PlayerBarView.h"
#import "AppConstant.h"
#import "AudioPlayer.h"
#import "AppUtils.h"

@interface PlayerBarView()

@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UISlider *slider;
@property (strong, nonatomic) UILabel *currentTimeLbl;
@property (strong, nonatomic) UILabel *totalTimeLbl;

@property (nonatomic, strong) NSTimer *timer;
@property (assign) int totalTime;
@property (assign) int currentTime;

@end

static PlayerBarView *instance;
static BOOL visible;

@implementation PlayerBarView

+ (void)showView
{
    if (!visible) {
        PlayerBarView *playerBar = [PlayerBarView getInstance];
        [[AppUtils appDelegate].window addSubview:playerBar];
        [playerBar viewDidLoad];
    }
    
    visible = YES;
}

+ (void)hideView
{
    if (visible) {
        [[PlayerBarView getInstance] removeFromSuperview];
    }
    
    visible = NO;
}

+ (BOOL)isVisible
{
    return visible;
}

+ (instancetype)getInstance
{
    if (instance == nil) {
        instance = [[PlayerBarView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
    
    return instance;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, SCREEN_HEIGHT-60, SCREEN_WIDTH, 60)];
    if (self) {
        self.backgroundColor = RGBA(238, 159, 31, 1);
        
        float xGap = 10;
        
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _playBtn.frame = CGRectMake(xGap, 10, 40, 40);
        [_playBtn setImage:[UIImage imageNamed:@"btn_play_start"] forState:UIControlStateNormal];
        [_playBtn setImage:[UIImage imageNamed:@"btn_play_pause"] forState:UIControlStateSelected];
        [_playBtn addTarget:self action:@selector(playButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_playBtn];
        
        _slider = [[UISlider alloc] initWithFrame:CGRectMake(40 + xGap*2, 15, SCREEN_WIDTH - (40 + xGap*3), 30)];
        _slider.backgroundColor = [UIColor clearColor];
        _slider.userInteractionEnabled = NO;
        _slider.value = 0.0f;
        _slider.minimumValue = 0.0f;
        _slider.maximumValue = 1.0f;
        
        [self addSubview:_slider];
        
        _totalTimeLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - xGap - 100, 60-21, 100, 21)];
        _totalTimeLbl.backgroundColor = [UIColor clearColor];
        _totalTimeLbl.textColor = [UIColor whiteColor];
        _totalTimeLbl.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        _totalTimeLbl.textAlignment = NSTextAlignmentRight;
        
        [self addSubview:_totalTimeLbl];
        
        _currentTimeLbl = [[UILabel alloc] initWithFrame:CGRectMake(40 + xGap*2, 60-21, 100, 21)];
        _currentTimeLbl.backgroundColor = [UIColor clearColor];
        _currentTimeLbl.textColor = [UIColor whiteColor];
        _currentTimeLbl.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        _currentTimeLbl.textAlignment = NSTextAlignmentLeft;
        
        [self addSubview:_currentTimeLbl];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerNotificationReceived:) name:PLAYER_NOTIFICATION object:nil];
    }
    
    return self;
}

- (void)viewDidLoad
{
    AudioPlayer *player = [AudioPlayer getSharedInstance];
    
    if ([player isPlaying]) {
        [self timerFired:nil];
        [self startTimer];
        _playBtn.selected = YES;
    } else {
        [self removeFromSuperview];
    }
}

- (void)dealloc
{
    [self invalidateTimer];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"dealloc : %@",[self description]);
}

- (void)playButtonTapped
{
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
    
    [self removeFromSuperview];
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
        [self pausePlaying];
    }else if (number.intValue == PlayerNotificationTypePlayingResumed) {
        [self startPlaying];
    }
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

@end
