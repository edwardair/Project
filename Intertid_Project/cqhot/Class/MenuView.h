//
//  NAMenuModel.h
//  cqhot
//
//  Created by ZL on 13-4-3.
//  Copyright (c) 2013年 gitmac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NAMenuView.h"
#import "NAMenuItem.h"


@interface MenuView : NAMenuView<NAMenuViewDelegate>
{
  @private
    NSArray *items;
}
- (id)initWithItems:(NSArray *)aItems rect:(CGRect)frame;
@property (unsafe_unretained, nonatomic) id <NAMenuViewDelegate> mDelegate;


/**
	<#Description#>
	@param index <#index description#>
	@returns <#return value description#>
 */
- (NAMenuItem *)objectForIndex:(NSInteger)index;


@end
