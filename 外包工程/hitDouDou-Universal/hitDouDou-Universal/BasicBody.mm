//
//  BasicBody.m
//  hitDouDou
//
//  Created by YJ Z on 12-9-12.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BasicBody.h"
#import "EmptySprite.h"
#import "CreateFixture.h"
#import "GameLayer.h"

@interface BasicBody()
@property (nonatomic,assign) b2World *world;
@property (nonatomic,assign) b2Body *groundBody;
@property (nonatomic,assign) GameLayer *node;
@end

@implementation BasicBody
@synthesize world = _world;
@synthesize groundBody = _groundBody;
@synthesize node = _node;
@synthesize spriteContains = _spriteContains;
@synthesize curExistBall = _curExistBall;
@synthesize gameStartContains  = _gameStartContains;

static b2World* world_;
static b2Body*  groundBody_;
static GameLayer*  node_;

- (NSMutableArray *)spriteContains{
    if (!_spriteContains) {
        _spriteContains = [[NSMutableArray alloc] initWithCapacity:6];
    }
    return _spriteContains;
}
- (NSMutableArray *)curExistBall{
    if (!_curExistBall) {
        _curExistBall = [[NSMutableArray alloc] init];
    }
    return _curExistBall;
}
- (NSMutableArray *)gameStartContains{
    if (!_gameStartContains) {
        _gameStartContains = [[NSMutableArray alloc] init];
        [_gameStartContains removeAllObjects];
    }
    if (_gameStartContains.count>0) {
        [_gameStartContains removeAllObjects];
    }
    Data_Level lv = GetCurrentLevelData();
    for (int i = 0; i < lv.tierCount*(lv.tierCount+1)/2*6; i++) {
        [_gameStartContains addObject:allEmptySp[i]];
    }

    return _gameStartContains;
}
+ (id)createBasicBody:(NSString *)filename 
         physicsWorld:(b2World *)world 
               ground:(b2Body *)groundBody
          partentNode:(GameLayer *)node{
    world_ = world;
    groundBody_ = groundBody;
    node_ = node;
    return [[[self alloc] initWithSpriteFrameName:filename] autorelease];
}
- (void)initPhysics{
    b2BodyDef basicDef;
    basicDef.type = b2_dynamicBody;
    basicDef.linearDamping = 0;
    basicDef.angularDamping = PhysicsAngularDamping;
    basicDef.position.Set(self.position.x/PTM_RATIO, self.position.y/PTM_RATIO);
    self.physicsBody = self.world -> CreateBody(&basicDef);
   
    b2PolygonShape shape;
    //row 1, col 1
    int num = 6;
    b2Vec2 verts[] = {
        b2Vec2(-RADIUS/2 / PTM_RATIO,  RADIUS/2*sqrtf(3) / PTM_RATIO),
        b2Vec2(  -RADIUS / PTM_RATIO,                0.f / PTM_RATIO),
        b2Vec2(-RADIUS/2 / PTM_RATIO, -RADIUS/2*sqrtf(3) / PTM_RATIO),
        b2Vec2( RADIUS/2 / PTM_RATIO, -RADIUS/2*sqrtf(3) / PTM_RATIO),
        b2Vec2(   RADIUS / PTM_RATIO,                0.f / PTM_RATIO),
        b2Vec2( RADIUS/2 / PTM_RATIO,  RADIUS/2*sqrtf(3) / PTM_RATIO),
    };
    shape.Set(verts, num);
    
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &shape;
    fixtureDef.density = PhysicsDensity;
    fixtureDef.friction = PhysicsFriction;
    fixtureDef.userData = self;
    fixtureDef.filter.categoryBits = 0x0002;
    self.physicsBody->CreateFixture(&fixtureDef);
        
    b2RevoluteJointDef jointDef;
    jointDef.Initialize(self.groundBody, self.physicsBody, self.physicsBody->GetWorldCenter());
    jointDef.collideConnected = YES;
    b2RevoluteJoint *joint = NULL;
    joint = (b2RevoluteJoint *)self.world->CreateJoint(&jointDef); 
}
- (void)gameStart:(GameLayer *)node{
    for (EmptySprite *sp in self.gameStartContains) {
        CGPoint worldPos = [self convertToWorldSpace:sp.position];
        
        CGPoint p1 = sp.orgPosition;
        b2Vec2 relativelyV = [self CGPointConvertTob2Vec2:ccp(p1.x-self.contentSize.width/2, p1.y-self.contentSize.height/2)];
                
        int flg  = arc4random()%self.node.currentLV.ballTotalNumber+1;
        CreateFixture *fixtureSp = [CreateFixture initFixture:relativelyV withUserDataFlg:flg body:self.physicsBody];
        [node.batchNode addChild:fixtureSp z:-1];
        fixtureSp.position = worldPos;
        fixtureSp.chainedSprite = sp;
        sp.didPhysicsExist = YES;
        
        sp.flg = flg;
        
        sp.fixtureSp = (NSObject *)fixtureSp;
        
        [self.curExistBall addObject:sp];
        
    }
}
- (void)setBodyMasscenter{
    b2Vec2 b_ = self.physicsBody->GetLocalPoint(self.physicsBody->GetPosition());
    b2MassData data;
//    data.I = 0;
    data.I = self.physicsBody->GetInertia();
    data.mass = self.physicsBody->GetMass();
    data.center = b_;
    self.physicsBody->SetMassData(&data);
}
- (id)initWithSpriteFrameName:(NSString *)spriteFrameName{
    if (self == [super initWithSpriteFrameName:spriteFrameName]) {
        
        CGSize s = [[CCDirector sharedDirector] winSize];
        
        self.world = world_;
        self.groundBody = groundBody_;
        self.node = node_;
        
        self.position = ccp(s.width/2,s.height/2);
        [self.node.batchNode addChild:self z:0];
                
        [self initPhysics];
        
        [self initSprites];
        
        [self spritesSetContains];
    }
    return self;
}
- (void)initSprites{
//    float R = 20;
    
    spriteTagIndex = 0;
    allEmptySp = [[NSMutableArray alloc]init];
    [allEmptySp removeAllObjects];
    
    for (int i = 1; i < 15; i++) {
        for (int j = 0; j < 6; j++) {
            CGPoint p1 = [self getVertex:j];
            p1 = ccp(p1.x * i * 2 * RADIUS + self.contentSize.width/2, p1.y * i * 2 *  RADIUS + self.contentSize.height/2);
            
            CGPoint p2 = [self getVertex:(j+1)%6];
            p2 = ccp(p2.x * i * 2 *  RADIUS + self.contentSize.width/2, p2.y * i * 2 *  RADIUS + self.contentSize.height/2);
            
            for (int k = 0; k < i; k++) {
                CGPoint p = ccpAdd(p1, ccpMult(ccpSub(p2, p1), k/(float)i));
                [self a:p withTag:spriteTagIndex++];
            }
            
        }
    }
}

- (void)spritesSetContains{
//    float R = 20;
    for (EmptySprite *sp in allEmptySp) {
        for (int i = 0; i < 6; i++) {
            CGPoint p = [self getVertex:i];
            p = ccp(p.x * 2 * RADIUS + sp.position.x, p.y * 2 * RADIUS+ sp.position.y);
            for (EmptySprite *sp_ in allEmptySp) {
                
                if (CGRectContainsPoint(CGRectMake(sp_.position.x-2, sp_.position.y-2, 4, 4), p)) {//4为一个小的 有效范围
                    [sp.spriteContains addObject:sp_];

                    break;
                }
            }
            
        }

    }

}
- (void )a:(CGPoint )p withTag:(int )tagIndex{//记录 self的包含 及  游戏初始化状态的包含
    EmptySprite *sp = [EmptySprite initEmptySprite:p];

    sp.tag = tagIndex;
    [allEmptySp addObject:sp];
    
    if (tagIndex >-1 && tagIndex < 6) {
        [self.spriteContains addObject:sp];
    }

    
}
- (CGPoint )getVertex:(int )j{
    CGPoint p;
        
    switch (j) {
        case 0:
            p = ccp(-.5, sqrtf(3.0)/2.0);
            break;
        case 1:
            p = ccp(.5, sqrtf(3.0)/2.0);
            break;
        case 2:
            p = ccp(1, 0);
            break;
        case 3:
            p = ccp(.5, -sqrtf(3.0)/2.0);
            break;
        case 4:
            p = ccp(-.5, -sqrtf(3.0)/2.0);
            break;
        case 5:
            p = ccp(-1, 0);
            break;
        default:
            break;
    }
    return p;
}

- (void)dealloc{
    
    [_spriteContains release];
    _spriteContains = nil;
    
    [_curExistBall release];
    _curExistBall = nil;
    
    [_gameStartContains release];
    _gameStartContains = nil;
    
    [allEmptySp release];
    allEmptySp = nil;
    
    [super dealloc];
}
@end
