//
//  CommonTableViewCell.m
//  ZHW_New
//
//  Created by BlackApple on 13-4-12.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "CommonTableViewCell.h"
#import "CommonMethod.h"
@interface CommonTableViewCell(){
    int nextTag;
}
@end
@implementation CommonTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        nextTag = 1;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)addLabelsWithMutableArray:(NSMutableArray *)array{
    for (int i = 0; i < array.count; i++) {
        UILabel *label = [[UILabel alloc]init];
        [self addSubview:label];
        label.text = writeEnable(array[i]);
        label.tag = i+1;
        [label setTextColor:[UIColor blackColor]];
        label.textAlignment = UITextAlignmentCenter;
    }
}


- (void)setLabelsFrame:(CGRect )rect, ...{
    va_list args;
    va_start(args, rect);
    [self setLabelFrame:rect vaList:args];
    va_end(args);
}
- (void)setLabelFrame:(CGRect )rect vaList:(va_list )args{
    nextTag = 1;
    
    UILabel *label = (UILabel *)[self viewWithTag:nextTag++];
    label.frame = rect;
    
    CGRect nextFrame = va_arg(args, CGRect);
    
    while (!CGRectEqualToRect(nextFrame, CGRectNull)) {
        UILabel *label = (UILabel *)[self viewWithTag:nextTag++];
        label.frame = nextFrame;
        
        nextFrame = va_arg(args, CGRect);
    }
}

- (void)dealloc{
    for (UIView *s in self.subviews) {
        [s removeFromSuperview];
    }
    [super dealloc];
}
@end
