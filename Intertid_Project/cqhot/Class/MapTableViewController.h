//
//  MapTableViewController.h
//  cqhot
//
//  Created by ZL on 4/25/13.
//  Copyright (c) 2013 gitmac. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MapTableDelegate;

@interface MapTableViewController : UITableViewController


@property (copy, nonatomic) NSArray *items;
@property (assign, nonatomic) id<MapTableDelegate>delegate;


@end


@protocol MapTableDelegate <NSObject>

- (void)mapTableItems:(NSArray *)items didSelectedIndexPath:(NSIndexPath *)indexPath;

@end