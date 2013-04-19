//
//  CommonMethod.h
//  ZHW_New
//
//  Created by BlackApple on 13-4-10.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DefaultSystemFontSize 18.f

@interface CommonMethod : NSObject
CGRect applicationFrame();
CGSize screenSize();
NSString *writeEnable(NSString *text);
//打印
void NSLogFrame(CGRect frame);
void NSLogCGPoint(CGPoint point);
void NSLogString(id obj);
void NSLogInt(int i);
UIFont *systemFontSize(float size);
+(void)autoSizeLabel:(UILabel *)label withFont:(UIFont *)font;
@end


@interface TapResignKeyBoard : UITapGestureRecognizer
+(TapResignKeyBoard *)shareTapResignKeyBoard;
- (void)addTarget:(id)target action:(SEL)action parentView:(id )view;
- (void)removeGestureRecognizer;
@end