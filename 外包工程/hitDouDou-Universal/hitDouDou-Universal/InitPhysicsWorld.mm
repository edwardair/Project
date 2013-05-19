//
//  InitPhysicsWorld.m
//  hitDouDou-Universal
//
//  Created by ZYJ on 12-11-22.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "InitPhysicsWorld.h"
static InitPhysicsWorld *worldObject = nil;

@implementation InitPhysicsWorld
+(id )sharePhysicsWorld{
    if (!worldObject) {
        worldObject = [[InitPhysicsWorld alloc]init];
    }
    return worldObject;
}
+(void )unSharePhysicsWorld{
    if (worldObject) {
        [worldObject release];
        worldObject = nil;
    }
}
- (void )initPhysicsWorld{
    CGSize s = [[CCDirector sharedDirector]winSize];
    
    b2Vec2 gravity;
	gravity.Set(0.0f, 0.0f);
	world = new b2World(gravity);
	
    contactListener = new MyContactListener();
    world -> SetContactListener(contactListener);
    
	world->SetAllowSleeping(true);
	world->SetContinuousPhysics(true);
	
//    m_debugDraw = new GLESDebugDraw( PTM_RATIO );
//    world->SetDebugDraw(m_debugDraw);
    
    //        uint32 flags = 0;
    //        flags += b2Draw::e_shapeBit;
    //        flags += b2Draw::e_jointBit;
    //        flags += b2Draw::e_aabbBit;
    //        flags += b2Draw::e_pairBit;
    //        flags += b2Draw::e_centerOfMassBit;
    //        m_debugDraw->SetFlags(flags);
	
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, 0); // bottom-left corner
	
	groundBody = world->CreateBody(&groundBodyDef);
	
	b2EdgeShape groundBox;
	
    b2Filter x;
    x.categoryBits = 0x0002;
	
	groundBox.Set(b2Vec2(0,0), b2Vec2(s.width/PTM_RATIO,0));//50/PTM_RATIO
	groundBody->CreateFixture(&groundBox,0)->SetFilterData(x);
    
	groundBox.Set(b2Vec2(0,s.height/PTM_RATIO), b2Vec2(s.width/PTM_RATIO,s.height/PTM_RATIO));
	groundBody->CreateFixture(&groundBox,0)->SetFilterData(x);
	
	// left
	groundBox.Set(b2Vec2(0,s.height/PTM_RATIO), b2Vec2(0,0));
	groundBody->CreateFixture(&groundBox,0)->SetFilterData(x);
	
	// right
	groundBox.Set(b2Vec2(s.width/PTM_RATIO,s.height/PTM_RATIO), b2Vec2(s.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0)->SetFilterData(x);
    
}

#pragma mark Debug
//-(void) draw
//{
//	//
//	// IMPORTANT:
//	// This is only for debug purposes
//	// It is recommend to disable it
//	//
//	[super draw];
//    
//	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
//    
//	kmGLPushMatrix();
//    
//	world->DrawDebugData();
//    
//	kmGLPopMatrix();
//}

- (b2World *)getWorld{
    return world;
}
- (b2Body *)getGroundBody{
    return groundBody;
}
- (MyContactListener *)getContactListener{
    return contactListener;
}
- (void)dealloc{
    delete contactListener;
    delete world;

    [super dealloc];
}
- (void)updateWorldStep:(ccTime )dt{
    int32 velocityIterations = 8; 
    int32 positionIterations = 1; 
    WORLD->Step(dt, velocityIterations, positionIterations);

}
@end
