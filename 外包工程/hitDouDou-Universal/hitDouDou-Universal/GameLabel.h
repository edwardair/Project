//
//  GameLabel.h
//  hitDouDou-Universal
//
//  Created by ZYJ on 12-11-12.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameLabel : CCLayer {
}
@property (nonatomic,retain) CCLabelAtlas *labelPointRate;
@property (nonatomic,retain) CCLabelAtlas *labelCount;
@property (nonatomic,retain) CCLabelAtlas *labelHighest;
//@property (nonatomic,retain) CCLabelAtlas *playerAppraise;

@property (nonatomic,assign) int labelPoint;
@property (nonatomic,assign) int pointRate;

//瞄准线个数
@property (nonatomic,assign) int rayCastNumber;

@end
