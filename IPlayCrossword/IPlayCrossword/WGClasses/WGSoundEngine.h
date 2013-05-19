//
//  WGSoundEngine.h
//  Classes
//
//  Created by ZYJ on 13-2-5.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
@interface WGSoundEngine : NSObject {
    
}
void WGPlayBGMusic(NSString *name_);
BOOL isWGBGMusicPlaying();
void WGPauseBGMusic();
void WGResumeBGMusic();
void WGStopBGMusic();
void WGPlaySound(NSString *name_);
void WGPlayShortSound(NSString *name_);
void WGPreLoadSound(NSString *name_);
-(void) WGPreLoadSoundWithNames:(NSString *)name, ...;

@end
