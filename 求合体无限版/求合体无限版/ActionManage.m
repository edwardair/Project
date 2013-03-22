//
//  AvtionManager.m
//  求合体无限版
//
//  Created by ZYJ on 13-3-12.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "ActionManage.h"
#import "OneObject.h"
#define Length 10.f
@implementation ActionManage
+(void)preCheckActionWithArray:(NSMutableArray *)array centerPos:(CGPoint )center{
    for (NSMutableDictionary *dic in array) {
        for (CCNode *node in dic.allValues) {
            float x,y;
            float length = ccpDistance(center, node.position);
            x = Length/length*(center.x-node.position.x);
            y = Length/length*(center.y-node.position.y);
            id move = [CCMoveBy actionWithDuration:.3 position:ccp(x, y)];
            id moveReverse = [move reverse];
            id seq = [CCSequence actions:move,moveReverse, nil];
            [node runAction:[CCRepeatForever actionWithAction:seq]];
        }
    }
}
+(void)stopObjectAllActions:(NSMutableArray *)array{
    for (NSMutableDictionary *dic in array) {
        for (OneObject *node in dic.allValues) {
            if ([[NSThread currentThread] isCancelled]) {
                [NSThread exit];
            }
            if (node.numberOfRunningActions) {
                [node stopAllActions];
                node.position = node.originalPosition;
            }
        }
    }
}
+(void)removeObjectWithArray:(NSMutableArray *)array centerPos:(CGPoint )center{
    NSMutableArray *temp = [array mutableCopy];
    [array removeAllObjects];
    for (NSMutableDictionary *dic in temp) {
        for (OneObject *node in dic.allValues) {
            id moveTo = [CCMoveTo actionWithDuration:.5f position:center];
            id scale = [CCScaleTo actionWithDuration:.5f scale:0.f];
            id callFunN = [CCCallFuncN actionWithTarget:node selector:@selector(removeFromParentAndCleanup:)];
            [node runAction:[CCSequence actions:[CCSpawn actions:moveTo,scale, nil],callFunN, nil]];
        }
    }
}

@end
