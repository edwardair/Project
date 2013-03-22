//
//  WorldPointDic.m
//  求合体无限版
//
//  Created by ZYJ on 13-3-11.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "WorldDataModel.h"
#import "Define.h"
#import "WGSprite.h"
#import "MapShow.h"
@implementation WorldDataModel
//+(NSMutableDictionary *)initWorldPointDic{
//    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:LineCount*LineCount];
//    for (int i = 0; i < LineCount; i++) {
//        for (int j = 0; j < LineCount; j++) {
//            CGPoint p = ccpAdd(PointOfLeftUpCorner, ccp(j*PicWidth, -i*PicWidth));
//            [dic setObject:[NSValue valueWithCGPoint:p] forKey:Name(i,j)];
//        }
//    }
//    return dic;
//}
+(NSMutableDictionary *)initWorldObjectDic{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:LineCount*LineCount];
//    for (int i = 0; i < LineCount; i++) {
//        for (int j = 0; j < LineCount; j++) {
//            [dic setObject:[NSNumber numberWithInt:0] forKey:Name(i,j)];
//        }
//    }
    return dic;
}
//+(NSMutableDictionary *)initMapBlockTypeDic{
//    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:LineCount*LineCount];
//    for (int i = 0; i < LineCount; i++) {
//        for (int j = 0; j < LineCount; j++) {
//            [dic setObject:UDLR forKey:Name(i,j)];
//        }
//    }
//    NSLog(@"%@",dic);
//    return dic;
//}
+(NSMutableDictionary *)initMapBlockDic{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:LineCount*LineCount];
    for (int i = 0; i < LineCount; i++) {
        for (int j = 0; j < LineCount; j++) {
            if ((i+j)==0) {//不记录 0，0 位置，此处作为仓库使用
                continue;
            }
            NSString *name = Name(i, j);
            MapShow *mapBlock = [MapShow initWithType:Empty];
            mapBlock.position = BlockPosition(name);
            mapBlock.mapBlockName = name;
            [WGDirector addTargetedDelegate:mapBlock priority:0 swallowsTouches:YES];
            [dic setObject:mapBlock forKey:name];
        }
    }
    return dic;
}

@end
