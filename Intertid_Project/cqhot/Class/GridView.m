//
//  GirdView.m
//  cqhot
//
//  Created by ZL on 4/24/13.
//  Copyright (c) 2013 gitmac. All rights reserved.
//

#import "GridView.h"

@implementation GridView

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

- (IBAction)touchButton:(id)sender {
  [_delegate performSelector:@selector(touchGridView:) withObject:self];
  
}

@end
