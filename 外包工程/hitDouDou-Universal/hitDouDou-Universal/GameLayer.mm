//
//  GameLayer.m
//  hitDouDou
//
//  Created by YJ Z on 12-9-10.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//
#import "GameLayer.h"
#import "AppDelegate.h"
#import "creatBallSprite.h"
#import "BasicBody.h"
#import "SimpleAudioEngine.h"
#import "InitPhysicsWorld.h"
#import "OpenRayCast.h"

#define kLOGOTag -100
#define kMusicControlTag -101
#define InitialStrength (([DEVICE isEqualToString:@"-iPhone"])? 20.f:40.f)
#define PunishStrength (([DEVICE isEqualToString:@"-iPhone"])? 15.f:25.f)
#define HighestScoreSize (([DEVICE isEqualToString:@"-iPhone"])? 15.f:30.f)
#define LifeTagIndex 10
#define BallOrgPosition (([DEVICE isEqualToString:@"-iPhone"])? ccp(30,21):ccp(71,53))

#define OPENRAYCAST 1//开启关闭无限折线

#ifndef OPENRAYCAST
#define UnEffectCrash 6
#else
#define UnEffectCrash 100
#endif

@interface GameLayer(){
    CGPoint touchTemp_;
    BOOL didUnEffectCrashed;
}
@property (nonatomic,retain) GameLabel *gameLabel;
@property (nonatomic,retain) NSMutableArray *ballShouldRemove;
@property (nonatomic,retain) NSMutableArray *fixtureShouldRemove;
@property (nonatomic,retain) NSMutableArray *goalPointArray;
@end;


static BOOL didGameFail;
@implementation GameLayer
@synthesize ballShouldRemove = _ballShouldRemove;
@synthesize fixtureShouldRemove = _fixtureShouldRemove;
@synthesize currentLV = _currentLV;
#pragma mark ---------
#pragma mark set And get 方法
-(NSMutableArray *)ballShouldRemove{
    if (!_ballShouldRemove) {
        _ballShouldRemove = [[NSMutableArray alloc]init];
        [_ballShouldRemove removeAllObjects];
    }
    return _ballShouldRemove;
}
-(NSMutableArray *)fixtureShouldRemove{
    if (!_fixtureShouldRemove) {
        _fixtureShouldRemove = [[NSMutableArray alloc]init];
        [_fixtureShouldRemove removeAllObjects];
    }
    return _fixtureShouldRemove;
}
- (Data_Level )currentLV{
    _currentLV = GetCurrentLevelData();
    return _currentLV;
}
- (NSMutableArray *)goalPointArray{
    if (!_goalPointArray) {
        _goalPointArray = [[NSMutableArray alloc]init];
    }
    return _goalPointArray;
}
- (void)setCurrentLV:(Data_Level)currentLV{
    [[NSUserDefaults standardUserDefaults]setInteger:currentLV.LV forKey:@"CurrentLV"];
}
- (void)setCurrentLevel:(int )lv_{
    Data_Level lv;
    lv.LV = lv_;
    [self setCurrentLV:lv];
}
- (void)addGoalPointToArray:(CGPoint )p_{
    //    NSLog(@"%f,%f",p_.x,p_.y);
    if (self.goalPointArray.count==0) {
        [self.goalPointArray addObject:[NSValue valueWithCGPoint:[_launch convertToWorldSpace:BallOrgPosition]]];
    }
    [self.goalPointArray addObject:[NSValue valueWithCGPoint:p_]];
}
- (CCSpriteFrameCache *)cache{
    if (!_cache) {
        _cache = [CCSpriteFrameCache sharedSpriteFrameCache];
    }
    return _cache;
}

#pragma mark ---------
#pragma mark 创建 basicSprite body joint
- (void)centerjointCreate{
    basicSprite = [BasicBody createBasicBody:@"BasicBall.png" physicsWorld:WORLD ground:GROUNDBODY partentNode:self];
    basicBody = basicSprite.physicsBody;
    
    [self gameReStart];
    
    [basicSprite setBodyMasscenter];
}
#pragma mark ---------
#pragma mark 开始游戏
- (void)gameFirstStart{
    [self createBall];
    [self addLabel];
    [self addLife];


    [self centerjointCreate];

    self.gameLabel.visible = YES;
    
    lifeShowCount = self.currentLV.lifeMax;

    [self resetlifeShow:lifeShowCount];
        
    basicBody->ApplyLinearImpulse(b2Vec2(0, [DEVICE isEqualToString:@"-iPhone"]?100:300), b2Vec2(0, RADIUS));

}
- (void)gameReStart{
    [basicSprite gameStart:self];
    for (EmptySprite *sp in basicSprite.curExistBall) {
        CreateFixture *sp_ = (CreateFixture *)sp.fixtureSp;
        sp_.fixtureDelegate = self;
    }
}
#pragma mark -----------
#pragma mark 创建 ball
- (creatBallSprite *)createBall{
    if (!isGamePunishing) {
        if (!nextBullet) {
            nextBullet = [creatBallSprite createBall:self withWorld:WORLD];
            ballNumber++;
        }
        
        curBullet = nextBullet;
        
        [self ballStartAction:curBullet];
        
        nextBullet = [creatBallSprite createBall:self withWorld:WORLD];
        
        ballNumber++;
        
        return curBullet;
    }else {
        ballNumber++;
        return [creatBallSprite createBall:self withWorld:WORLD];
    }
}
//泡泡 推出动作
- (void)ballStartAction:(creatBallSprite *)ball{
    [ball runAction:[CCSequence actions:
                     [CCSpawn actions:[CCMoveTo actionWithDuration:.5f position:BallOrgPosition],[CCScaleTo actionWithDuration:.5f scale:1.0f], nil],
                     [CCCallFuncN actionWithTarget:self selector:@selector(setTouchEnabled)],
                     nil]];//
}
- (void)setTouchEnabled{
    self.isTouchEnabled = YES;
}
#pragma mark -----------
#pragma mark 创建 basicBody 的夹具
- (CreateFixture *)createFixture:(b2Vec2)b2 withUserDataFlg:(int )flg body:(b2Body *)basicBody_{
   return [CreateFixture initFixture:b2 withUserDataFlg:flg body:basicBody_];
}
#pragma mark 移除BasicBody上的Fixture
//CreateFixture 的委托方法
- (void)checkBasic_curExistBall:(EmptySprite *)sp{
    [basicSprite.curExistBall removeObject:sp];
    
    if (basicSprite.curExistBall.count == 0) {
        [[NSUserDefaults standardUserDefaults]setInteger:(self.currentLV.LV+1) forKey:@"CurrentLV"];
        //        NSLog(@"%d",self.currentLV.LV);
        if (self.currentLV.LV==4) {//从3到4 有一个生命显示的过度
            lifeShowCount = self.currentLV.lifeMax;
            [self resetlifeShow:self.currentLV.lifeMax];
        }
        
        [self gameReStart];
        [self.gameLabel.labelPointRate setString:[NSString stringWithFormat:@"%d",self.currentLV.pointRate]];
//        [self.gameLabel.playerAppraise setString:[NSString stringWithFormat:@"%d",self.currentLV.LV]];
    }
}

- (void)removeFixture:(CreateFixture *)sprite withEmptySp:(EmptySprite *)empty{
    [self.gameLabel setLabelPoint:1];//1个泡泡分数
    
    b2Fixture *body = sprite.fixtureDef;
    if (body != NULL) {
        basicBody->DestroyFixture(body);
    }
    
    body = NULL;
    
    [basicSprite setBodyMasscenter];
    
    [sprite removeWithType:DeleteEffectWithScatter];
    
    empty.didPhysicsExist = NO;
    
    empty.flg = -1;
    
    empty.fixtureSp = nil;
}
//NSThread

#pragma mark -----------
#pragma mark 分数 比率 历史最高分
- (void)addLabel{
    self.gameLabel = [GameLabel node];
    [self addChild:self.gameLabel z:1];
    self.gameLabel.visible = NO;
}
#pragma mark ----------
#pragma mark  添加 生命
- (void)addLife{
    
    NSArray *array_Pos;
    if ([DEVICE isEqualToString:@"-iPad"])
        array_Pos = @[
        [NSValue valueWithCGPoint:ccp( 20, 133)],
        [NSValue valueWithCGPoint:ccp( 69, 144)],
        [NSValue valueWithCGPoint:ccp(123, 150)],
        [NSValue valueWithCGPoint:ccp(166, 147)],
        [NSValue valueWithCGPoint:ccp( 32,  73)],
        [NSValue valueWithCGPoint:ccp( 81,  60)],
        [NSValue valueWithCGPoint:ccp(133,  70)],
        [NSValue valueWithCGPoint:ccp(170,  98)] ];
    else
        array_Pos = @[
        [NSValue valueWithCGPoint:ccp( 22, 147)],
        [NSValue valueWithCGPoint:ccp( 77, 134)],
        [NSValue valueWithCGPoint:ccp(30, 90)],
        [NSValue valueWithCGPoint:ccp(160, 25)],
        [NSValue valueWithCGPoint:ccp( 110,  25)],
        [NSValue valueWithCGPoint:ccp( 182,  58)] ];
    
//    NSArray *array_Rot = @[@-5,@-2,@0,@14,@-3,@-1,@-18,@-13];
    for (int i = 0; i < 6; i++) {//70 120
        CCSprite *life = [CCSprite spriteWithSpriteFrameName:@"Life.png"];
        [self addChild:life];
        
        life.position = [array_Pos[i] CGPointValue];
        life.tag = LifeTagIndex + i;
        life.rotation =  arc4random()%60*6;
        life.visible = NO;
    }
    array_Pos = nil;
//    array_Rot = nil;
}
//设置生命显示个数
- (void)setLifeShow{
//    if (self.currentLV.LV>=4) {//LV4开始  才有生命检测
        for (int i = LifeTagIndex+6-1; i>=LifeTagIndex; i--) {
            CCSprite *life = (CCSprite *)[self getChildByTag:i];
            if (life.visible) {
                life.visible = NO;
                if (i == LifeTagIndex) {//
                    if (lifeShowCount>self.currentLV.lifeMax) {//如果当前生命个数超出当前LV最大生命，则重置为self.currentLV.lifeMax
                        lifeShowCount = self.currentLV.lifeMax;
                    }
                    
                    lifeShowCount--;
                    if (lifeShowCount == 0) {//归0后重置生命
                        lifeShowCount = self.currentLV.lifeMax;
                    }
                    
                    [self gamePunish];
                    
                    [self resetlifeShow:lifeShowCount];
                    
                }
                break;
            }
        }
//    }
}
//life个数达到0后，重置生命个数为 lifeShowCount
- (void)resetlifeShow:(int )count{
//    NSLog(@"%d",count);
    for (int i = 0; i < count; i++) {
        CCSprite *life = (CCSprite *)[self getChildByTag:i+LifeTagIndex];
        life.visible = YES;
    }
}
#pragma mark 游戏 惩罚
- (void)gamePunish{
    isGamePunishing = YES;
    int count = arc4random()%(self.currentLV.punishBallNumberMax-self.currentLV.punishBallNumberMin+1) + self.currentLV.punishBallNumberMin;
    for (int i= 0; i < count; i++) {
        [self createPunishBall];
    }
}
- (void)createPunishBall{
    float x,y;
    if (arc4random()%2==0) {//x坐标随机，y为上下两边
        x= arc4random()%(int )(s.width+1-100)+RADIUS;
        y = RADIUS;
    }else{//y坐标随机，x为左右两边
        x = (arc4random()%2==0?RADIUS:(s.width-RADIUS));
        y = arc4random()%(int )(s.height+1-200)+RADIUS;
    }
    
    creatBallSprite *ball = [self createBall];
    ball.scale = 1;
    [ball creatPhysics];
    ball.physicsBody->SetTransform(CGPointConvertTob2Vec2(ccp(x, y)), 0);
    
    CGPoint startPos = ccp(x, y);
    b2Vec2 force = [self getVector:startPos end:basicSprite.position withLenght:PunishStrength];
    
    ball.physicsBody -> SetLinearVelocity(force);
    
}
#pragma mark --------
#pragma mark 声音
//背景音 播放
//void SA_BackGroundMusic(){
//    if (![[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying]) {
//        [[SimpleAudioEngine sharedEngine]playBackgroundMusic:@"BackGroundMusic.mp3"];
//    }
//}
void SA_PauseBackGroundMusic(){
    [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
}
void SA_ResumeBackGroundMusic(){
    [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
}

//撞击音 播放
void SA_Crash(){
    [[SimpleAudioEngine sharedEngine] playEffect:@"bi.mp3"];
}
//撞击音 预加载
void SA_PreLoad(NSString *filename){
    [[SimpleAudioEngine sharedEngine] preloadEffect:filename];
}
void SA_PlayEffect(NSString *filename){
    [[SimpleAudioEngine sharedEngine]playEffect:filename];
}
#pragma mark --------
#pragma mark 清空无效碰撞次数
- (void)clearUnEffectCrashData{
    unEffectCrash = 0;
}
#pragma mark --------
#pragma mark 重置当前泡泡个数
- (void)resetBallNumber:(int )increase{//+1 -1  // 0为重置为0
    ballNumber = increase?(ballNumber+increase):0;
}
#pragma mark --------
#pragma mark 素材添加
- (void)batchnode{
    [self.cache addSpriteFramesWithFile:@"Game_Resources.plist"];
    
    self.batchNode = [CCSpriteBatchNode batchNodeWithFile:@"Game_Resources.pvr.ccz"];
    [self addChild:self.batchNode z:2];
}
- (void)backGround{
    CCSprite *bg = [CCSprite spriteWithFile:[NSString stringWithFormat:@"GameLayerBG%@.png",DEVICE]];
    bg.anchorPoint = CGPointZero;
    [self addChild:bg z:-1];
}
float height = [[CCDirector sharedDirector]winSize].height;
- (void)addLaunch{
    self.launch = [CCSprite spriteWithSpriteFrameName:@"Launch_Bottom.png"];
    [self addChild:_launch z:0];
    NSLog(@"%f",height);
    _launch.position = ccp(s.width/2, s.height-_launch.contentSize.height/2);
    
    CCSprite *launchUp = [CCSprite spriteWithSpriteFrameName:@"Launch.png"];
    [_launch addChild:launchUp z:2];
    launchUp.anchorPoint = CGPointZero;
}
- (void)updateLaunchRotation:(CGPoint )touchLocation{
    touchLocation = [self getRightPointWithTouchLocation:_launch.position :touchLocation];
    float angel = [self vectorIncludedAngle:CGPointConvertTob2Vec2(_launch.position) :CGPointConvertTob2Vec2(touchLocation)];
    angel = angel*180/b2_pi;
    _launch.rotation = angel-90;
}
//- (void)gamePlayMenu{
//    GameMenuLayer *layer = [GameMenuLayer node];
//    [self addChild:layer];
//    layer.delegate = self;
//    
//    
//    [self addBackgroundMusicControl];
//
//}
//- (void)addBackgroundMusicControl{
//    
//    CCSprite *on = [CCSprite spriteWithSpriteFrameName:@"SoundOn.png"];
//    CCSprite *off = [CCSprite spriteWithSpriteFrameName:@"SoundOff.png"];
//    CCMenuItemSprite *b1 = [CCMenuItemSprite itemWithNormalSprite:on selectedSprite:nil];
//    CCMenuItemSprite *b2 = [CCMenuItemSprite itemWithNormalSprite:off selectedSprite:nil];
//    CCMenuItemToggle *toggle = [CCMenuItemToggle itemWithTarget:self selector:@selector(turnMusicOnOrOff:) items:b1,b2, nil];
//    toggle.position = ccp(s.width-on.contentSize.width/2, on.contentSize.height/2);
//    
//    CCMenu * menu = [CCMenu menuWithItems:toggle, nil];
//    menu.position =CGPointZero;
//    [self addChild:menu z:-1];
//}
//- (void)turnMusicOnOrOff:(CCMenuItemToggle *)toggle{
//    if (toggle.selectedIndex==1)
//        SA_PauseBackGroundMusic();
//    else
//        SA_ResumeBackGroundMusic();
//}
#pragma mark --------
#pragma mark update更新
//同步精灵与刚体坐标
#define isBasicBody(x) x==basicBody  //判断 b2Body 是否为  BasicBody
#define isBodyUserData_CreateBallSprite_CLASS(b) [(NSObject *)b->GetUserData() isMemberOfClass:[creatBallSprite class]] //判断 b2Body 的UserData 是否为 creatBallSprite类
- (void)updateSpritePosToBox2DPosition{
    for (b2Body *b = WORLD->GetBodyList(); b; b = b->GetNext()) {
        if (isBasicBody(b)) {
            
            for (b2Fixture *fix = b ->GetFixtureList(); fix; fix = fix-> GetNext()) {
                CreateFixture *sp = (CreateFixture *)fix -> GetUserData();
                
                b2CircleShape *shape = (b2CircleShape *)fix->GetShape();
                
                b2Vec2 b2 = shape->m_p;
                float angel = b -> GetAngle();
                b2Vec2 b_ = b2Vec2(b2.x * cosf(angel) - b2.y * sinf(angel), b2.y * cosf(angel) + b2.x * sinf(angel));
                
                if (b!=NULL) {
                    sp.position = CGPointMake( (b_.x+b->GetPosition().x)  * PTM_RATIO, (b_.y+b->GetPosition().y) * PTM_RATIO);
                    sp.rotation = -1 * CC_RADIANS_TO_DEGREES(angel);
                }
            }
            
        }else if (isBodyUserData_CreateBallSprite_CLASS(b)){
            creatBallSprite *sp = (creatBallSprite *)b->GetUserData();
            sp.position = [_launch convertToNodeSpace:CGPointMake( b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO)];
            sp.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
        }
    }
}
//刚体碰撞检测
- (void)listenBox2DContact{
    std::vector<b2Body *>toDestroy;
    std::vector<MyContact>::iterator pos;
    for (pos = CONTACTLISTENER->_contacts.begin(); pos != CONTACTLISTENER->_contacts.end(); ++pos) {
        MyContact contact = *pos;
        
        b2Body *b1 = contact.fixtureA ->GetBody();
        b2Body *b2 = contact.fixtureB ->GetBody();
        
        if (isBodyUserData_CreateBallSprite_CLASS(b1) || isBodyUserData_CreateBallSprite_CLASS(b2)) {
            //碰撞点 碰撞效果 
            if (isBodyUserData_CreateBallSprite_CLASS(b1)) {
//                [self createParticle:b2Vec2ConvertToCGPoint(b1->GetPosition())];//((creatBallSprite *)b1->GetUserData()).position
            }
            else{
//                [self createParticle:b2Vec2ConvertToCGPoint(b2->GetPosition())];//((creatBallSprite *)b1->GetUserData()).position
            }
            SA_PlayEffect(@"bi.mp3");//碰撞音效
        }
        
        if ((isBasicBody(b1) && (isBodyUserData_CreateBallSprite_CLASS(b2))) || (isBasicBody(b2) && (isBodyUserData_CreateBallSprite_CLASS(b1)))) {
            
            [self clearUnEffectCrashData];
            
            if (isBasicBody(b1)) {
                
                [self a:contact.fixtureA body:b2 withVelocity:contact.theBallVelocity];
                
            }else{
                [self a:contact.fixtureB body:b1 withVelocity:contact.theBallVelocity];
            }
        }
        else if(isBasicBody(b1) || isBasicBody(b2)){//basicBody 触碰到边界
            if (!didGameFail){
                [self gameFail];
                didGameFail = YES;
            }
        }
        else if ((isBodyUserData_CreateBallSprite_CLASS(b1) && (NSObject *)b2->GetUserData() == nil) ||
                 (isBodyUserData_CreateBallSprite_CLASS(b2)  && (NSObject *)b1->GetUserData() == nil)){

            if (!isGamePunishing) {
                unEffectCrash++;
                if (unEffectCrash == UnEffectCrash) {
                    [self unEffectCrashed:b1 :b2];//无效碰撞 UnEffectCrash 次数 处理
                }
            }

        }
    }
}
//init
- (id)init{
    if (self == [super init]) {
        didGameFail = NO;
        
        s = [[CCDirector sharedDirector] winSize];
        
        [self clearUnEffectCrashData];
        [self resetBallNumber:0];
        
        SA_PreLoad(@"bi.mp3");
        
        _ballShouldRemove = self.ballShouldRemove;
        _fixtureShouldRemove = self.fixtureShouldRemove;

        //box2d
        CREATE_WORLD;
        
        //cocos2d
        [self backGround];
        [self batchnode];
        [self addLaunch];
                
        [self scheduleUpdate];
        

        
        [self gameFirstStart];
        
#ifdef OPENRAYCAST
        //瞄准线
        OpenRayCast *layer = [OpenRayCast node];
        [self addChild:layer z:2];
        layer.tag = OpenRayCastTag;
        layer.labelLayer = self.gameLabel;
#endif

        
        CCMenuItem *back = [CCMenuItemImage itemWithNormalImage:@"Back-iPhone.png" selectedImage:@"Back_-iPhone.png" block:^(id sender) {
            [[CCDirector sharedDirector] popScene];
        }];
        CCMenu *backM = [CCMenu menuWithItems:back, nil];
        [self addChild:backM z:10];
        backM.position = ccp(back.contentSize.width/2,back.contentSize.height/2);
        
    }
    return self;
}
-(void) update: (ccTime) dt{//一个world 以下代码不能注册多次 时间会叠加
    
    UPDATE_WORLDSTEP(dt);
    
    [self updateSpritePosToBox2DPosition];
    
    [self listenBox2DContact];
    
    [self clearBallShouldRArray];
    [self clearFixtureShouldRArray];
}
#pragma mark -----// 无效碰撞 UnEffectCrash 次数 处理
- (void)unEffectCrashed:(b2Body *)b1 :(b2Body *)b2{
    [self setLifeShow];
    [self clearUnEffectCrashData];
    b2Body *body = NULL;
    if (isBodyUserData_CreateBallSprite_CLASS(b1)) {
        body = b1;
    }else body = b2;
    
    body->SetLinearVelocity(b2Vec2_zero);
    body->SetTransform(CGPointConvertTob2Vec2([_launch convertToWorldSpace:BallOrgPosition]), 0);
    
    curBullet = (creatBallSprite *)body->GetUserData();
    curBullet.scale = .5f;
    [curBullet runAction:[CCSequence actions:[CCScaleTo actionWithDuration:.3f scale:1.0f],[CCCallFuncN actionWithTarget:self selector:@selector(setTouchEnabled)], nil]];
}
#pragma mark clear （ 球 和 夹具 ） 数组
- (void)delayDestoryBody:(b2Body *)b{
    WORLD->DestroyBody(b);
    b = NULL;
}
- (void)delayRemoveChild:(creatBallSprite *)sp{
    [sp removeWithType:sp.removeEffect];
}
- (void)clearBallShouldRArray{
    if (_ballShouldRemove.count!=0) {
        for (int i = 0; i < _ballShouldRemove.count; i++) {
            creatBallSprite *ball = _ballShouldRemove[i];

            [self delayDestoryBody:ball.physicsBody];
            [self delayRemoveChild:ball];

            ballNumber--;
            
            if (isGamePunishing) {
                if (ballNumber<=1) {
                    isGamePunishing = NO;
                    
                    [self createBall];
                }
            }else {
                [self createBall];
            }
        }
        [_ballShouldRemove removeAllObjects];
    }
    
}
- (void)clearFixtureShouldRArray{    
    if (_fixtureShouldRemove.count!=0) {
        for (int i = 0; i < _fixtureShouldRemove.count; i++) {
            EmptySprite *sp = _fixtureShouldRemove[i];
            CreateFixture *fSp = (CreateFixture *)sp.fixtureSp;

            [fSp runAction:[CCCallFuncND actionWithTarget:self selector:@selector(removeFixture:withEmptySp:) data:sp]];
            
        }
        [_fixtureShouldRemove removeAllObjects];
    }
}
#pragma mark 检测 球 所在 为 哪个 EmptySprite 所在位置，返回  sp
- (EmptySprite *)choseSprite:(b2Fixture *)fixtureA body:(b2Body *)ball{
    NSMutableArray *array = [NSMutableArray array];
    
    NSObject *obj = (NSObject *)fixtureA->GetUserData();
    if ([obj isMemberOfClass:[BasicBody class]]) {
        array = basicSprite.spriteContains;
    }else if ([obj isMemberOfClass:[CreateFixture class]]) {
        CreateFixture *fixtureSp = (CreateFixture *)obj;
        array = fixtureSp.chainedSprite.spriteContains;
    }
    
    CGPoint ballPosition = b2Vec2ConvertToCGPoint(ball->GetPosition());
    float length = 50;
    EmptySprite * sp = nil;
    for (EmptySprite *sp_ in array) {
        if (sp_.didPhysicsExist) {
            continue;
        }
        
        CGPoint worldPos = [basicSprite convertToWorldSpace:sp_.position];
        float length_ = ccpLength(ccpSub(ballPosition, worldPos));
        if ( length_ <= length) {
            length = length_;
            sp = sp_;
        }
    }
    return sp;
    
}
#pragma mark 碰撞处理 fixtureA 与 ball
- (void)a:(b2Fixture *)fixtureA body:(b2Body *)bodyB  withVelocity:(b2Vec2 )velocity{
    CCSprite *sp_ = (CCSprite *)fixtureA->GetUserData();
    CGPoint p_ = sp_.position;
    b2Vec2 b_ = b2Vec2(p_.x/PTM_RATIO, p_.y/PTM_RATIO);
    basicBody->ApplyLinearImpulse((bodyB->GetMass())*velocity, b_);
    
    creatBallSprite *ballSprite = (creatBallSprite *)bodyB->GetUserData();
    for (creatBallSprite *sp in self.ballShouldRemove) {
        if (ballSprite == sp) {
            return;
        }
    }
    
    EmptySprite *sp = [self choseSprite:fixtureA body:bodyB];
    
    if (sp) {//sp位置上创建basicBody的夹具
        CGPoint worldPos = [basicSprite convertToWorldSpace:sp.position];
        
        CGPoint p1 = sp.orgPosition;
        b2Vec2 relativelyV = CGPointConvertTob2Vec2(ccp(p1.x-basicSprite.contentSize.width/2, p1.y-basicSprite.contentSize.height/2));
        
        CreateFixture *fixtureSp = [self createFixture:relativelyV withUserDataFlg:ballSprite.kBallEnum body:basicBody];
        [self.batchNode addChild:fixtureSp];
        
        [basicSprite setBodyMasscenter];
        
        fixtureSp.fixtureDelegate = self;
        fixtureSp.position = worldPos;
        
        fixtureSp.chainedSprite = sp;
        sp.didPhysicsExist = YES;
        
        sp.flg = ballSprite.kBallEnum;
        
        sp.fixtureSp = (NSObject *)fixtureSp;
        
        [basicSprite.curExistBall addObject:sp];
        
        if (!isGamePunishing) [self firstRecursion:sp];
        
    }
    
    ballSprite.removeEffect = removeWithNonEffect;
    [self.ballShouldRemove addObject:ballSprite];
    
}
#pragma mark 检测 obj 是否在 指定数组内
- (BOOL)checkEmptyIsInArray:(EmptySprite *)sp withArray:(NSMutableArray *)array_{
    for (EmptySprite *sp_ in array_) {
        if (sp == sp_) {
            return YES;
        }
    }
    return NO;
}
#pragma mark 0
- (void)firstRecursion:(EmptySprite *)sp0{
    NSMutableArray *array_ = [NSMutableArray array];
    [array_ addObject:sp0];
    [self recursion:sp0 withArray:array_];
    
    if (array_.count>=3) {
        for (EmptySprite *sp in array_) {
            sp.didPhysicsExist = NO;
            [self.fixtureShouldRemove addObject:sp];
        }
        
        [self ergodicFromBasic];
        
    }else{
        [self setLifeShow];//设置 生命 显示  并且控制 生命为0时 重置并惩罚
    }
}
- (NSMutableArray *)recursion:(EmptySprite *)sp0 withArray:(NSMutableArray *)array_{
    
    for (EmptySprite *sp in sp0.spriteContains) {
        int count = sp0.spriteContains.count;
        if (![self checkEmptyIsInArray:sp withArray:array_] && (sp.flg == sp0.flg)) {
            [array_ addObject:sp];
            [self recursion:sp withArray:array_];
        }else {
            count--;
        }
        if (count==0) {
            break;
        }
    }
    return array_;
}
#pragma mark 遍历悬空
- (void)ergodicFromBasic{
    NSMutableArray *array_ = [NSMutableArray array];
    [array_ removeAllObjects];
    
    [self ergodicAllEmpty:basicSprite withArray:array_];
    
    for (EmptySprite *sp in basicSprite.curExistBall) {
        if (sp.didPhysicsExist) {
            if (![self checkEmptyIsInArray:sp withArray:array_]) {
                [self.fixtureShouldRemove addObject:sp];
            }
        }
    }
}
- (NSMutableArray *)ergodicAllEmpty:(NSObject *)sp withArray:(NSMutableArray *)array_{
    BasicBody *basicSp = nil;
    EmptySprite *emptySp = nil;
    if ([sp isMemberOfClass:[BasicBody class]]) {
        basicSp = (BasicBody *)sp;
    }else if ([sp isMemberOfClass:[EmptySprite class]]) {
        emptySp = (EmptySprite *)sp;
    }
    
    if (basicSp) {
        for (EmptySprite *sp_ in basicSp.spriteContains) {
            int count = basicSp.spriteContains.count;
            if (![self checkEmptyIsInArray:sp_ withArray:array_] && sp_.didPhysicsExist) {
                [array_ addObject:sp_];
                [self ergodicAllEmpty:sp_ withArray:array_];
            }else {
                count--;
            }
            if (count==0) {
                break;
            }
        }
    }else if (emptySp) {
        for (EmptySprite *sp_ in emptySp.spriteContains) {
            int count = emptySp.spriteContains.count;
            if (![self checkEmptyIsInArray:sp_ withArray:array_] && sp_.didPhysicsExist) {
                [array_ addObject:sp_];
                [self ergodicAllEmpty:sp_ withArray:array_];
            }else {
                count--;
            }
            if (count==0) {
                break;
            }
        }
    }
    
    return array_;
}

#pragma mark Game Over
- (void)gameFail{
    [self unscheduleUpdate];
    
    NSString *msgSave = [[NSString alloc] initWithFormat:@"Game Over!"];
    
    UIAlertView *alertSave =[[UIAlertView alloc]
                             initWithTitle:nil
                             message:msgSave
                             delegate:self
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil];
    [alertSave show];
    [alertSave release];
    [msgSave release];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    [self reportScore:self.gameLabel.labelPoint forCategory:@"airleaderboard"];
    
    DELETE_WORLD;
    
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0 scene:[GameLayer node]]];
}
//#pragma mark GameCenter
//- (void) reportScore: (int64_t) score forCategory: (NSString*) category
//
//{
//    
//    GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:category] autorelease];
//    
//    scoreReporter.value = score;
//    
//    [scoreReporter reportScoreWithCompletionHandler: ^(NSError *error)
//     
//     {
//         if (error != nil)
//         {
//             NSLog(@"上传分数出错.");
//         }else {
//             NSLog(@"上传分数成功");
//         }    }];
//    
//}
//-(void)openGameCenter:(id)sender
//
//{
//
////   gameCenterView = [[UIViewController alloc] init];
////
////    gameCenterView.view = [[CCDirector sharedDirector] view];
////
////    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
////
////    if (leaderboardController != NULL)
////
////    {
////
////        leaderboardController.category = @"airleaderboard";
////
////        leaderboardController.leaderboardDelegate = self;
////
////        [gameCenterView presentModalViewController: leaderboardController animated: YES];
////
////    }
//
//}
////
//- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
//
//{
////        [gameCenterView dismissModalViewControllerAnimated:YES];
////    
////        [gameCenterView release];
//    
//}
#pragma mark b2Vec2 与 CGPoint  互转
CGPoint b2Vec2ConvertToCGPoint(b2Vec2 b2){
    //    NSLog(@"%f,%f",b2.x,b2.y);
    return  ccpMult(CGPointMake(b2.x, b2.y), PTM_RATIO);
}
b2Vec2 CGPointConvertTob2Vec2(CGPoint point){
    return b2Vec2(point.x / PTM_RATIO, point.y / PTM_RATIO);
}
#pragma mark 根据两点坐标 及 向量的模 确定 向量
- (b2Vec2)getVector:(CGPoint )pStart end:(CGPoint )pEnd withLenght:(float )model{//model为像素值
    CGPoint length = ccpSub(pEnd, pStart);
    //    b2Vec2 b2Length = [self CGPointConvertTob2Vec2:length];
    float rate = sqrtf(model * model / ccpLengthSQ(ccp(length.x, length.y)));
    //    CCLOG(@"%f,%f,%f",length.x * rate,length.y * rate,rate);
    return b2Vec2(length.x * rate,length.y * rate);
}

static BOOL shouldRayCastDraw = FALSE;
- (void)draw{
    if (shouldRayCastDraw) {
        
        ccDrawColor4F(1, 0, 0, 1);
        glLineWidth(2);
        
        if (self.goalPointArray.count>0) {
            for (int i = 0; i < self.goalPointArray.count-1; i++) {
                CGPoint p1 = [self.goalPointArray[i] CGPointValue];
                CGPoint p2 = [self.goalPointArray[i+1] CGPointValue];
                ccDrawLine(p1, p2);
            }
        }
    }
}

#pragma  mark ------ RayCastClosestCallback
class RayCastClosestCallback : public b2RayCastCallback
{
public:
    RayCastClosestCallback()
    {
        m_hit = false;
    }
    
    float32 ReportFixture(b2Fixture* fixture, const b2Vec2& point,
                          const b2Vec2& normal, float32 fraction)
    {
        m_point = point;
        body = fixture->GetBody();
        m_hit = true;
        m_normal = normal;
        
        return fraction;
    }
    
    bool m_hit;
    b2Vec2 m_point;
    b2Body* body;
    b2Vec2 m_normal;
};
#pragma mark -----------
#pragma mark 瞄准线
const int reflectC = 100;
static int reflectCount = reflectC;//射线 最大反射次数

- (void)tick_drawLineWithTouchLocation{
    [self.goalPointArray removeAllObjects];
    reflectCount = reflectC;
    [self drawLineWithStartPosition:[_launch convertToWorldSpace:curBullet.position] end:touchTemp_];//
    
}


#pragma mark 根据  向量的起始坐标点 及 向量 确定 单位长度为 1 的点坐标 返回 CGPoint
- (CGPoint )getPointOnVector:(b2Vec2 )v startPosition:(CGPoint )start{
    return ccpAdd(ccp(50*v.x, 50*v.y), start);
}
#pragma mark ----向量转角公式
- (b2Vec2 )vectorTransformWithRadian:(float )radian orgVector:(b2Vec2 )vOrg{
    
    b2Vec2 transformedVector;
    transformedVector.x = vOrg.x * cosf(radian) - vOrg.y * sinf(radian);
    
    transformedVector.y = vOrg.y * cosf(radian) + vOrg.x * sinf(radian);
    
    return transformedVector;
}

#pragma mark ----向量夹角公式
- (float )vectorIncludedAngle:(b2Vec2 )start :(b2Vec2 )end{
    CGPoint sub = ccpSub(ccp(end.x, end.y ), ccp(start.x, start.y));
    CGPoint vZero = ccp(1, 0);
    float product = sub.x*vZero.x+sub.y*vZero.y;
    float model = ccpLength(ccp(sub.x, sub.y))*ccpLength(ccp(vZero.x, vZero.y));
    return acosf(product/model);
}

#pragma mark ----两点确定一条直线
-(NSMutableArray *)getLineWithTwoPoint:(CGPoint )p1 :(CGPoint )p2{
    //两点式方程：(x-x1)*(y2-y1)=(y-y1)*(x2-x1)
    NSMutableArray *a = [NSMutableArray array];
    
    NSNumber *A = @(p2.y-p1.y);
    NSNumber *B = @(p1.x-p2.x);
    NSNumber *C = @(p1.y*p2.x-p1.x*p2.y);
    
    [a addObject:A];
    [a addObject:B];
    [a addObject:C];
    
    return a;
}

#pragma mark ----点到直线的对称点
- (CGPoint )getPoint:(CGPoint )p0 toLine:(NSMutableArray *)a{
    
    float A,B,C;
    
    A = [a[0] floatValue];
    B = [a[1] floatValue];
    C = [a[2] floatValue];
    
    CGPoint endPosition;
    endPosition.x = ( (B*B-A*A)*p0.x-2*A*B*p0.y-2*A*C ) / (A*A+B*B);
    endPosition.y = ( -(B*B-A*A)*p0.y-2*A*B*p0.x-2*B*C ) / (A*A+B*B);
    
    return endPosition;
    
}
#pragma mark ----法向量
- (b2Vec2 )getNormalMathed:(CGPoint )p1 :(CGPoint )p2{
    if ( ((p1.x==RADIUS) && (p1.y==RADIUS))          ||
         ((p1.x==RADIUS) && (p1.y==s.height-RADIUS)) ||
         ((p1.x==s.width-RADIUS) && (p1.y==RADIUS))  ||
         ((p1.x==s.width-RADIUS) && (p1.y==s.height-RADIUS)) ) return b2Vec2(p2.x-p1.x, p2.y-p2.x);
    else if (p1.x==RADIUS) return b2Vec2(1, 0);
    else if (p1.x==s.width-RADIUS) return b2Vec2(-1, 0);
    else if (p1.y==RADIUS) return b2Vec2(0, 1);
    else if (p1.y==s.height-RADIUS) return b2Vec2(0, -1);
    
    return b2Vec2_zero;
}
#pragma mark ----二次检测 瞄准线
- (void)secondCheckWithStart:(CGPoint )startPosition
                         end:(CGPoint )endPosition
                normalVector:(b2Vec2 )normal{
    
    b2Vec2 normal_ = [self getNormalMathed:startPosition :endPosition];
    if (normal_.x==0&&normal_.y==0) {
        return;
    }
    
    CGPoint p_ = [self getPointOnVector:normal_ startPosition:startPosition];//获取法向量上的一点
    
    NSMutableArray *a = [self getLineWithTwoPoint:startPosition :p_];//两点确定法向量直线
    
    CGPoint end_ = [self getPoint:endPosition toLine:a];//根据法向量及线外一点 得到点对直线的对称点
        
    [self drawLineWithStartPosition:startPosition end:end_];
    
}
//左下角0 右下角1 左上角2 右上角3
const int leftDown = 0;
const int rightDown = 1;
const int leftUp = 2;
const int rightUp = 3;
#pragma mark ----从p1到p2 所指向的屏幕 角
- (int )pointAtWhichCorner:(CGPoint )p1 :(CGPoint )p2{

    if (p2.x<=p1.x) {
        if (p2.y<=p1.y) return leftDown;
        else return leftUp;
    }else if (p2.x>p1.x){
        if (p2.y<=p1.y) return rightDown;
        else return rightUp;
    }
    return -1;
}
#pragma mark ----检测直线先到达以（X=m）为轴还是以（Y=n）为轴
- (CGPoint )checkXOrY:(NSMutableArray *)line start:(CGPoint )p1 end:(CGPoint )p2{
    int corner = [self pointAtWhichCorner:p1 :p2];

    float A,B,C;
    A = [line[0] floatValue];
    B = [line[1] floatValue];
    C = [line[2] floatValue];
    
    float X=0,Y=0;
    CGPoint p3,p4;
    
    switch (corner) {
        case leftDown:
            X = RADIUS;
            Y = RADIUS;
            break;
        case leftUp:
            X = RADIUS;
            Y = s.height-RADIUS;
            break;
        case rightDown:
            X = s.width-RADIUS;
            Y = RADIUS;
            break;
        case rightUp:
            X = s.width-RADIUS;
            Y = s.height-RADIUS;
            break;
        case -1:
            NSAssert(corner!=-1, @"未检测到角落坐标点");
            break;
        default:
            break;
    }

    {//p3
        p3.x = X;
        if (B ==0) {
            p3.y = p2.y;
        }else{
            p3.y = -(C+A*X)/B;
        }
    }
    {//p4
        p4.y = Y;
        if (A==0) {
            p4.x = p2.x;
        }else p4.x = -(C+B*Y)/A;
    }

    if (ccpLength(ccpSub(p1, p3)) < ccpLength(ccpSub(p1, p4))) {
        return p3;//X
    }else{
        return p4;//Y
    }
    
}
#pragma mark -------获取射线落点
- (CGPoint )getM_Point:(CGPoint )p1 third:(CGPoint )p3{
    NSMutableArray *a = [self getLineWithTwoPoint:p1 :p3];
    float A,B,C;
    A = [a[0] floatValue];
    B = [a[1] floatValue];
    C = [a[2] floatValue];
    
    p3 = [self checkXOrY:a start:p1 end:p3];
    
    return p3;
}
#pragma mark -------射线
- (void)drawLineWithStartPosition:(CGPoint )startPosition end:(CGPoint )endPosition{
    
    b2Vec2 startVec = CGPointConvertTob2Vec2(startPosition);
    
    RayCastClosestCallback callback;
    
    CGPoint p;
    b2Vec2 pV;
    
    p = [self getTouchPisitionMathed:startPosition :endPosition];
    pV = CGPointConvertTob2Vec2(p);
    
    WORLD->RayCast(&callback, startVec, pV);

    if (callback.m_hit) {
        
        reflectCount--;
        
        CGPoint ballRealPoint = b2Vec2ConvertToCGPoint(callback.m_point);

        if (callback.body == basicBody) {
            [self addGoalPointToArray:ballRealPoint];
        }
        
        if (callback.body != basicBody) {
            
            ballRealPoint = [self getM_Point:startPosition third:ballRealPoint];//给 startPosition 一个球实体的偏移量
            [self addGoalPointToArray:ballRealPoint];
            //            ballTest.position = ballRealPoint;
            
            if (reflectCount!=0) {
                [self secondCheckWithStart:ballRealPoint end:startPosition normalVector:callback.m_normal];
            }
            
            
        }
        
        if(!shouldRayCastDraw) shouldRayCastDraw = TRUE;
    }//else shouldRayCastDraw = FALSE;
    
}
#pragma mark -------isRayCast_M_Point_OnCorner
- (BOOL )isRayCast_M_Point_OnCorner:(CGPoint )p{//检测 瞄准线是否指向 屏幕的四个角
    if ( ((int )roundf(p.x)==0      && (int )roundf(p.y)==0)        ||//左下角
        ((int )roundf(p.x)==s.width && (int )roundf(p.y)==0)        ||//右下角
        ((int )roundf(p.x)==0       && (int )roundf(p.y)==s.height) ||//左上角
        ((int )roundf(p.x)==s.width && (int )roundf(p.y)==s.height)   //右上角
        ) {
        return YES;
    }
    
    return NO;
    
}
#pragma mark -------扩大start点到end的长度 以便射线检测正常
- (CGPoint )getTouchPisitionMathed:(CGPoint) start :(CGPoint )end{
    const float maxLinelength = ccpLength(ccp(s.width, s.height));
    CGPoint sub = ccpSub(end, start);
    
    CGPoint mult = ccpMult(sub, maxLinelength/ccpLength(sub));
    CGPoint p_ = ccpAdd(mult, start);
    return p_;
}
#pragma mark -------排除触摸点到泡泡坐标向量与X轴夹角0-20和160-180°角
-(CGPoint ) getRightPointWithTouchLocation:(CGPoint) start :(CGPoint )end{//向量夹角,弧度
    CGPoint returnPisition_ = CGPointZero;
    
    CGPoint pSub = ccpSub(end, start);
    float radian = CC_RADIANS_TO_DEGREES([self vectorIncludedAngle:b2Vec2(pSub.x, pSub.y) :b2Vec2(1, 0)]);
    
    if (radian<20) {
        radian = 20;
        returnPisition_ = [self getTouchPisitionMathed:start :ccpAdd(start, ccp(-50, -tanf(CC_DEGREES_TO_RADIANS(20.f))*50))];
        
        //        NSLog(@"%f,%f",returnPisition_.x,returnPisition_.y);
    }else if (radian>160){
        radian = 160;
        returnPisition_ = [self getTouchPisitionMathed:start :ccpAdd(start, ccp(50, -tanf(CC_DEGREES_TO_RADIANS(20.f))*50))];
    }else{
        returnPisition_ = [self getTouchPisitionMathed:start :end];
    }
    
    return returnPisition_;
}
#pragma mark -----------
#pragma mark touch 
- (void)registerWithTouchDispatcher{
    [[[CCDirector sharedDirector] touchDispatcher]addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    NSLog(@"%f,%f",touchLocation.x,touchLocation.y);
    touchTemp_ = [self getRightPointWithTouchLocation:[_launch convertToWorldSpace:curBullet.position] :touchLocation];

    [self updateLaunchRotation:touchLocation];

#ifdef OPENRAYCAST
    if (OPEN && CURCOUNT>0) {//
        [self schedule:@selector(tick_drawLineWithTouchLocation)];
    }
    return YES;
#endif
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    touchTemp_ = [self getRightPointWithTouchLocation:[_launch convertToWorldSpace:curBullet.position] :touchLocation];
//    [self updateSightAngel:touchTemp_];
    
//    CCSprite *life = (CCSprite *)[self getChildByTag:LifeTagIndex+t];
//    CGPoint pre = [touch previousLocationInView:[touch view]];
//    pre = [[CCDirector sharedDirector] convertToGL:pre];
//    pre = [self convertToNodeSpace:pre];
//    CGPoint sub = ccpSub(touchLocation, pre);
//    life.position = ccpAdd(sub, life.position);
//    NSLog(@"%f,%f,",life.position.x,life.position.y);
   
    [self updateLaunchRotation:touchLocation];
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];

#ifdef OPENRAYCAST
    if (OPEN) {
        [self unschedule:@selector(tick_drawLineWithTouchLocation)];
        shouldRayCastDraw = FALSE;
    }
#endif
    
    if (touchLocation.x<=2.0 || touchLocation.x>=s.width-2 || touchLocation.y<=2 || touchLocation.y>=s.height-2) return;
    
    if (curBullet) {
        
        self.isTouchEnabled = NO;
        
        if (curBullet.physicsBody==NULL) {
            [curBullet creatPhysics];
        }

        touchTemp_ = [self getRightPointWithTouchLocation:[_launch convertToWorldSpace:curBullet.position] :touchLocation];

        b2Vec2 force = [self getVector:[_launch convertToWorldSpace:curBullet.position] end:touchTemp_ withLenght:InitialStrength];
        if (curBullet.physicsBody!=NULL) {
            curBullet.physicsBody -> SetLinearVelocity(force);
        }
        
        curBullet = nil;
        
#ifdef OPENRAYCAST
        if (OPEN && CURCOUNT>0) {
            OpenRayCast *layer = (OpenRayCast *)[self getChildByTag:OpenRayCastTag];
            [layer performSelector:@selector(subCount) withObject:self afterDelay:.3f];
        }
#endif
    }
}
- (void)dealloc{
    self.batchNode = nil;
    
//
    self.launch = nil;
//
    [self.ballShouldRemove release];
    _ballShouldRemove = nil;
    
    [self.fixtureShouldRemove release];
    _fixtureShouldRemove = nil;
    
    [self.goalPointArray release];
    _goalPointArray = nil;
    
//    self.cache = nil;
    
    self.gameLabel = nil;
    
    [super dealloc];
    
}
@end
