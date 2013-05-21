//
//  TheStaticGameLayer.h
//  iPlayCrossWord
//
//  Created by 丝瓜&冬瓜 on 13-4-29.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WGClasses/WGCocos2d.h"
#import "AnswerInterface.h"
#import "MenuLayer.h"

@interface TheStaticGameLayer : WGLayer<AnswerDelegate,menuLayerDelegate> {
    
}
@property (nonatomic,retain) NSMutableDictionary *plistAllWords;
@property (nonatomic,retain) AnswerInterface *answerInterface;
+(id )sceneAddWithInde:(int )index;
+(void )unShareTheStaticGameLayer;
@end
