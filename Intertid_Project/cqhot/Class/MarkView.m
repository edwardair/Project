//
//  MarkView.m
//  cqhot
//
//  Created by ZL on 13-4-11.
//  Copyright (c) 2013年 gitmac. All rights reserved.
//

#import "MarkView.h"

@implementation MarkView


- (void)setStar:(NSInteger)star {
  _star = star;
  NSArray *s = [self subviews];
  for (int i = 0 ; i < star; i++) {
    [[s objectAtIndex:i] setHighlighted:YES];
  }
  
}


@end
