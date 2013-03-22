//
//  HelloWorldLayer.h
//  反编译pvrccz文件
//
//  Created by YJ Z on 12-9-4.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//


#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "WGLayer.h"

@interface WGDecompilationPlist : WGLayer
{
}
+(void ) DecomplilationPlist:(NSString *)plistName;
+(CCRenderTexture *)drawSprite:(CCNode *)node OnRender:(CCRenderTexture *)render;
@end
