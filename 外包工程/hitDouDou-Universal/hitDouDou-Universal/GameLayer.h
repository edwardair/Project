//
//  GameLayer.h
//  hitDouDou
//
//  Created by YJ Z on 12-9-10.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "creatBallSprite.h"
#import "CreateFixture.h"
#import "AppDelegate.h"
#import "BasicBody.h"
#import "Sprite.h"
#import<GameKit/GameKit.h>
#import "CreateFixture.h"
#import "LevelData.h"
//#import "Bomb.h"
#import "GameLabel.h"
#import "GameMenuLayer.h"
//#import "DataModel.h"
@interface GameLayer : CCLayer <CeateFixtureDelegate,delegateGameStart>{//GKLeaderboardViewControllerDelegate,
    CGSize s;
    
//    b2World* world;					// strong ref
//    b2Body *groundBody;
    
    BasicBody *basicSprite;
    
    b2Body *basicBody;
    
    creatBallSprite *curBullet,*nextBullet;
    
//    CCParticleSystemQuad * system;
    
//    CCLabelAtlas *labelPointRate;
//    CCLabelAtlas *labelCount,*labelHighest;
//    
//    int labelPoint;
//    int pointRate;
    int lifeShowCount;
    
    BOOL isGamePunishing;

    int unEffectCrash;
    
    int ballNumber;
    
    UIViewController* gameCenterView;
    
//    CCSprite *moveTest;
}
@property (nonatomic,retain) CCSpriteBatchNode *batchNode;
@property (nonatomic,retain) CCSprite *launch;
@property (nonatomic,assign) Data_Level currentLV;
@property (nonatomic,retain) CCSpriteFrameCache *cache;
@end
