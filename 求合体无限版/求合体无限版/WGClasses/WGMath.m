//
//  Z_Math.m
//  BugixAdventures
//
//  Created by ZYJ on 13-1-6.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "WGMath.h"

@implementation WGMath

//对 from 到 to 的数组进行随机排列
NSMutableArray* randomFrom(int from,int to){
    NSMutableArray *randomArray = [NSMutableArray arrayWithCapacity:to-from+1];
    
    //初始化 a数组
    for (int i = 0; i < to-from+1; i++) {
        [randomArray addObject:[NSNumber numberWithInteger:i+from]];
    }
    
    NSMutableArray *a = [NSMutableArray array];
    
    //随机 a数组顺序
    
    for (int i = 0; i < to-from+1; i++) {
        NSNumber *number = randomArray[arc4random()%randomArray.count];
        [a addObject:number];
        [randomArray removeObject:number];
    }
    return a;
}
@end
