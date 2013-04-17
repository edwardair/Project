//
//  TapBeganGestureRecognizer.m
//  WorkPlace
//
//  Created by 丝瓜&冬瓜 on 13-4-17.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "TapBeganGestureRecognizer.h"

@implementation TapBeganGestureRecognizer
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    NSLog(@"触摸上");
    return NO;
}
@end
