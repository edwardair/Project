//
//  NAMenuModel.m
//  cqhot
//
//  Created by ZL on 13-4-3.
//  Copyright (c) 2013年 gitmac. All rights reserved.
//

#import "MenuView.h"
#import "CQHotController.h"

@implementation MenuView

- (id)initWithItems:(NSArray *)aItems rect:(CGRect)frame {
  self = [super init];
  self.backgroundColor = [UIColor clearColor];
  self.frame           = frame;
  self.menuDelegate    = self;
  
  NSMutableArray *iTmps = [[NSMutableArray alloc] init];
  for (int i = 0; i < [aItems count]; i++){
    NSDictionary *dctTmp  = [aItems objectAtIndex:i];
    NAMenuItem *item      = [[NAMenuItem alloc] initWithTitle:[dctTmp valueForKey:@"title"]
                                                        image:[UIImage imageNamed:[dctTmp valueForKey:@"icon"]]
                                                      vcClass:[CQHotController class]];
    item.userinfo = dctTmp;
    [iTmps addObject:item];
    item = nil;
  }
  items = [[NSMutableArray alloc] initWithArray:iTmps];
  iTmps = nil;
  return self;
}


- (NAMenuItem *)objectForIndex:(NSInteger)index {
  return [items objectAtIndex:index];
}

#pragma mark -
#pragma mark NAMenuViewDelegate


- (NSUInteger)menuViewNumberOfItems:(NAMenuView *)menuView {
  return [items count];
}
- (NAMenuItem *)menuView:(NAMenuView *)menuView itemForIndex:(NSUInteger)index {
  return [items objectAtIndex:index];
  
}
- (void)menuView:(NAMenuView *)menuView didSelectItemAtIndex:(NSUInteger)index {
  if (_mDelegate && [_mDelegate respondsToSelector:@selector(menuView:didSelectItemAtIndex:)]) {
    [_mDelegate menuView:self didSelectItemAtIndex:index];
  }
}
@end
