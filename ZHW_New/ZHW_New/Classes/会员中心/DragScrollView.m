//
//  DragScrollView.m
//  ZHW_New
//
//  Created by BlackApple on 13-4-11.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "DragScrollView.h"

@implementation DragScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
//- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view{
//    if (!_allowTouch) {
//        return NO;
//    }
//    return YES;
//}
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    NSLog(@"开始");
//    [self canCancelContentTouches];
//}

-(UIView*) hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if(testHits){
        return nil;
    }
    
    if(!self.passthroughViews
       || (self.passthroughViews && self.passthroughViews.count == 0)){
        return self;
    } else {
        
        UIView *hitView = [super hitTest:point withEvent:event];
        
        if (hitView == self) {
            //Test whether any of the passthrough views would handle this touch
            testHits = YES;
            CGPoint superPoint = [self.superview convertPoint:point fromView:self];
            UIView *superHitView = [self.superview hitTest:superPoint withEvent:event];
            testHits = NO;
            
            if ([self isPassthroughView:superHitView]) {
                hitView = superHitView;
            }
        }
        
        return hitView;
    }
}

- (BOOL)isPassthroughView:(UIView *)view {
    
    if (view == nil) {
        return NO;
    }
    
    if ([self.passthroughViews containsObject:view]) {
        return YES;
    }
    
    return [self isPassthroughView:view.superview];
}
@end
