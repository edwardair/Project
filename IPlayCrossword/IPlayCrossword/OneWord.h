//
//  OneWord.h
//  iPlayCrossWord
//
//  Created by 丝瓜&冬瓜 on 13-4-29.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "cocos2d.h"
#import "WGCocos2d.h"
typedef enum WordCellState:NSInteger{
    UnSelectable,//不可点击
    NonEntry,//未输入文字
    Entryed,//已输入文字
}WordCellState;
@interface OneWord : WGSprite {
    
}
@property (nonatomic,retain) NSString *wordPlacement;//样式 @"0*0"
@property (nonatomic,assign) BOOL selectEnable;
@property (nonatomic,retain) NSString *text;//格子文字
@property (nonatomic,retain) NSMutableArray *questions;
@property (nonatomic,retain) NSMutableArray *answers;
@property (nonatomic,retain) CCLabelTTF *textTTF;

@property (nonatomic,assign) BOOL selected;
@property (nonatomic,assign) int whichQuestion;

@end
