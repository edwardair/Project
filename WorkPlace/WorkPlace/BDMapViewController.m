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
#import "MoviePlayController.h"
#import "AppDelegate.h"
#import "LogInViewController.h"
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
- (void)logOut{
    NSLogString(@"注销");
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    LogInViewController *login = [[LogInViewController alloc]initWithNibName:@"LogInViewController" bundle:nil];
    app.window.rootViewController = login;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *logOut = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Logout.png"] style:UIBarButtonItemStylePlain target:self action:@selector(logOut)];
    self.navigationItem.rightBarButtonItem = logOut;
    
    // Do any additional setup after loading the view from its nib.
    BMKMapView* mapView = [[BMKMapView alloc]initWithFrame:applicationFrame()];
    self.view = mapView;
    mapView.delegate = self;
    
    [mapView setShowsUserLocation:YES];
    
    _coordDic = [[NSMutableDictionary alloc]init];

    NSArray *coords = [NSArray arrayWithObjects:
                       @"31.528644,120.321171",
                       @"31.528644,120.821171",
                       @"31.528644,121.321171",
                       @"31.528644,121.821171",
                       @"31.528644,122.321171",
                       nil];
    
    NSArray *keys = [NSArray arrayWithObjects:@"name",@"jlunit",@"sgunit",@"lxr",@"tel",nil];
    
    NSArray *names = [NSArray arrayWithObjects:@"项目一",@"项目二",@"项目三",@"项目四",@"项目五", nil];
    NSArray *jlUnit = [NSArray arrayWithObjects:@"A",@"AA",@"AAA",@"AAAA",@"AAAAA", nil];
    NSArray *sgUnit = [NSArray arrayWithObjects:@"A",@"AA",@"AAA",@"AAAA",@"AAAAA", nil];
    NSArray *lxr = [NSArray arrayWithObjects:@"A",@"AA",@"AAA",@"AAAA",@"AAAAA", nil];
    NSArray *tel = [NSArray arrayWithObjects:@"13800000000",@"13800000000",@"13800000000",@"13800000000",@"13800000000", nil];


    for (int i = 0; i < 5; i++) {
        int j = 0;
        NSMutableDictionary *pro = [NSMutableDictionary dictionary];
        [pro setObject:names[i] forKey:keys[j++]];
        [pro setObject:jlUnit[i] forKey:keys[j++]];
        [pro setObject:sgUnit[i] forKey:keys[j++]];
        [pro setObject:lxr[i] forKey:keys[j++]];
        [pro setObject:tel[i] forKey:keys[j++]];
        
        [_coordDic setObject:pro forKey:coords[i]];

    }
    
    NSLogString(_coordDic);

    for (NSString *key in _coordDic.allKeys) {
        NSArray *coord = [key componentsSeparatedByString:@","];

        CLLocationCoordinate2D coord2D;
        coord2D.latitude = [[NSDecimalNumber decimalNumberWithString:coord[0]] doubleValue];
        coord2D.longitude = [[NSDecimalNumber decimalNumberWithString:coord[1]] doubleValue];

        BMKPointAnnotation *annotation  =[[BMKPointAnnotation alloc]init];
        annotation.coordinate = coord2D;
        annotation.title = [[_coordDic objectForKey:key] objectForKey:@"name"];
        
        [mapView addAnnotation:annotation];
        
        [annotation release];

    }
    
}
// Override
#define ReuseIdentifier @"myAnnotation"
- (BMKPinAnnotationView *)definedBMKPinAnnotationView:(id<BMKAnnotation>)annotation{
   BMKPinAnnotationView *newAnnotationView =[[BMKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:ReuseIdentifier];
    newAnnotationView.pinColor = BMKPinAnnotationColorRed;
    
    newAnnotationView.animatesDrop = YES;//设置该标注点动画显示
    
    UIImage *image = [UIImage imageNamed:@"RightDir.png"];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image highlightedImage:image];
    newAnnotationView.rightCalloutAccessoryView = imageView;
    

    return newAnnotationView;
}
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        NSLogString(@"创建");
    
        BMKPinAnnotationView *newAnnotationView = [self definedBMKPinAnnotationView:annotation];
        
        return newAnnotationView ;
    }
    return nil;
}


static BOOL didLocation = NO;
- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation{
    if (userLocation != nil && !didLocation) {
        didLocation = YES;

        mapView.centerCoordinate = userLocation.coordinate;
        NSLog(@"%f,%f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        
    }
}
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view{
    MoviePlayController *movie = [[MoviePlayController alloc]initWithNibName:@"MoviePlayController" bundle:nil];
    [self.navigationController pushViewController:movie animated:YES];
    
    BMKPointAnnotation *pin = (BMKPointAnnotation *)view.annotation;
    NSString *key = [NSString stringWithFormat:@"%.6f,%.6f",pin.coordinate.latitude,pin.coordinate.longitude];
    
    NSMutableArray *array = [NSMutableArray arrayWithObjects:
                             [[_coordDic objectForKey:key] objectForKey:@"name"],
                             [[_coordDic objectForKey:key] objectForKey:@"jlunit"],
                             [[_coordDic objectForKey:key] objectForKey:@"sgunit"],
                             [[_coordDic objectForKey:key] objectForKey:@"lxr"],
                             [[_coordDic objectForKey:key] objectForKey:@"tel"],
                             nil];
    movie.dataSource = array;
    movie.title = [[_coordDic objectForKey:key] objectForKey:@"name"];
    [movie release];
}
- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
	if (error != nil)
		NSLog(@"locate failed: %@", [error localizedDescription]);
	else {
		NSLog(@"locate failed");
	}
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
