//
//  BasicBody.h
//  hitDouDou
//
//  Created by YJ Z on 12-9-12.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "Sprite.h"
#import "CreateFixture.h"

@interface BasicBody : Sprite {
    int spriteTagIndex;
    NSMutableArray *allEmptySp;
}
@property (nonatomic,retain) NSMutableArray *spriteContains;
@property (nonatomic,retain) NSMutableArray *curExistBall;
@property (nonatomic,retain) NSMutableArray *gameStartContains;

+ (id)createBasicBody:(NSString *)filename 
         physicsWorld:(b2World *)world 
               ground:(b2Body *)groundBody
          partentNode:(CCNode *)node;
- (void)gameStart:(CCNode *)node;
- (void)setBodyMasscenter;
@end
