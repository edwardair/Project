//
//  HomePageRecommend.m
//  ZHW_New
//
//  Created by BlackApple on 13-4-11.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "HomePageRecommend.h"
#import "CommonMethod.h"

@implementation HomePageRecommend
+(id)initilaize{
    return [[[self class]alloc]initWithFrame:CGRectMake(0, 0, applicationFrame().size.width, applicationFrame().size.height)] ;
}

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

@end
