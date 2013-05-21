//
//  AnswerInterface.h
//  iPlayCrossWord
//
//  Created by 丝瓜&冬瓜 on 13-5-2.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WGCocos2d.h"

@protocol AnswerDelegate;

@interface AnswerInterface : WGLayer<UITextFieldDelegate> {
    id<AnswerDelegate> delegate;
}
@property (nonatomic,assign) id<AnswerDelegate> delegate;
@property (nonatomic,retain) UILabel *question;
@property (nonatomic,retain) UITextField *answer;
@property (nonatomic,assign) int answerLength;
@property (nonatomic,retain) UIView *loadView;
+ (id )initizlizeWithQ:(NSString *)question AndA:(NSString *)answer;
- (void)moveToHide;
@end

@protocol AnswerDelegate <NSObject>

- (void)UITextFieldShouldReturn;

@end
