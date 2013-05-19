//
//  CreateFixture.h
//  hitDouDou
//
//  Created by YJ Z on 12-9-19.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "Sprite.h"
#import "EmptySprite.h"

#define DeleteEffectWithJump 1
#define DeleteEffectWithBoom 2
#define DeleteEffectWithScatter 3

@protocol CeateFixtureDelegate;

@interface CreateFixture : Sprite {
    id<CeateFixtureDelegate> fixtureDelegate;
}

@property (nonatomic,assign) int flg;
@property (nonatomic,assign) b2Fixture *fixtureDef;
@property (nonatomic,retain) EmptySprite *chainedSprite;
@property (nonatomic,assign) id<CeateFixtureDelegate> fixtureDelegate;
+ (id)initFixture:(b2Vec2)b2 withUserDataFlg:(int )flg body:(b2Body *)basicBody;
- (void)removeWithType:(int )type;
@end

@protocol CeateFixtureDelegate
    
- (void)checkBasic_curExistBall:(EmptySprite *)sp;

@end