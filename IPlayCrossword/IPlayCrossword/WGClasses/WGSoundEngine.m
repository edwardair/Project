//
//  WGSoundEngine.m
//  Classes
//
//  Created by ZYJ on 13-2-5.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "WGSoundEngine.h"

static NSNumber *soundId;

@implementation WGSoundEngine

#pragma mark 系统类
#pragma mark *****************************
//播放音效类
//背景音
void WGPlayBGMusic(NSString *name_){
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:name_];
}
BOOL isWGBGMusicPlaying(){
    return [[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying];
}
void WGPauseBGMusic(){
    [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
}
void WGResumeBGMusic(){
    [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
}
void WGStopBGMusic(){
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

//音效音
void WGPlaySound(NSString *name_){//name_ == nil 时 停止声音
    [[SimpleAudioEngine sharedEngine] stopEffect:(ALuint)soundId];
    
    if (name_) {
        soundId = (NSNumber *)[[SimpleAudioEngine sharedEngine] playEffect:name_];
    }
}
void WGPlayShortSound(NSString *name_){
    [[SimpleAudioEngine sharedEngine] playEffect:name_];
}
void WGPreLoadSound(NSString *name_){//预加载声音
    [[SimpleAudioEngine sharedEngine] preloadEffect:name_];
}
//一次性预加载声音
-(void) WGPreLoadSoundWithNames:(NSString *)name, ...{
    va_list args;
    va_start(args, name);
    [self WGPreLoadSounds:name vaList:args];
    va_end(args);
    
}
-(void) WGPreLoadSounds: (NSString *) name vaList: (va_list) args
{
	if( name ) {
		NSString *i = va_arg(args, NSString *);
		while(i) {
            WGPreLoadSound(i);
			i = va_arg(args, NSString *);
		}
	}
}
#pragma mark *****************************

@end
