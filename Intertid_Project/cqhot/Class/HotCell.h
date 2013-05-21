//
//  HotCell.h
//  cqhot
//
//  Created by ZL on 13-4-11.
//  Copyright (c) 2013年 gitmac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarkView.h"

@interface HotCell : UITableViewCell
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *icon;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *title;
@property (unsafe_unretained, nonatomic) IBOutlet MarkView *markView;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *detail;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *distanceLabel;

@end
