//
//  StaticManager.m
//  ZhiHuiWang
//
//  Created by BlackApple on 13-4-1.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "StaticManager.h"

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
@end
