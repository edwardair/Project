//
//  WGTableViewCell.m
//  Test
//
//  Created by Apple on 13-6-9.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import "WGTableViewCell.h"

@implementation WGTableViewCell
+(WGTableViewCell *)initializeWithFrame:(CGSize )size
                                   font:(UIFont *)font
                                  style:(UITableViewCellStyle )style
                    reuseIdentifier:(NSString *)reuseIdentifier{
    WGTableViewCell *cell = [[[WGTableViewCell alloc]initWithStyle:style reuseIdentifier:reuseIdentifier] autorelease];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    [cell addSubview:label];
    [label setTextAlignment:NSTextAlignmentLeft];
    [label setTextColor:[UIColor blackColor]];
    label.backgroundColor = [UIColor clearColor];
    [label setFont:font];
    cell.cellLabel = label;
    [label release];
    
    return cell;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)dealloc{
    self.cellLabel = nil;
    [super dealloc];
}
@end
