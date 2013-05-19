//
//  InitPhysicsWorld.h
//  hitDouDou-Universal
//
//  Created by ZYJ on 12-11-22.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "MyContactListener.h"

@interface InitPhysicsWorld : CCLayer {
    GLESDebugDraw *m_debugDraw;		// strong ref
    b2Body *groundBody;
    b2World *world;
    MyContactListener *contactListener;
}
+(id )sharePhysicsWorld;
+(void )unSharePhysicsWorld;
- (void )initPhysicsWorld;
- (b2World *)getWorld;
- (b2Body *)getGroundBody;
- (MyContactListener *)getContactListener;
- (void)updateWorldStep:(ccTime )dt;
@end
//创建世界
#define CREATE_WORLD \
    [[InitPhysicsWorld sharePhysicsWorld] initPhysicsWorld]   
//销毁世界
#define DELETE_WORLD \
    [InitPhysicsWorld unSharePhysicsWorld]  
//获取 世界
#define WORLD \
    [[InitPhysicsWorld sharePhysicsWorld] getWorld]  
//获取  大地
#define GROUNDBODY \
    [[InitPhysicsWorld sharePhysicsWorld] getGroundBody]  
//获取碰撞监听者
#define CONTACTLISTENER \
    [[InitPhysicsWorld sharePhysicsWorld] getContactListener]  
//更新世界时间步
#define UPDATE_WORLDSTEP(x) \
    [[InitPhysicsWorld sharePhysicsWorld] updateWorldStep:x]

