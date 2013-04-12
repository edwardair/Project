//
//  MyCreatedMeetings.m
//  ZHW_New
//
//  Created by BlackApple on 13-4-11.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "MyCreatedMeetings.h"
#import "CommonMethod.h"
#import "SBJsonResolveData.h"
@interface MyCreatedMeetings(){
    CommonTableView *tableView;
}
@end
@implementation MyCreatedMeetings
+(id)initilaize{
    return [[[self class]alloc]initWithFrame:CGRectMake(0, 0, applicationFrame().size.width, applicationFrame().size.height)];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        tableView = [[CommonTableView alloc]initWithFrame:CGRectMake(0, 0, 320, 500)];
        [self addSubview:tableView];
        tableView.commonTableViewDelegate = self;
        tableView.cellTitle = @"MyCreatedMeetings";
        
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
- (void)updateTableViewDataSource{
//    for (<#initialization#>; <#condition#>; <#increment#>) {
//        <#statements#>
//    }
}
- (void)setCellLabelsFrams:(CommonTableViewCell *)cell{
//    [cell setLabelsFrame:
//     CGRectMake(190, 0, 50, 30),
//     CGRectMake(90, 0, 50, 30),
//     CGRectMake(140, 0, 50, 30),
//     CGRectNull];
}
- (void)cellClickedAtIndexPath:(NSIndexPath *)path{
    
}
@end
