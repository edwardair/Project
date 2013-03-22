//
//  Z_Math.h
//  BugixAdventures
//
//  Created by ZYJ on 13-1-6.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

//两点式方程：(x-x1)*(y2-y1)=(y-y1)*(x2-x1)
//返回1 为三点共线 否则不共线
#define isThreePointCollineation(p1,p2,p3) (p3.x-p1.x)*(p2.y-p1.y)==(p3.y-p1.y)*(p2.x-p1.x) ? 1 : 0
#define WGRandomFrom(from,to) randomFrom(from,to)
@interface WGMath : NSObject {
    
}
NSMutableArray* randomFrom(int from,int to);
@end
