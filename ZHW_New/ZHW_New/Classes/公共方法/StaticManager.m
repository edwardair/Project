//
//  StaticManager.m
//  ZhiHuiWang
//
//  Created by BlackApple on 13-4-1.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "StaticManager.h"
static UIView *parentView;
static float parentViewCenterY;
#define KeyBoardHeight 300.0
@implementation StaticManager
#pragma mark 弹出警告
+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)msg
                  delegate:(id )delegate
         cancelButtonTitle:(NSString *)cancle
          otherButtonTitle:(NSString *)other{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:msg delegate:delegate cancelButtonTitle:cancle otherButtonTitles:other, nil];
    [alert show];
}
+ (void)chooseCover:(UIImageView *)cover MoveTo:(CGPoint )center{
    [UIView beginAnimations:@"Cover" context:nil];
    [UIView setAnimationDuration:.5f];
    cover.center = center;
    
    [UIView commitAnimations];
}
#pragma mark 点击TextField TextView时 是屏幕内容自适应键盘高度
+(void)TextInputAnimationWithParentView:(UIView *)view textView:(UIView *)textView{
    parentView = view;
    parentViewCenterY = view.center.y;
    
    float textCenterY = textView.center.y;
    float textWillCenterY = KeyBoardHeight+textView.frame.size.height/2;
    float sub = textWillCenterY-textCenterY;
    
    [UIView beginAnimations:@"MoveUp" context:nil];
    [UIView setAnimationDuration:.2f];
    NSLog(@"上移 ");
    view.transform = CGAffineTransformMakeTranslation(0, sub);
    [UIView commitAnimations];

}
#pragma mark 注销键盘时 是屏幕内容返回初始位置
+(void)resignParentView{
    [UIView beginAnimations:@"MoveDown" context:nil];
    [UIView setAnimationDuration:.2f];
    if (parentView) {
        NSLog(@"下移 ");
        parentView.transform = CGAffineTransformMakeTranslation(0, parentViewCenterY-parentView.center.y);
    }
    [UIView commitAnimations];
}


@end
