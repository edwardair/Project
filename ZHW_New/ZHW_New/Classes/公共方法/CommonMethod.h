//
//  CommonMethod.h
//  ZHW_New
//
//  Created by BlackApple on 13-4-10.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import <Foundation/Foundation.h>

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

@interface CommonMethod : NSObject
CGRect applicationFrame();
CGSize screenSize();
NSString *writeEnable(NSString *text);
//打印
void NSLogFrame(CGRect frame);
void NSLogCGPoint(CGPoint point);
void NSLogString(id obj);
void NSLogFloat(float i);
@end


@protocol TapResignKeyBoardDelegate;
@interface TapResignKeyBoard : NSObject{
    id<TapResignKeyBoardDelegate> _tapDelegate;
}
@property (nonatomic,assign) id<TapResignKeyBoardDelegate> tapDelegate;
//上一次记录的delegate  用于pushView popView的情况下 界面不会再次刷新 手动在pushView中设置
@property (nonatomic,assign) id<TapResignKeyBoardDelegate> preDelegate;


+(TapResignKeyBoard *)shareTapResignKeyBoard;
- (void)removeGestureFromRootViewController;
- (void)addGestureToRootViewController;
- (void)resignKeyBoard; //手动注销键盘
@end

@protocol TapResignKeyBoardDelegate <NSObject>
@required

//将要适配坐标的父view
- (UIView *)willFitPointOfView;//方法实现中一般用一个全局临时变量来返回
//- (float )orgCenterYOfView;//所要移动的view的初始中心Y坐标 
//当前点中的编辑框 textField 或者textView
- (UIView *)curClickedText;//方法实现中一般用一个全局临时变量来返回
//状态栏是否存在
- (BOOL)statusBarShow;
//导航栏是否存在
- (BOOL)navigationBarShow;
@optional
//键盘显现
- (void)keyBoardWillAppearDelegate;
- (void)keyBoardWillDisAppearDelegate;
@end





