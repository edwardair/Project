//
//  creatNewBall.m
//  打豆豆
//
//  Created by Wei Haoyu on 12-5-21.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "creatBallSprite.h"
#import "GameLayer.h"
#define PTM_RATIO 32.0
#define BallCreateStartPosition [DEVICE isEqualToString:@"-iPad"]?ccp(72, 109):ccp(30,46)
//@interface creatBallSprite(){
//    
//}
//@property (nonatomic,retain) GameLayer *layerNode;
//@end

@implementation creatBallSprite
@synthesize kBallEnum = _kBallEnum;
@synthesize isLocked = _isLocked;
@synthesize world = _world;
//@synthesize layerNode = _layerNode;
@synthesize didSticked = _didSticked;
@synthesize isFlaged = _isFlaged;
@synthesize removeEffect = _removeEffect;

static b2World* world_;
static GameLayer*  node_;
static int color;

+ (id)createBall:(GameLayer *)node withWorld:(b2World *)world{
    
    int random = arc4random()%node.currentLV.ballTotalNumber+1;
    color = random;
    world_ = world;
    node_ = node;

    return [[[self alloc]initWithSpriteFrameName:[NSString stringWithFormat:@"BALL%d.png",random]] autorelease];
}

- (id)initWithSpriteFrameName:(NSString *)spriteFrameName{
    if (self == [super initWithSpriteFrameName:spriteFrameName]) {

        self.kBallEnum = color;
        self.didSticked = NO;
        self.isFlaged = NO;
        self.removeEffect = -1;
        
        self.position = BallCreateStartPosition;
        [node_.launch addChild:self z:1];
        
    }
    return self;
}

- (void)creatPhysics{
    
    CGPoint p = [node_.launch convertToWorldSpace:self.position];
    
    b2BodyDef bodyDef;
    bodyDef.type=b2_dynamicBody;
    bodyDef.position.Set(p.x/PTM_RATIO, p.y/PTM_RATIO);
    bodyDef.userData = self;
    
    self.world = world_;
    
    self.physicsBody = self.world -> CreateBody(&bodyDef);
    
    b2CircleShape circle;
    circle.m_radius = RADIUS/PTM_RATIO;
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &circle;
    fixtureDef.density = PhysicsDensity*5;
    fixtureDef.friction = 0;
    fixtureDef.restitution = 1.f;
    fixtureDef.filter.categoryBits = 0x0001;
    fixtureDef.filter.maskBits = 0x0002;
    self.physicsBody -> CreateFixture(&fixtureDef);
        
}
- (void)removeWithType:(int )type{
    switch (type) {
        case UnEffectCrashType:
            [self runAction:[CCSequence actions:
                                   [CCEaseSineInOut actionWithAction:[CCMoveBy actionWithDuration:.1f position:ccp(0, 5)]],
                                   [CCSpawn actions:[CCEaseSineIn actionWithAction:[CCMoveBy actionWithDuration:0.5f position:ccp(0, -70)]],[CCFadeOut actionWithDuration:.5f], nil],
                                   [CCCallFuncN actionWithTarget:self selector:@selector(removeSprite)], nil]];

            break;
        case EffectCrashType:
            [self runAction:[CCSequence actions:
                             [CCEaseSineInOut actionWithAction:[CCMoveBy actionWithDuration:.1f position:ccp(0, 5)]],
                             [CCSpawn actions:[CCEaseSineIn actionWithAction:[CCMoveBy actionWithDuration:0.5f position:ccp(0, -70)]],[CCFadeOut actionWithDuration:.5f], nil],
                             [CCCallFuncN actionWithTarget:self selector:@selector(removeSprite)], nil]];
            break;
            case removeWithNonEffect:
            [self removeSprite];
            break;
        default:
            break;
    }
}
- (void)removeSprite{
    [self removeFromParentAndCleanup:YES];
}
- (void)dealloc{
    [super dealloc];
}
@end


