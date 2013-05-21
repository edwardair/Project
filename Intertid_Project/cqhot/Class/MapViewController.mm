//
//  MapViewController.m
//  cqhot
//
//  Created by ZL on 13-4-17.
//  Copyright (c) 2013年 gitmac. All rights reserved.
//

#import "MapViewController.h"
#import "BMKAnnotation.h"
#import "AKSegmentedControl.h"
#import "QBPopupMenu.h"
#import "MBProgressHUD.h"
#import "MapTableViewController.h"
#import "LBSManager.h"


// MARK:地图搜索
#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]


BOOL isRetina = FALSE;

@interface RouteAnnotation : BMKPointAnnotation
{
	int _type; ///<0:起点 1：终点 2：公交 3：地铁 4:驾乘
	int _degree;
}

@property (nonatomic) int type;
@property (nonatomic) int degree;
@end

@implementation RouteAnnotation

@synthesize type = _type;
@synthesize degree = _degree;
@end

@interface UIImage(InternalMethod)

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees;

@end

@implementation UIImage(InternalMethod)

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees
{
	CGSize rotatedSize = self.size;
	if (isRetina) {
		rotatedSize.width *= 2;
		rotatedSize.height *= 2;
	}
	UIGraphicsBeginImageContext(rotatedSize);
	CGContextRef bitmap = UIGraphicsGetCurrentContext();
	CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
	CGContextRotateCTM(bitmap, degrees * M_PI / 180);
	CGContextRotateCTM(bitmap, M_PI);
	CGContextScaleCTM(bitmap, -1.0, 1.0);
	CGContextDrawImage(bitmap, CGRectMake(-rotatedSize.width/2, -rotatedSize.height/2, rotatedSize.width, rotatedSize.height), self.CGImage);
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

@end



// MARK:地图控制

@interface MapViewController ()<MapTableDelegate>{
  BMKSearch* _search;
  AKSegmentedControl *segmentedControl1;
  CLLocationCoordinate2D goalCoordinate;

}
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property (nonatomic, strong) QBPopupMenu *popupMenu;

@property (strong,nonatomic) NSArray *steps;
@property (assign, nonatomic) NSInteger currentStep;

//- (void)updateStepRoute;

@end

@implementation MapViewController

- (NSString*)getMyBundlePath1:(NSString *)filename
{
	
	NSBundle * libBundle = MYBUNDLE ;
	if ( libBundle && filename ){
		NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
		NSLog ( @"%@" ,s);
		return s;
	}
	return nil ;
}

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
  [self setMapView:nil];
  [self setRoadView:nil];
  [self setRouteView:nil];
  [self setBtnView:nil];
  [super viewDidUnload];
}

- (void)dealloc
{
  _mapView.showsUserLocation = NO;
//  NSArray *annotions = [[NSArray alloc] initWithArray:_mapView.annotations];
//  [_mapView removeAnnotations:annotions];
//  [[_mapView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
  [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(0, 0)];
  [_mapView setDelegate:nil];
  self.mapView = nil;

}

- (UIBarButtonItem *)rightItem {
  
  UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab_bar_divider.png"]];
  imageView.frame = CGRectMake(0, 1, 1, 42);
  
  
  //action_bar_glyph_location.png
  UIButton *btn         = [UIButton buttonWithType:UIButtonTypeCustom];
  [btn setFrame:CGRectMake(2, 0, 44, 44)];
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 44)];
  [view addSubview:imageView];
  [view addSubview:btn];
  
  __autoreleasing UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:view];
  
  [btn setImage:[UIImage imageNamed:@"action_bar_glyph_location.png"] forState:UIControlStateNormal];
  [btn addTarget:self action:@selector(lbsTo) forControlEvents:UIControlEventTouchUpInside];
  view = nil;
  imageView = nil;
  return item;
}

- (UIBarButtonItem *)leftItem {
  UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tab_bar_divider.png"]];
  imageView.frame = CGRectMake(44, 1, 1, 42);
  
  
  //action_bar_glyph_location.png
  UIButton *btn         = [UIButton buttonWithType:UIButtonTypeCustom];
  [btn setFrame:CGRectMake(0, 0, 44, 44)];
  UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 44)];
  [view addSubview:imageView];
  [view addSubview:btn];
  __autoreleasing UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:view];
  
  [btn setFrame:CGRectMake(0, 0, 44, 44)];
  [btn setImage:[UIImage imageNamed:@"action_bar_glyph_back.png"] forState:UIControlStateNormal];
  [btn addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
  
  view = nil;
  imageView = nil;
  
  return item;
}

- (void)backTo {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)lbsTo {
  _mapView.showsUserLocation = YES;
  [_mapView setCenterCoordinate:_mapView.userLocation.coordinate];
}


- (void)viewWillAppear:(BOOL)animated {
  _mapView.delegate           = self;
  _search.delegate            = self;

}
- (void)initializeViews {
  self.navigationItem.leftBarButtonItem   = [self leftItem];
  self.navigationItem.rightBarButtonItem  = [self rightItem];
  self.title                              = self.userInfo[@"name"];
  
  _search = [[BMKSearch alloc] init];
  _mapView.showsUserLocation  = YES;
  _mapView.zoomLevel = 18;
  
  NSLog(@"%@",[self.userInfo description]);
  


  
  
  CLLocationDegrees latitude        = [self.userInfo[@"latitude"] doubleValue];
  CLLocationDegrees longitude       = [self.userInfo[@"longitude"] doubleValue];
  CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
  
  goalCoordinate = coordinate;
  
  BMKPointAnnotation *annotation  = [[BMKPointAnnotation alloc] init];
  
  
  
  annotation.coordinate           = coordinate;
  annotation.title                = self.userInfo[@"name"];
  [_mapView addAnnotation:annotation];
  
  [_mapView setCenterCoordinate:coordinate animated:YES];
  annotation = nil;
  
  
  // popupMenu
  QBPopupMenu *popupMenu = [[QBPopupMenu alloc] init];
  QBPopupMenuItem *item1 = [QBPopupMenuItem itemWithTitle:@"Reply" image:[UIImage imageNamed:@"icon_reply.png"] target:self action:@selector(reply:)];
  item1.width = 64;
  QBPopupMenuItem *item2 = [QBPopupMenuItem itemWithTitle:@"Favorite" image:[UIImage imageNamed:@"icon_favorite.png"] target:nil action:NULL];
  item2.width = 64;
  QBPopupMenuItem *item3 = [QBPopupMenuItem itemWithTitle:@"Retweet" image:[UIImage imageNamed:@"icon_retweet.png"] target:nil action:NULL];
  item3.width = 64;
  popupMenu.items = [NSArray arrayWithObjects:item1, item2, item3, nil];
  
  self.popupMenu = popupMenu;
  
  
  
  segmentedControl1 = [[AKSegmentedControl alloc] initWithFrame:CGRectMake(0,0, 320, 37)];
  segmentedControl1.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
  [segmentedControl1 addTarget:self action:@selector(segmentedViewController:) forControlEvents:UIControlEventValueChanged];
  [segmentedControl1 setSegmentedControlMode:AKSegmentedControlModeButton];
  [segmentedControl1 setSelectedIndex:0];
  [self setupSegmentedControl1];
  
  [self.view addSubview:segmentedControl1];
  
  for (UIView *view in [_mapView subviews])
    if ([view isKindOfClass:[UIImageView class]]) 
      [view removeFromSuperview];


}

- (void)dctInternal_setupInternals {
  CGSize screenSize = [[UIScreen mainScreen] currentMode].size;
	if ( (screenSize.width >= 639.9f) && (fabsf(screenSize.height) >= 959.9f) )
	{
		isRetina = TRUE;
	}

}

- (void)showRoate:(id)sender {
  
  [self.navigationController popViewControllerAnimated:YES];
//  self.navigationItem.prompt = @"rompt title";
//  UIButton *button = (UIButton *)sender;
  
//  [self.popupMenu showInView:self.view atPoint:CGPointMake(button.center.x, button.frame.origin.y)];
  
}


- (IBAction)next:(id)sender {
  if (_currentStep + 1 < [_steps count]) {
    _currentStep++;
    [self updateRouteView];
  }

}

- (IBAction)pro:(id)sender {
  if (_currentStep - 1 > -1) {
    _currentStep--;
    [self updateRouteView];
   
  }

}

- (IBAction)routeList:(id)sender {
  MapTableViewController *mt = [[MapTableViewController alloc] initWithStyle:UITableViewStylePlain];
  mt.items = _steps;
  mt.delegate = self;
  [self.navigationController pushViewController:mt animated:YES];
  mt = nil;

}

- (void)updateRouteView {
  BMKStep *step = [_steps objectAtIndex:_currentStep];
  self.routeView.titleLabel.text = step.content;
  [_mapView setCenterCoordinate:step.pt];
  NSString *judge = step.content;
  NSString *directionImageName = @"da_depart.png";
  if ([judge hasPrefix:@"直行"]) {
    directionImageName = @"da_turn_straight.png";
  }
  else if ([judge hasPrefix:@"调头"]) {
    directionImageName = @"da_turn_uturn.png";
  }
  else if ([judge hasPrefix:@"右"]) {
    directionImageName = @"da_turn_right.png";
  }
  else if ([judge hasPrefix:@"左"]) {
    directionImageName = @"da_turn_left.png";
  }
  else if ([judge hasPrefix:@"稍向右"]) {
    directionImageName = @"da_turn_slight_right.png";
  }
  else if ([judge hasPrefix:@"稍向左"]) {
    directionImageName = @"da_turn_slight_left.png";
  }
  else if ([judge hasPrefix:@"到达"]) {
    directionImageName = @"da_destination.png";
  }
  self.routeView.imageView.image = [UIImage imageNamed:directionImageName];
 
}

//- (void)updateDriveRoute {
//  
//  BMKStep *step = [_steps objectAtIndex:0];
//  self.routeView.backgroundColor = [UIColor clearColor];
//  self.routeView.titleLabel.text = step.content;
//  self.currentStep               = 0;
//  [_mapView setCenterCoordinate:step.pt];
//  
//}

- (void)reply:(id)sender
{
  NSLog(@"*** reply: %@", [sender class]);
}

#pragma mark -
#pragma mark BaiduMapDelegate

- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
	if (userLocation != nil) {
		NSLog(@"%f %f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
	}
	
}

- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
	if (error != nil)
		NSLog(@"locate failed: %@", [error localizedDescription]);
	else {
		NSLog(@"locate failed");
	}
	
}

- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
	NSLog(@"start locate");
}



- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(RouteAnnotation*)routeAnnotation
{
	BMKAnnotationView* view = nil;
	switch (routeAnnotation.type) {
		case 0:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_start.png"]];
				view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 1:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_end.png"]];
				view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 2:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_bus.png"]];
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 3:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
				view.image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_nav_rail.png"]];
				view.canShowCallout = TRUE;
			}
			view.annotation = routeAnnotation;
		}
			break;
		case 4:
		{
			view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
			if (view == nil) {
				view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
				view.canShowCallout = TRUE;
			} else {
				[view setNeedsDisplay];
			}
			
			UIImage* image = [UIImage imageWithContentsOfFile:[self getMyBundlePath1:@"images/icon_direction.png"]];
			view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
			view.annotation = routeAnnotation;
			
		}
			break;
		default:
			break;
	}
	
	return view;
}



- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
	if ([annotation isKindOfClass:[RouteAnnotation class]]) {
		return [self getRouteAnnotationView:view viewForAnnotation:(RouteAnnotation*)annotation];
	}
  if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
//    __autoreleasing BMKPinAnnotationView *newAnnotation = [[BMKPinAnnotationView alloc] init];
   __autoreleasing 	BMKPinAnnotationView *newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
    newAnnotation.annotation = annotation;
		newAnnotation.pinColor = BMKPinAnnotationColorRed;
		newAnnotation.animatesDrop = YES;
    
    UIButton *rightbtn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [rightbtn addTarget:self action:@selector(showRoate:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30*3, 30)];
    leftView.backgroundColor = [UIColor blackColor];
    
    UIButton *left0 = [UIButton buttonWithType:UIButtonTypeCustom];
    left0.frame     = CGRectMake(0, 0, 30, 30);
    [left0 setImage:[UIImage imageNamed:@"button_bus"] forState:UIControlStateNormal];
    
    UIButton *left1 = [UIButton buttonWithType:UIButtonTypeCustom];
    left1.frame     = CGRectMake(30, 0, 30, 30);
    [left1 setImage:[UIImage imageNamed:@"button_walking"] forState:UIControlStateNormal];
    
    UIButton *left2 = [UIButton buttonWithType:UIButtonTypeCustom];
    left2.frame     = CGRectMake(60, 0, 30, 30);
    [left2 setImage:[UIImage imageNamed:@"button_car"] forState:UIControlStateNormal];
    
    [leftView addSubview:left0];
    [leftView addSubview:left1];
    [leftView addSubview:left2];
    
    
//    newAnnotation.leftCalloutAccessoryView = leftView;
    newAnnotation.rightCalloutAccessoryView = rightbtn;
		
		return newAnnotation;
  }

	return nil;
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
	if ([overlay isKindOfClass:[BMKPolyline class]]) {
    __autoreleasing BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
    polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
    polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
    polylineView.lineWidth = 3.0;
    return polylineView;
  }
	return nil;
}


- (void)onGetTransitRouteResult:(BMKPlanResult*)result errorCode:(int)error
{
  
	NSLog(@"onGetTransitRouteResult:error:%d", error);
	if (error == BMKErrorOk) {
		BMKTransitRoutePlan* plan = (BMKTransitRoutePlan*)[result.plans objectAtIndex:0];
		
		RouteAnnotation* item = [[RouteAnnotation alloc]init];
		item.coordinate = plan.startPt;
		item.title = @"起点";
		item.type = 0;
		[_mapView addAnnotation:item];
//		[item release];
    item = nil;
		item = [[RouteAnnotation alloc]init];
		item.coordinate = plan.endPt;
		item.type = 1;
		item.title = @"终点";
		[_mapView addAnnotation:item];
//		[item release];
    item = nil;
		
		int size = [plan.lines count];
		int index = 0;
		for (int i = 0; i < size; i++) {
			BMKRoute* route = [plan.routes objectAtIndex:i];
			for (int j = 0; j < route.pointsCount; j++) {
				int len = [route getPointsNum:j];
				index += len;
			}
			BMKLine* line = [plan.lines objectAtIndex:i];
			index += line.pointsCount;
			if (i == size - 1) {
				i++;
				route = [plan.routes objectAtIndex:i];
				for (int j = 0; j < route.pointsCount; j++) {
					int len = [route getPointsNum:j];
					index += len;
				}
				break;
			}
		}
		
		BMKMapPoint* points = new BMKMapPoint[index];
		index = 0;
		
		for (int i = 0; i < size; i++) {
			BMKRoute* route = [plan.routes objectAtIndex:i];
			for (int j = 0; j < route.pointsCount; j++) {
				int len = [route getPointsNum:j];
				BMKMapPoint* pointArray = (BMKMapPoint*)[route getPoints:j];
				memcpy(points + index, pointArray, len * sizeof(BMKMapPoint));
				index += len;
			}
			BMKLine* line = [plan.lines objectAtIndex:i];
			memcpy(points + index, line.points, line.pointsCount * sizeof(BMKMapPoint));
			index += line.pointsCount;
			
			item = [[RouteAnnotation alloc]init];
			item.coordinate = line.getOnStopPoiInfo.pt;
			item.title = line.tip;
			if (line.type == 0) {
				item.type = 2;
			} else {
				item.type = 3;
			}
			
			[_mapView addAnnotation:item];
      item = nil;
//			[item release];
			route = [plan.routes objectAtIndex:i+1];
			item = [[RouteAnnotation alloc]init];
			item.coordinate = line.getOffStopPoiInfo.pt;
			item.title = route.tip;
			if (line.type == 0) {
				item.type = 2;
			} else {
				item.type = 3;
			}
			[_mapView addAnnotation:item];
      item = nil;
//			[item release];
			if (i == size - 1) {
				i++;
				route = [plan.routes objectAtIndex:i];
				for (int j = 0; j < route.pointsCount; j++) {
					int len = [route getPointsNum:j];
					BMKMapPoint* pointArray = (BMKMapPoint*)[route getPoints:j];
					memcpy(points + index, pointArray, len * sizeof(BMKMapPoint));
					index += len;
				}
				break;
			}
		}
		
		BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:points count:index];
		[_mapView addOverlay:polyLine];
		delete []points;
	}
}


- (void)onGetDrivingRouteResult:(BMKPlanResult*)result errorCode:(int)error
{
	NSLog(@"onGetDrivingRouteResult:error:%d", error);
  
  if (error == BMKErrorOk) {
    BMKRoutePlan* plan  = (BMKRoutePlan*)[result.plans objectAtIndex:0];
    BMKRoute *route     = [plan.routes objectAtIndex:0];
    
    self.steps          = route.steps;
    self.currentStep    = 0;
    [self updateRouteView];
    self.routeView.hidden = NO;
    segmentedControl1.hidden = YES;
    self.btnView.hidden = NO;

  }
  
  
	if (error == BMKErrorOk) {
		BMKRoutePlan* plan = (BMKRoutePlan*)[result.plans objectAtIndex:0];
		
		
		RouteAnnotation* item = [[RouteAnnotation alloc]init];
		item.coordinate = result.startNode.pt;
		item.title = @"起点";
		item.type = 0;
		[_mapView addAnnotation:item];
//		[item release];
    item  = nil;
		
		int index = 0;
		int size = [plan.routes count];
		for (int i = 0; i < 1; i++) {
			BMKRoute* route = [plan.routes objectAtIndex:i];
			for (int j = 0; j < route.pointsCount; j++) {
				int len = [route getPointsNum:j];
				index += len;
			}
		}
		
		BMKMapPoint* points = new BMKMapPoint[index];
		index = 0;
		
		for (int i = 0; i < 1; i++) {
			BMKRoute* route = [plan.routes objectAtIndex:i];
			for (int j = 0; j < route.pointsCount; j++) {
				int len = [route getPointsNum:j];
				BMKMapPoint* pointArray = (BMKMapPoint*)[route getPoints:j];
				memcpy(points + index, pointArray, len * sizeof(BMKMapPoint));
				index += len;
			}
			size = route.steps.count;
			for (int j = 0; j < size; j++) {
				BMKStep* step = [route.steps objectAtIndex:j];
				item = [[RouteAnnotation alloc]init];
				item.coordinate = step.pt;
				item.title = step.content;
				item.degree = step.degree * 30;
				item.type = 4;
				[_mapView addAnnotation:item];
//				[item release];
        item = nil;
			}
			
		}
		
		item = [[RouteAnnotation alloc]init];
		item.coordinate = result.endNode.pt;
		item.type = 1;
		item.title = @"终点";
		[_mapView addAnnotation:item];
//		[item release];
    item = nil;
		BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:points count:index];
		[_mapView addOverlay:polyLine];
		delete []points;
	}
	
}

- (void)onGetWalkingRouteResult:(BMKPlanResult*)result errorCode:(int)error
{
  
  if (error == BMKErrorOk) {
    BMKRoutePlan* plan  = (BMKRoutePlan*)[result.plans objectAtIndex:0];
    BMKRoute *route     = [plan.routes objectAtIndex:0];
    
    self.steps          = route.steps;
    self.currentStep    = 0;
    [self updateRouteView];
    self.routeView.hidden = NO;
    segmentedControl1.hidden = YES;
    self.btnView.hidden = NO;
    
  }
  
  
	NSLog(@"onGetWalkingRouteResult:error:%d", error);
	if (error == BMKErrorOk) {
		BMKRoutePlan* plan = (BMKRoutePlan*)[result.plans objectAtIndex:0];
    
		RouteAnnotation* item = [[RouteAnnotation alloc]init];
		item.coordinate = result.startNode.pt;
		item.title = @"起点";
		item.type = 0;
		[_mapView addAnnotation:item];
//		[item release];
    item = nil;
		
		int index = 0;
		int size = [plan.routes count];
		for (int i = 0; i < 1; i++) {
			BMKRoute* route = [plan.routes objectAtIndex:i];
			for (int j = 0; j < route.pointsCount; j++) {
				int len = [route getPointsNum:j];
				index += len;
			}
		}
		
		BMKMapPoint* points = new BMKMapPoint[index];
		index = 0;
		
		for (int i = 0; i < 1; i++) {
			BMKRoute* route = [plan.routes objectAtIndex:i];
			for (int j = 0; j < route.pointsCount; j++) {
				int len = [route getPointsNum:j];
				BMKMapPoint* pointArray = (BMKMapPoint*)[route getPoints:j];
				memcpy(points + index, pointArray, len * sizeof(BMKMapPoint));
				index += len;
			}
			size = route.steps.count;
			for (int j = 0; j < size; j++) {
				BMKStep* step = [route.steps objectAtIndex:j];
				item = [[RouteAnnotation alloc]init];
				item.coordinate = step.pt;
				item.title = step.content;
				item.degree = step.degree * 30;
				item.type = 4;
				[_mapView addAnnotation:item];
//				[item release];
        item = nil;
			}
			
		}
		
		item = [[RouteAnnotation alloc]init];
		item.coordinate = result.endNode.pt;
		item.type = 1;
		item.title = @"终点";
		[_mapView addAnnotation:item];
//		[item release];
    item = nil;
		BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:points count:index];
		[_mapView addOverlay:polyLine];
		delete []points;
	}
}

- (void)onGetPoiResult:(NSArray*)poiResultList searchType:(int)type errorCode:(int)error
{
}


- (void)onGetAddrResult:(BMKAddrInfo*)result errorCode:(int)error
{
}


- (void)searchFaild {
  MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
  hud.mode = MBProgressHUDModeText;
  hud.labelText = @"获取线路失败";
  [hud hide:YES afterDelay:1.0];
}


-(void)onClickBusSearch{
  
  _mapView.showsUserLocation = YES;
	NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
	[_mapView removeAnnotations:array];
	array = [NSArray arrayWithArray:_mapView.overlays];
	[_mapView removeOverlays:array];
	CLLocationCoordinate2D startPt = (CLLocationCoordinate2D){0, 0};
	CLLocationCoordinate2D endPt = (CLLocationCoordinate2D){0, 0};
  startPt = _mapView.userLocation.coordinate;
//  startPt = [[LBSManager sharedManager] coor];
//  startPt = CLLocationCoordinate2DMake(39.915101, 116.307827);
  endPt = goalCoordinate;
//	if (_startCoordainateXText.text != nil && _startCoordainateYText.text != nil) {
//		startPt = (CLLocationCoordinate2D){[_startCoordainateYText.text floatValue], [_startCoordainateXText.text floatValue]};
//	}
//	if (_endCoordainateXText.text != nil && _endCoordainateYText.text != nil) {
//		endPt = (CLLocationCoordinate2D){[_endCoordainateYText.text floatValue], [_endCoordainateXText.text floatValue]};
//	}
	BMKPlanNode* start = [[BMKPlanNode alloc]init];
	start.pt = startPt;
//	start.name = _mapView.userLocation;
	BMKPlanNode* end = [[BMKPlanNode alloc] init ];
	end.name = self.userInfo[@"name"];
  end.pt = endPt;
//  endPt.latitude = goalCoordinate.latitude;
//  endPt.longitude = goalCoordinate.longitude;
	BOOL flag = [_search transitSearch:@"重庆" startNode:start endNode:end];
	if (!flag) {
		NSLog(@"search failed");
    [self searchFaild];
	}
//	[start release];
//	[end release];
}


-(void  )onClickDriveSearch
{
	NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
	[_mapView removeAnnotations:array];
	array = [NSArray arrayWithArray:_mapView.overlays];
	[_mapView removeOverlays:array];
//	CLLocationCoordinate2D startPt = (CLLocationCoordinate2D){0, 0};
//	CLLocationCoordinate2D endPt = (CLLocationCoordinate2D){0, 0};
//	if (_startCoordainateXText.text != nil && _startCoordainateYText.text != nil) {
//		startPt = (CLLocationCoordinate2D){[_startCoordainateYText.text floatValue], [_startCoordainateXText.text floatValue]};
//	}
//	if (_endCoordainateXText.text != nil && _endCoordainateYText.text != nil) {
//		endPt = (CLLocationCoordinate2D){[_endCoordainateYText.text floatValue], [_endCoordainateXText.text floatValue]};
//	}
	BMKPlanNode* start = [[BMKPlanNode alloc]init];
	start.pt = _mapView.userLocation.coordinate;
//    start.pt = [[LBSManager sharedManager] coor];
//	start.name = _startAddrText.text;
	BMKPlanNode* end = [[BMKPlanNode alloc]init];
  end.pt = goalCoordinate;
//	end.name = _endAddrText.text;
	BOOL flag = [_search drivingSearch:@"重庆" startNode:start endCity:@"重庆" endNode:end];
	if (!flag) {
     [self searchFaild];
		NSLog(@"search failed");
	}
//  [_mapView setCenterCoordinate:_mapView.userLocation.coordinate];
//	[start release];
//	[end release];
	
}


-(void )onClickWalkSearch
{
	NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
	[_mapView removeAnnotations:array];
	array = [NSArray arrayWithArray:_mapView.overlays];
	[_mapView removeOverlays:array];
//	CLLocationCoordinate2D startPt = (CLLocationCoordinate2D){0, 0};
//	CLLocationCoordinate2D endPt = (CLLocationCoordinate2D){0, 0};
//	if (_startCoordainateXText.text != nil && _startCoordainateYText.text != nil) {
//		startPt = (CLLocationCoordinate2D){[_startCoordainateYText.text floatValue], [_startCoordainateXText.text floatValue]};
//	}
//	if (_endCoordainateXText.text != nil && _endCoordainateYText.text != nil) {
//		endPt = (CLLocationCoordinate2D){[_endCoordainateYText.text floatValue], [_endCoordainateXText.text floatValue]};
//	}
	BMKPlanNode* start = [[BMKPlanNode alloc]init];
	start.pt = _mapView.userLocation.coordinate;
//    start.pt = [[LBSManager sharedManager] coor];
//	start.name = _startAddrText.text;
	BMKPlanNode* end = [[BMKPlanNode alloc]init];
//	end.name = _endAddrText.text;
  end.pt = goalCoordinate;
	BOOL flag = [_search walkingSearch:@"重庆" startNode:start endCity:@"重庆" endNode:end];
	if (!flag) {
     [self searchFaild];
		NSLog(@"search failed");
	}
//	[start release];
//	[end release];
	
}
 

#pragma mark -
#pragma mark AKSegmentedControl

- (void)segmentedViewController:(AKSegmentedControl *)seg {
  
  NSLog(@"%d",[seg.selectedIndexes firstIndex]);
  NSInteger index = [seg.selectedIndexes firstIndex];
  switch (index) {
    case 0: //驾车
      [self onClickDriveSearch];
      break;
    case 1://公交
      [self onClickBusSearch];
      break;
    case 2://步行
      [self onClickWalkSearch];
      break;
      
    default:
      break;
  }
  
}

- (void)setupSegmentedControl1
{
  UIImage *backgroundImage = [[UIImage imageNamed:@"segmented-bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
  [segmentedControl1 setBackgroundImage:backgroundImage];
  [segmentedControl1 setContentEdgeInsets:UIEdgeInsetsMake(2.0, 2.0, 3.0, 2.0)];
  [segmentedControl1 setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin];
  
  [segmentedControl1 setSeparatorImage:[UIImage imageNamed:@"segmented-separator.png"]];
  
  UIImage *buttonBackgroundImagePressedLeft = [[UIImage imageNamed:@"segmented-bg-pressed-left.png"]
                                               resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 4.0, 0.0, 1.0)];
  UIImage *buttonBackgroundImagePressedCenter = [[UIImage imageNamed:@"segmented-bg-pressed-center.png"]
                                                 resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 4.0, 0.0, 1.0)];
  UIImage *buttonBackgroundImagePressedRight = [[UIImage imageNamed:@"segmented-bg-pressed-right.png"]
                                                resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 1.0, 0.0, 4.0)];
  
  // Button 1
  UIButton *buttonSocial = [[UIButton alloc] init];
  UIImage *buttonSocialImageNormal = [UIImage imageNamed:@"button_car"];
  
  [buttonSocial setTitle:@"  驾车    " forState:UIControlStateNormal];
  [buttonSocial setTitleColor:[UIColor colorWithRed:82.0/255.0 green:113.0/255.0 blue:131.0/255.0 alpha:1.0] forState:UIControlStateNormal];
  [buttonSocial setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [buttonSocial.titleLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
  [buttonSocial.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
  [buttonSocial setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
  
  [buttonSocial setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 5.0)];
  [buttonSocial setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateHighlighted];
  [buttonSocial setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateSelected];
  [buttonSocial setBackgroundImage:buttonBackgroundImagePressedLeft forState:(UIControlStateHighlighted|UIControlStateSelected)];
   [buttonSocial setImage:buttonSocialImageNormal forState:UIControlStateNormal];
    [buttonSocial setImage:buttonSocialImageNormal forState:UIControlStateSelected];
    [buttonSocial setImage:buttonSocialImageNormal forState:UIControlStateHighlighted];
    [buttonSocial setImage:buttonSocialImageNormal forState:(UIControlStateHighlighted|UIControlStateSelected)];
  
  // Button 2
  UIButton *buttonStar = [[UIButton alloc] init];
  UIImage *buttonStarImageNormal = [UIImage imageNamed:@"button_bus"];
  
  [buttonStar setTitle:@"  公交    " forState:UIControlStateNormal];
  [buttonStar setTitleColor:[UIColor colorWithRed:82.0/255.0 green:113.0/255.0 blue:131.0/255.0 alpha:1.0] forState:UIControlStateNormal];
  [buttonStar setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [buttonStar.titleLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
  [buttonStar.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
  [buttonStar setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
 
  [buttonStar setBackgroundImage:buttonBackgroundImagePressedCenter forState:UIControlStateHighlighted];
  [buttonStar setBackgroundImage:buttonBackgroundImagePressedCenter forState:UIControlStateSelected];
  [buttonStar setBackgroundImage:buttonBackgroundImagePressedCenter forState:(UIControlStateHighlighted|UIControlStateSelected)];
  [buttonStar setImage:buttonStarImageNormal forState:UIControlStateNormal];
 [buttonStar setImage:buttonStarImageNormal forState:UIControlStateSelected];
   [buttonStar setImage:buttonStarImageNormal forState:UIControlStateHighlighted];
    [buttonStar setImage:buttonStarImageNormal forState:(UIControlStateHighlighted|UIControlStateSelected)];
  
  // Button 3
  UIButton *buttonSettings = [[UIButton alloc] init];
 UIImage *buttonSettingsImageNormal = [UIImage imageNamed:@"button_walking"];
  
  [buttonSettings setTitle:@"  步行    " forState:UIControlStateNormal];
  [buttonSettings setTitleColor:[UIColor colorWithRed:82.0/255.0 green:113.0/255.0 blue:131.0/255.0 alpha:1.0] forState:UIControlStateNormal];
  [buttonSettings setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [buttonSettings.titleLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
  [buttonSettings.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
  [buttonSettings setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
  
  [buttonSettings setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateHighlighted];
  [buttonSettings setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateSelected];
  [buttonSettings setBackgroundImage:buttonBackgroundImagePressedRight forState:(UIControlStateHighlighted|UIControlStateSelected)];
  [buttonSettings setImage:buttonSettingsImageNormal forState:UIControlStateNormal];
   [buttonSettings setImage:buttonSettingsImageNormal forState:UIControlStateSelected];
  [buttonSettings setImage:buttonSettingsImageNormal forState:UIControlStateHighlighted];
  [buttonSettings setImage:buttonSettingsImageNormal forState:(UIControlStateHighlighted|UIControlStateSelected)];
  
  [segmentedControl1 setButtonsArray:@[buttonSocial, buttonStar, buttonSettings]];
  [self.view addSubview:segmentedControl1];
}

#pragma MapView

- (void)mapTableItems:(NSArray *)items didSelectedIndexPath:(NSIndexPath *)indexPath {
//  BMKStep *step = items[indexPath.row];
//  [_mapView setCenterCoordinate:step.pt animated:YES];
  
  _currentStep = indexPath.row;
  [self updateRouteView];
  
}


@end
