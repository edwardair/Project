//
//  OneObject.h
//  求合体无限版
//
//  Created by ZYJ on 13-3-11.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WGCocos2d.h"
@protocol OneObjectDelegate;

@interface OneObject : WGSprite <NSMutableCopying>{
    id<OneObjectDelegate> delegate;
}
@property (nonatomic,assign) id<OneObjectDelegate> delegate;
@property (nonatomic,assign) int kType;
@property (nonatomic,assign) CGPoint originalPosition;
@property (nonatomic,retain) NSString *nameOfObjOnBlock;
@property (nonatomic,retain) NSMutableArray *allKindsOfDic;

+(id )randomInitializeObject;
+(id )selectedInitializeObjectWithType:(int)kType levelUP:(BOOL )up;
- (void)setCombiningObjsStopAllActions;
- (BOOL)checkPosInRightRrea:(CGPoint )p;
- (void)checkAroundPrePlaced:(NSMutableDictionary *)mapBlockDic;
- (void)placeObj;
- (void)revocationPlaceObj:(OneObject *)placing;
- (void)removeAllObjects;
@end

@protocol OneObjectDelegate <NSObject>

@required
- (void)placeOneObject;
- (void)combiningMultiObjects:(NSMutableArray *)array;
- (void)revocationPlacing:(OneObject *)placing;
@end

