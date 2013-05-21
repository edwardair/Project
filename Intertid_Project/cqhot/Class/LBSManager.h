//
//  LBSManager.h
//  cqhot
//
//  Created by ZL on 4/22/13.
//  Copyright (c) 2013 gitmac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBSManager : CLLocationManager<CLLocationManagerDelegate>

@property (assign, nonatomic) CLLocationCoordinate2D coor;


+ (LBSManager *)sharedManager;
@end
