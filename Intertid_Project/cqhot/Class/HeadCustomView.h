//
//  HeadCustomView.h
//  cqhot
//
//  Created by ZL on 13-4-15.
//  Copyright (c) 2013年 gitmac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarkView.h"

@interface HeadCustomView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *consumeLabel;
@property (weak, nonatomic) IBOutlet MarkView *markView;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end
