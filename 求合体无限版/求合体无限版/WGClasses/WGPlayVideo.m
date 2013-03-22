//
//  playVideo.m
//  Ten_Snow
//
//  Created by YJ Z on 12-8-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WGPlayVideo.h"
#import "cocos2d.h" 
#import "MediaPlayer/MediaPlayer.h"
#import "AppDelegate.h"
#import "SimpleAudioEngine.h"
@interface WGPlayVideo()
@property (nonatomic, retain) UIView *bootView;
@property (nonatomic, assign) CGPoint centerPosition;
@property (nonatomic, retain) MPMoviePlayerController *moviePlayer;
@property (nonatomic, retain) UIButton *closeButton;
@property (nonatomic, retain) UIButton *replayButton;
@property (nonatomic, retain) UIImageView *coverImageView;
@property (nonatomic, retain) UIImageView *animationView;
@property (nonatomic, retain) UIImageView *textView;
@property (nonatomic, assign) BOOL isHandClose;
@property (nonatomic, assign) NSString *mp4FileName;
@property (nonatomic, assign) NSString *coverFileName;
@property (nonatomic, assign) NSString *textFileName;
@property (nonatomic, assign) NSString *aniFileName;
@property (nonatomic, assign) NSNumber *soundId;
@end


@implementation WGPlayVideo
@synthesize moviePlayer = _moviePlayer;
@synthesize closeButton = _closeButton;
@synthesize replayButton = _replayButton;
@synthesize coverImageView = _coverImageView;
@synthesize animationView = _animationView;
@synthesize textView = _textView;
@synthesize centerPosition = _centerPosition;
@synthesize bootView = _bootView;
@synthesize isHandClose = _isHandClose;
@synthesize mp4FileName = _mp4FileName,coverFileName = _coverFileName,textFileName = _textFileName,aniFileName = _aniFileName;
@synthesize soundId = _soundId;
//@synthesize soundName = _soundName;


static NSString *soundName = nil;

#pragma mark-
#pragma mark setAndGet
+(void)setSoundName:(NSString *)name{
    soundName = name;
}
- (void) updateOrientationWithOrientation: (UIDeviceOrientation) newOrientation
{
	if (!_bootView)
		return;
		
	UIDeviceOrientation orientation = newOrientation;
	
	if (orientation == UIDeviceOrientationLandscapeRight)		
		[ _bootView setTransform: CGAffineTransformMakeRotation(-M_PI_2) ];
	
	if (orientation == UIDeviceOrientationLandscapeLeft)
		[ _bootView setTransform: CGAffineTransformMakeRotation(M_PI_2) ];
}

- (UIView *)bootView{
    if (!_bootView){
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];	
        _bootView = [[UIView alloc]initWithFrame:CGRectMake(-128, 128, keyWindow.frame.size.height, keyWindow.frame.size.width)];
        [keyWindow addSubview:_bootView];

        [self updateOrientationWithOrientation: [[UIApplication sharedApplication] statusBarOrientation]];

    }
    return _bootView;
}
- (CGPoint )centerPosition{
    CGSize size = [[CCDirector sharedDirector] winSize];
    _centerPosition = ccp(size.width/2, size.height/2);
    return _centerPosition;
}
//- (MPMoviePlayerController *)moviePlayer{
//    if (!_moviePlayer) {
//        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:_mp4FileName ofType:@"mp4"]];
//        _moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
//        
////        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
////        delegate.moviePlayerDelegate = _moviePlayer;
//    }
//    return _moviePlayer;
//}
- (UIImageView *)coverImageView{
    if (!_coverImageView) {
        if (self.coverFileName) {
            _coverImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_coverFileName]];
            _coverImageView.frame = CGRectMake(0, 0, 1024, 768);
        }
    }
    return _coverImageView;
}
- (UIImageView *)textView{
    if (!_textView) {
        if (self.textFileName) {
            _textView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:_textFileName]];
            CGSize textViwContent = _textView.frame.size;
            _textView.frame = CGRectMake(self.centerPosition.x-textViwContent.width/2, self.centerPosition.y-textViwContent.height/2-150, textViwContent.width, textViwContent.height);
        }
    }
    return _textView;
}
- (UIImageView *)animationView{
    if (!_animationView) {
        if (self.aniFileName) {
            _animationView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
        }
    }
    return _animationView;
}
- (UIButton *)closeButton{
    if (!_closeButton) {
        UIButton *button = [[UIButton alloc] init];
        button.frame = CGRectMake(915, 45, 40, 40);
        [_bootView addSubview:button];
        _closeButton = button;
    }
    NSLog(@"closeButton:::%d",_closeButton.retainCount);

    return _closeButton;
}
- (UIButton *)replayButton{
    if (!_replayButton) {
        UIButton *button = [[UIButton alloc] init];
        [button setImage:[UIImage imageNamed:@"replay.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"replay_.png"] forState:UIControlStateHighlighted];
        button.frame = CGRectMake(self.centerPosition.x - button.imageView.image.size.width/2, self.centerPosition.y-65, button.imageView.image.size.width, button.imageView.image.size.height);
        [_bootView addSubview:button];

        _replayButton = button;
    }
    return _replayButton;
}
#pragma mark -
#pragma mark 视频播放器控制
-(void)Finish{
    [self release];

    [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];

    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(playSound) object:self];
    
    if (soundName) {
        [[SimpleAudioEngine sharedEngine] stopEffect:(ALuint)self.soundId];
        soundName = nil;
    }

    self.isHandClose = YES;
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayPlayMovie) object:self];
    NSLog(@"视屏立即结束");
    
    if (_animationView != nil) {
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(removeAnimationView) object:self];
        [self removeAnimationView];
    }
    if (_coverImageView!=nil) {
        [_coverImageView removeFromSuperview];
        [_coverImageView release];
        _coverImageView = nil;
    }
    NSLog(@"closeButton:::%d",_closeButton.retainCount);

    if (_closeButton !=nil) {
        [_closeButton removeFromSuperview];
        [_closeButton release];
        _closeButton = nil;
        
    }
    NSLog(@"closeButton:::%d",_closeButton.retainCount);

    if (_replayButton !=nil) {
        [_replayButton removeFromSuperview];
        [_replayButton release];
        _replayButton = nil;
    }
    
    if (_moviePlayer)
        [_moviePlayer stop];
    
    if ( _moviePlayer )
    {
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:MPMoviePlayerPlaybackDidFinishNotification
                                                      object:_moviePlayer];
        
        // Release the movie instance created in playMovieAtURL:
        if ([_moviePlayer respondsToSelector:@selector(view)])
        {
            [[_moviePlayer view] removeFromSuperview];
        }
        [_moviePlayer release];   
        _moviePlayer = nil;
        
    }
    
    [_bootView removeFromSuperview];
    [_bootView release];
    _bootView = nil;

}

- (void)delayPlayMovie{
    if (_moviePlayer) {
        [_moviePlayer play];

    }
}

-(void)replay{
    if (_replayButton !=nil) {
        [_replayButton removeFromSuperview];
        [_replayButton release];
        _replayButton = nil;
        
    }
    [self delayPlayMovie];
}


-(void)moviePlayBackDidFinish:(NSNotification *)notification {
    NSLog(@"视频播放结束");
    
    if (!self.isHandClose) {
        [self.replayButton addTarget:self action:@selector(replay) forControlEvents:UIControlEventTouchUpInside];
    }
}
- (void)removeAnimationView{
    [_animationView stopAnimating];
    [_animationView removeFromSuperview];
    [_animationView release];
    _animationView = nil;
    if (_textView != nil) {
        [_textView removeFromSuperview];
        [_textView release];
        _textView = nil;
    }
}
- (void)playSound{
   self.soundId = (NSNumber *)[[SimpleAudioEngine sharedEngine] playEffect:soundName];
}
+(void)playMovie:(NSString *)mp4FileName_
           kuang:(NSString *)coverFileName_
            text:(NSString *)textFileName_
       animation:(NSString *)aniFileName_{
    [[[self alloc] init] playMovie:mp4FileName_ kuang:coverFileName_ text:textFileName_ animation:aniFileName_];
}
- (void)playMovie:(NSString *)mp4FileName_
            kuang:(NSString *)coverFileName_
             text:(NSString *)textFileName_
        animation:(NSString *)aniFileName_
{
//    [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];

    self.isHandClose = NO;
    
    self.mp4FileName = mp4FileName_;
    self.coverFileName = coverFileName_;
    self.textFileName = textFileName_;
    self.aniFileName = aniFileName_;
    
//    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];	
//
//    NSLog(@"%f,%f,%f,%f",keyWindow.frame.origin.x,keyWindow.frame.origin.y,keyWindow.frame.size.width,keyWindow.frame.size.height);
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:_mp4FileName ofType:@"mp4"]];
    _moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:) 
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:_moviePlayer];
    
    if ([_moviePlayer respondsToSelector:@selector(setFullscreen:animated:)]) {

		[_moviePlayer setControlStyle:MPMovieControlStyleNone];
		_moviePlayer.shouldAutoplay = NO;
		_moviePlayer.repeatMode = MPMovieRepeatModeNone;
        [_moviePlayer setScalingMode:MPMovieScalingModeAspectFill];
        [_moviePlayer.view setUserInteractionEnabled:NO];
        
        [self.bootView addSubview:_moviePlayer.view];
        [_bootView sendSubviewToBack:_moviePlayer.view];
        
        if (!self.coverImageView) {//无遮罩情况，全屏视频
            _moviePlayer.view.frame = CGRectMake(0, 0, 1024,768);//816,61
            
        }else{
            _moviePlayer.view.frame = CGRectMake(self.centerPosition.x-848/2.0, _centerPosition.y-620/2.0, 848,620);//宽高视视频大小而定//模拟器坐标 y: _centerPosition.y+70
            [_bootView addSubview:_coverImageView];
        }
        
        [self.closeButton addTarget:self action:@selector(Finish) forControlEvents:UIControlEventTouchUpInside];
        
        if (_textFileName) {
            [_bootView addSubview:self.textView];
        }
        
        NSString *string = nil;
        int fps = 0;
        float aniTime = 0.0f;
        
        if (_aniFileName) {
            [_bootView addSubview:self.animationView];
            
            if ([aniFileName_ isEqualToString:@"PredCurtain_001.png"]) {
                string = @"PredCurtain_";
                fps = 55;
                aniTime = fps/12.0;
            }
            else{
                string = @"PblueCurtain_";
                fps = 8;
                aniTime = fps/12.0;
            }
            NSMutableArray *images = [[NSMutableArray alloc] initWithCapacity:fps];
            for (int i = 1; i<=fps; i++) {
                NSString *imageName;
                if (fps==55) {
                    imageName = [NSString stringWithFormat:@"%@%03d.png",string,i];
                }else
                    imageName = [NSString stringWithFormat:@"%@%03d.png",string,i];
                UIImage *image = [UIImage imageNamed:imageName];
                [images addObject:image];
            }
            
            _animationView.animationImages = images;
            [images release];
            
            _animationView.animationDuration = aniTime;
            _animationView.animationRepeatCount = 1;
            [_animationView startAnimating];
            [self performSelector:@selector(removeAnimationView) withObject:self afterDelay:aniTime];
        }
        
        if (soundName) {
            [[SimpleAudioEngine sharedEngine] preloadEffect:soundName];
            [self performSelector:@selector(playSound) withObject:self afterDelay:2.5f];
        }

        [self performSelector:@selector(delayPlayMovie) withObject:self afterDelay:aniTime];
	}
}

- (void)dealloc{
    self.closeButton = nil;
    self.bootView = nil;
    self.moviePlayer = nil;
    self.replayButton = nil;
    self.coverImageView = nil;
    self.animationView = nil;
    self.textView = nil;
    self = nil;
    [super dealloc];
}
@end
