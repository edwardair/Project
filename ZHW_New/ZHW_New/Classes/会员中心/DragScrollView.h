//
//  DragScrollView.h
//  ZHW_New
//
//  Created by BlackApple on 13-4-11.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DragScrollView : UIScrollView{
    BOOL testHits; 
}
//@property (nonatomic) BOOL allowTouch;

@property (nonatomic, copy) NSArray *passthroughViews;
@end
