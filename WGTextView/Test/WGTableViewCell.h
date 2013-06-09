//
//  WGTableViewCell.h
//  Test
//
//  Created by Apple on 13-6-9.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WGTableViewCell : UITableViewCell
@property (nonatomic,retain) UILabel *cellLabel;
+(WGTableViewCell *)initializeWithFrame:(CGSize )size
                                   font:(UIFont *)font
                                  style:(UITableViewCellStyle )style
                        reuseIdentifier:(NSString *)reuseIdentifier;
@end
