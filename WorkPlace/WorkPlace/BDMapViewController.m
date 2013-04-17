//
//  BDMapViewController.m
//  WorkPlace
//
//  Created by BlackApple on 13-4-17.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "BDMapViewController.h"
#import "CommonMethod.h"
#import "TapBeganGestureRecognizer.h"
@interface BDMapViewController ()

@end

@implementation BDMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    BMKMapView* mapView = [[BMKMapView alloc]initWithFrame:applicationFrame()];
    self.view = mapView;
    mapView.delegate = self;
    
    
    [mapView setShowsUserLocation:YES];
    
}
// Override
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView  = [[BMKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorRed;
        newAnnotationView.animatesDrop = YES;//设置该标注点动画显示
        
        TapBeganGestureRecognizer *began = [[TapBeganGestureRecognizer alloc]initWithTarget:self action:@selector   (touchBegan)];
        [newAnnotationView addGestureRecognizer:began];
        began.delegate = began;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(abc)];
//        [newAnnotationView addGestureRecognizer:tap];
//        tap.delegate = self;
//        [tap setCancelsTouchesInView:YES];
        
        
        [newAnnotationView setDraggable:YES];
        return newAnnotationView ;
    }
    return nil;
}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    NSLog(@"触摸");
    return NO;
}
- (void)abc{
    NSLogString(@"123");
}

static BOOL didLocation = NO;
- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation{
    if (userLocation != nil && !didLocation) {
        didLocation = YES;
        NSLog(@"%f,%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
        mapView.centerCoordinate = userLocation.coordinate;
        BMKPointAnnotation *annotation  =[[BMKPointAnnotation alloc]init];
        
        annotation.coordinate = mapView.centerCoordinate;
        annotation.title = @"北京";
        [mapView addAnnotation:annotation];
        
        [annotation release];

        UIGestureRecognizer
    }
//    [mapView set]
}
- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
	if (error != nil)
		NSLog(@"locate failed: %@", [error localizedDescription]);
	else {
		NSLog(@"locate failed");
	}
	
}
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    NSLog(@"%@",view.annotation.title);
}
- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view{
    NSLog(@"132");
}
- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
	NSLog(@"start locate");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
