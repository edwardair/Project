//
//  CommonMethod.m
//  ZHW_New
//
//  Created by BlackApple on 13-4-10.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "CommonMethod.h"
#import "StaticManager.h"
@implementation CommonMethod
//获取屏幕可用 Frame
CGRect applicationFrame(){
    CGRect frame = [[UIScreen mainScreen]applicationFrame];
    return frame;
}
//获取屏幕完整 Size
CGSize screenSize(){
    CGSize size = [[UIScreen mainScreen] bounds].size;
    return size;
}
//检测NSString是否为空 空返回空字符串
NSString *writeEnable(NSString *text){
    return (text&&![text isEqual:[NSNull null]])?text:@"";
}
#pragma mark  NSLog 
void NSLogFrame(CGRect frame){
    NSLog(@"%f,%f,%f,%f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
}
void NSLogCGPoint(CGPoint point){
    NSLog(@"%f,%f",point.x,point.y);
}
void NSLogString(NSString *str){
    NSLog(@"%@",str);
}
void NSLogInt(int i){
    NSLog(@"%d",i);
}

#pragma mark ----------------------

@end
#pragma mark 点击注销键盘手势
static TapResignKeyBoard *tapResignKeyBoard = nil;
@interface TapResignKeyBoard()
@property (strong,nonatomic) id target;
@property (nonatomic) SEL selector;
@property (strong,nonatomic) id parentView;

@end
@implementation TapResignKeyBoard
+(TapResignKeyBoard *)shareTapResignKeyBoard{
    if (!tapResignKeyBoard) {
        tapResignKeyBoard = [[TapResignKeyBoard alloc]init];
        [tapResignKeyBoard addTarget:tapResignKeyBoard action:@selector(removeGestureRecognizer)];
    }
    return tapResignKeyBoard;
}
- (void)addTarget:(id)target action:(SEL)action parentView:(id )view{
    if (_parentView) {
        [_parentView removeGestureRecognizer:self];
    }
    [view addGestureRecognizer:self];
    
    _parentView = view;
    _target = target;
    _selector = action;
    
}
- (void)removeGestureRecognizer{
    
    [_parentView removeGestureRecognizer:self];
    _parentView = nil;
    
    [StaticManager resignParentView];
    if ([_target respondsToSelector:_selector]) {
        [_target performSelector:_selector];
    }
    
}

@end


