//
//  MapViewController.h
//  cqhot
//
//  Created by ZL on 13-4-17.
//  Copyright (c) 2013年 gitmac. All rights reserved.
//

#import "EUViewController.h"
#import "BMapKit.h"
#import "RouteView.h"

@interface MapViewController : EUViewController<BMKMapViewDelegate, BMKSearchDelegate>
@property (weak, nonatomic) IBOutlet UIView *roadView;
@property (weak, nonatomic) IBOutlet RouteView *routeView;
@property (weak, nonatomic) IBOutlet UIView *btnView;


/*
 case 0: //驾车
 [self onClickDriveSearch];
 break;
 case 1://公交
 [self onClickBusSearch];
 break;
 case 2://步行
 [self onClickWalkSearch];
 break;
 */

- (void)onClickDriveSearch;
- (void)onClickBusSearch;
- (void)onClickWalkSearch;

@end
