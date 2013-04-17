//
//  StaticManager.m
//  ZhiHuiWang
//
//  Created by BlackApple on 13-4-1.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "StaticManager.h"
#import "CommonMethod.h"    
static UIView *parentView;
static float parentViewCenterY;
#define KeyBoardHeight 216.0
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
+(float )isParentView:(UIView *)parent sub:(UIView *)sub center:(float )posY{
//    float textCenterY = sub.center.y;
    if (![sub.superview isEqual:parent]) {
        NSLog(@"%f",posY);
        CGRect subFrame = sub.frame;
        subFrame = [sub.superview convertRect:subFrame toView:sub.superview.superview];
        CGRect parFrame = sub.superview.frame;
        NSLog(@"%f,%f",sub.frame.origin.y,parFrame.origin.y);

        posY += subFrame.origin.y-parFrame.origin.y;
        NSLog(@"%f",posY);

        posY = [StaticManager isParentView:parent sub:sub.superview center:posY];
    }
    return posY;
}
+(void)TextInputAnimationWithParentView:(UIView *)view textView:(UIView *)textView{
    float posY = 0;
    posY = [StaticManager isParentView:view sub:textView center:posY];
    NSLog(@"%f",posY);
    float textCenterY = posY+textView.frame.size.height/2;
    float textWillCenterY = applicationFrame().size.height - KeyBoardHeight - textView.frame.size.height/2;
    float sub = textWillCenterY-textCenterY;
    
    if (sub<0) {
        parentView = view;
        parentViewCenterY = view.center.y;
    }else
        return;

    
    [UIView beginAnimations:@"MoveUp" context:nil];
    [UIView setAnimationDuration:.2f];
    NSLog(@"上移 ");
    view.transform = CGAffineTransformMakeTranslation(0, sub);
    [UIView commitAnimations];

}
//+(void)TextInputAnimationWithParentView:(UIView *)view textViewFrame:(CGRect )subFrame{
//    float textCenterY = subFrame.origin.y+subFrame.size.height/2;
//
//    float textWillCenterY = applicationFrame().size.height - KeyBoardHeight - subFrame.size.height/2;
//
//    float sub = textWillCenterY-textCenterY;
//    NSLog(@"%f",sub);
//    if (sub<0) {
//        parentView = view;
//        parentViewCenterY = view.center.y;
//    }else
//        return;
//    
//    [UIView beginAnimations:@"MoveUp" context:nil];
//    [UIView setAnimationDuration:.2f];
//    NSLog(@"上移 ");
//    view.transform = CGAffineTransformMakeTranslation(0, sub);
//    [UIView commitAnimations];
//
//}
#pragma mark 注销键盘时 是屏幕内容返回初始位置
+(void)resignParentView{
    if (parentView) {
        [UIView beginAnimations:@"MoveDown" context:nil];
        [UIView setAnimationDuration:.2f];
        NSLog(@"下移 ");
        parentView.transform = CGAffineTransformMakeTranslation(0, parentViewCenterY-parentView.center.y);
        [UIView commitAnimations];
        parentView = nil;
    }
}

#pragma mark  通过UIView 获取此View的superView的UIViewController
UIViewController *UIViewControllerOfSuperView(UIView *view){
//    if (view.superview) {
//        NSLog(@"yes");
//    }
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}
#pragma mark 处理时间格式 2012-12-12T00：00：00  将“T”替换为“ ”
+ (NSString *)formateTimeString:(NSString *)s{
    s = writeEnable(s);
    //TODO: 4.17号  检测时间 s 是否为空
    if (![s isEqualToString:@""]) {
        NSMutableString *m_Start = [NSMutableString stringWithString:s];
        [m_Start replaceCharactersInRange:[m_Start rangeOfString:@"T"] withString:@" "];
        return (NSString *)m_Start;
    }else
        return s;
}
@end
