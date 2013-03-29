//
//  MeetingMemberCell.m
//  ZhiHuiWang
//
//  Created by BlackApple on 13-3-29.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "MeetingMemberCell.h"

@implementation MeetingMemberCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        CGRect telLabelRect = CGRectMake(0, 0, 150, 15);
//        UILabel *label = [[UILabel alloc]initWithFrame:telLabelRect];
//        label.textAlignment = UITextAlignmentCenter;
//        label.text = @"13800000000";
//        label.font = [UIFont boldSystemFontOfSize:12];
//        [self.contentView addSubview:label];
//        self.name = @"名字";
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

@end
