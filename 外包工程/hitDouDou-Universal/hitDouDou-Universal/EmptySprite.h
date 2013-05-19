//
//  EmptySprite.h
//  hitDouDou
//
//  Created by YJ Z on 12-9-20.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Sprite.h"
@interface EmptySprite : Sprite {
    
}
@property (nonatomic,assign) CGPoint orgPosition;
@property (nonatomic,assign) BOOL didPhysicsExist;
@property (nonatomic,retain) NSMutableArray *spriteContains;
@property (nonatomic,assign) int flg;
@property (nonatomic,retain) NSObject *fixtureSp;
+(id)initEmptySprite:(CGPoint )p;
@end
