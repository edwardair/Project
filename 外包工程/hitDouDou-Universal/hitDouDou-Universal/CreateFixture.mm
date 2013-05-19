//
//  CreateFixture.m
//  hitDouDou
//
//  Created by YJ Z on 12-9-19.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "CreateFixture.h"
#import "c2dMoveWithGravity.h"

@implementation CreateFixture
@synthesize flg = _flg;
@synthesize fixtureDef = _fixtureDef;
@synthesize chainedSprite = _chainedSprite;
@synthesize fixtureDelegate;

static b2Vec2 relativelyPos_;
static int flg_;
static b2Body *basicBody_;

+ (id)initFixture:(b2Vec2)b2 withUserDataFlg:(int )flg body:(b2Body *)basicBody{
    
    relativelyPos_ = b2;
    flg_ = flg;
    basicBody_ = basicBody;
    return [[[self alloc] initWithSpriteFrameName:[NSString stringWithFormat:@"BALL%d.png",flg]] autorelease];
}
- (void)initPhysics{
    self.flg = flg_;
    
    b2CircleShape circle;
    circle.m_radius = RADIUS/PTM_RATIO;
    circle.m_p = relativelyPos_;
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &circle;
    fixtureDef.density = PhysicsDensity;
    fixtureDef.friction = PhysicsFriction;
    fixtureDef.userData = self;
    fixtureDef.filter.categoryBits = 0x0002;
   self.fixtureDef = basicBody_ -> CreateFixture(&fixtureDef);
}
- (id)initWithSpriteFrameName:(NSString *)spriteFrameName{
    if (self == [super initWithSpriteFrameName:spriteFrameName]) {
        self.position = [self b2Vec2ConvertToCGPoint:relativelyPos_];
                 
        [self initPhysics];
        
    }
    return self;
}
- (void)removeWithType:(int)type{
    switch (type) {
        case DeleteEffectWithJump:{
            id esInOut_Up = [CCEaseSineInOut actionWithAction:[CCMoveBy actionWithDuration:.1f position:ccp(0, 5)]];
            
            id esIn_Down = [CCEaseSineIn actionWithAction:[CCMoveBy actionWithDuration:0.5f position:ccp(0, -70)]];
            id fadeOut = [CCFadeOut actionWithDuration:.5f];
            id spa = [CCSpawn actions:esIn_Down,fadeOut, nil];
            
            id transmit = [CCCallFuncN actionWithTarget:self selector:@selector(removeSprite)];
            
            [self runAction:[CCSequence actions:
                             esInOut_Up,
                             spa,
                             transmit, nil]];
        }
            break;
            case DeleteEffectWithBoom:
            
            break;
        case DeleteEffectWithScatter:{
            
            CGSpeed s;
            float n = 10;
            s.x = CCRANDOM_0_1()*n-n/2.0;
            s.y = (float)(CCRANDOM_0_1()*10-10);
            float actionTime;
            actionTime = CCRANDOM_0_1() * .5 + 0.3f;
            
            id esMoveBy = [c2dMoveWithGravity actionWithDuration:actionTime speed:s withGravity:CGGravityMake(0, -10)];
            id fadeOut = [CCFadeOut actionWithDuration:actionTime];
            
            id spa = [CCSpawn actions:esMoveBy,fadeOut, nil];
            
            id transmit = [CCCallFuncN actionWithTarget:self selector:@selector(removeSprite)];
            
            [self runAction:[CCSequence actions:
                             spa,
                             transmit, nil]];
        }
            break;
        default:
            break;
    }

}
- (void)removeSprite{
    [self.fixtureDelegate checkBasic_curExistBall:self.chainedSprite];

    [self removeFromParentAndCleanup:YES];
}
- (void)dealloc{
    self.chainedSprite = nil;
    
    [super dealloc];
}
@end
