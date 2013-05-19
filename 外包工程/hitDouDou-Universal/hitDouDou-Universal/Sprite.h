//
//  Sprite.h
//  hitDouDou
//
//  Created by YJ Z on 12-9-13.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"


//#define RADIUS 8.f
#define RADIUS (([DEVICE isEqualToString:@"-iPhone"])? 10.f:20.f)

#define PhysicsDensity 1.f
#define PhysicsFriction .1f
#define PhysicsAngularDamping 1.f
#define ColorCount 6
@interface Sprite : CCSprite {
    
}
@property (nonatomic,assign) b2Body *physicsBody;

- (CGPoint )b2Vec2ConvertToCGPoint:(b2Vec2 )b2;
- (b2Vec2)CGPointConvertTob2Vec2:(CGPoint )point;
@end
