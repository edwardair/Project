//
//  StaticManager.h
//  ZhiHuiWang
//
//  Created by BlackApple on 13-4-1.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StaticManager : NSObject
+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)msg
                  delegate:(id )delegate
         cancelButtonTitle:(NSString *)cancle
          otherButtonTitle:(NSString *)other;
+ (void)chooseCover:(UIImageView *)cover MoveTo:(CGPoint )center;
@end
