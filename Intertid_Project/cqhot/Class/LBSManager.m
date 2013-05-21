//
//  LBSManager.m
//  cqhot
//
//  Created by ZL on 4/22/13.
//  Copyright (c) 2013 gitmac. All rights reserved.
//

#import "LBSManager.h"

static LBSManager *manager = nil;
@implementation LBSManager


+ (LBSManager *)sharedManager {
  if (manager == nil) {
    manager = [[LBSManager alloc] init];
    [manager setDesiredAccuracy:kCLLocationAccuracyBest];
  }
  return manager;
}

- (void)startUpdatingLocation {
  self.delegate = self;
  [super startUpdatingLocation];
}

- (void)stopUpdatingLocation {
  [super stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
  CLLocationCoordinate2D loc = [newLocation coordinate];
  NSString *lat =[NSString stringWithFormat:@"%f",loc.latitude];//get latitude
  NSString *lon =[NSString stringWithFormat:@"%f",loc.longitude];//get longitude
  NSLog(@"%@ %@",lat,lon);
  self.coor = loc;
  
  [self stopUpdatingLocation];
}
@end
