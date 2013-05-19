//
//  OneWord.m
//  iPlayCrossWord
//
//  Created by 丝瓜&冬瓜 on 13-4-29.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "OneWord.h"

//静态类  储存最近一次所点中的OneWord 
//static OneWord *staticOneWord = nil;

@interface OneWord(){
    
}
@property (nonatomic,retain) CCLayerColor *layerColor;
@end
@implementation OneWord

- (NSMutableArray *)questions{
    if (!_questions) {
        _questions = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _questions;
}
- (NSMutableArray *)answers{
    if (!_answers) {
        _answers = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return _answers;
}
//更改 格子所包含的文字
- (void)setText:(NSString *)text{
    if (!_text) {
        _textTTF = [CCLabelTTF labelWithString:text fontName:@"AppleGothic" fontSize:20.f];
        [self addChild:_textTTF];
        _textTTF.color = ccBLACK;
        _textTTF.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
    }else{
        _textTTF.string = text;
    }
    if (text) {
        if (_textTTF.numberOfRunningActions!=0) {
            [_textTTF stopAllActions];
        }
        [_textTTF runAction:[CCSequence actions:[CCScaleTo actionWithDuration:.2 scale:1.3f],[CCScaleTo actionWithDuration:.2 scale:1.f], nil]];
    }
    [_text release];
    _text = nil;
    _text = [text retain];
}
- (void)setSelectEnable:(BOOL)selectEnable{
    _selectEnable = selectEnable;
    int cl = selectEnable?255:0;
    self.layerColor.color = ccc3(cl, cl, cl);
    self.allowTouch = selectEnable;
}
- (CCLayerColor *)layerColor{
    if (!_layerColor) {
        _layerColor = [CCLayerColor layerWithColor:ccc4(255, 255, 255, 255) width:30 height:30];
        [self addChild:_layerColor];
    }
    return _layerColor;
}
- (void)setSelected:(BOOL)selected{
    if (selected) {
        self.layerColor.color = ccc3(255, 0, 0);
    }else{
        self.layerColor.color = ccc3(255, 255, 255);
    }
}
- (id)init{
    if (self == [super initWithFile:@"Black.png"]) {

        [self setContentSize:CGSizeMake(30, 30)];
        [[Director touchDispatcher] addTargetedDelegate:self priority:-1 swallowsTouches:YES];

//        //默认可点击
//        self.selectEnable = YES;
    }
    return self;
}
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    
    if (_questions.count>1) {
        _whichQuestion = _whichQuestion==0?1:0;
    }else{
        _whichQuestion = 0;
    }
    
    [super ccTouchEnded:touch withEvent:event];
    
    
}
- (void)dealloc{
    [super dealloc];
}

@end
