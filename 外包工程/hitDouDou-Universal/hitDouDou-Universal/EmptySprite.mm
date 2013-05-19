//
//  EmptySprite.m
//  hitDouDou
//
//  Created by YJ Z on 12-9-20.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "EmptySprite.h"

static CGPoint p_;

@implementation EmptySprite
@synthesize orgPosition = _orgPosition;
@synthesize didPhysicsExist = _didPhysicsExist;
@synthesize spriteContains = _spriteContains;
@synthesize flg = _flg;
@synthesize fixtureSp = _fixtureSp;

- (NSMutableArray *)spriteContains{
    if (!_spriteContains) {
        _spriteContains = [[NSMutableArray alloc] initWithCapacity:6];
    }
    return _spriteContains;
}
+(id)initEmptySprite:(CGPoint)p{
    
    p_ = p;
    
    return [[[self alloc] init] autorelease] ;
}
-(id)init{
    if (self == [super init]) {
        [self setContentSize:CGSizeMake(4 , 4 )];
        self.position = p_;
        
        self.flg = -1;
        
        self.orgPosition = p_;
    }
    return self;
}
- (void)dealloc{
    [_spriteContains release];
    _spriteContains = nil;
    
    self.fixtureSp = nil;
    
    [super dealloc];
}
@end
