//
//  IFTableController.h
//  cqhot
//
//  Created by ZL on 13-4-9.
//  Copyright (c) 2013年 gitmac. All rights reserved.
//

#import "EUViewController.h"

@interface InfoTableController : EUViewController

@property (strong, nonatomic) NSURL *URL;
/**
 * 类型参数:
 * 1:CQHotViewControlelr->
 * 2:CQHotViewControlelr->InfoTableController->
 */
@property (assign, nonatomic) NSInteger integerType;

@property (strong, nonatomic) NSArray *category;
@property (strong, nonatomic) NSString *categoryTitle;

@end
