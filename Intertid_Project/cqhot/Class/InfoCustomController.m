//
//  InfoCustomController.m
//  cqhot
//
//  Created by ZL on 13-4-15.
//  Copyright (c) 2013年 gitmac. All rights reserved.
//

#import "InfoCustomController.h"
#import "HeadCustomView.h"
#import "UIImageView+WebCache.h"
#import "EUFunc.h"
#import "AKSegmentedControl.h"
#import "MapViewController.h"
#import "CommentViewController.h"
#import "EUOperation.h"

@interface InfoCustomController (){
  AKSegmentedControl *segmentedControl1;
  UIWebView *phoneCallWebView;
}
@property (weak, nonatomic) IBOutlet HeadCustomView *headView;
@property (weak, nonatomic) IBOutlet UIButton *favBtn;
@property (weak, nonatomic) IBOutlet UITextView *decription;
- (IBAction)favTo:(id)sender;
- (IBAction)comTo:(id)sender;
- (IBAction)localTo:(id)sender;
- (IBAction)phoTo:(id)sender;
- (IBAction)clickBus:(id)sender;
- (IBAction)clickCar:(id)sender;
- (IBAction)clickWalk:(id)sender;

@end

@implementation InfoCustomController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)dctInternal_setupInternals {
  self.navigationItem.leftBarButtonItem = [self leftItem];
}

- (void)initializeViews {
  NSLog(@"%@",[self.userInfo description]);
  
  // TODO:标题
  self.title = self.userInfo[@"name"];
  
  // TODO:头部内容
  _headView.titleLabel.text   = self.userInfo[@"title"];
  _headView.consumeLabel.text = [NSString stringWithFormat:@"平均消费: %@", self.userInfo[@"consumptionlevel"]];
  _headView.commentLabel.text = @"0人评价过";
  [_headView.imageView setImageWithURL:[NSURL URLWithString:self.userInfo[@"pictureurl"]]];
  
  _decription.text = [EUFunc delNonCh:self.userInfo[@"description1"]];
  
  
  segmentedControl1 = [[AKSegmentedControl alloc] initWithFrame:CGRectMake(10, 104, 100*3, 30)];
  [segmentedControl1 addTarget:self action:@selector(segmentedViewController:) forControlEvents:UIControlEventValueChanged];
  [segmentedControl1 setSegmentedControlMode:AKSegmentedControlModeSticky];
  [segmentedControl1 setSelectedIndex:0];
  [self setupSegmentedControl1];
  
  EUOperation *op = [EUOperation defaultDatabase];
  [op open];
  self.favBtn.selected = [op existKey:self.userInfo[@"id"]];
  [op close];
  

}



- (void)viewDidUnload {
  [self setHeadView:nil];
  [self setDecription:nil];
  [self setFavBtn:nil];
  [super viewDidUnload];
}
- (IBAction)favTo:(id)sender {
  EUOperation *op = [EUOperation defaultDatabase];
  [op open];
  [op insertPrimary:self.userInfo[@"id"] value:self.userInfo];
  self.favBtn.selected = [op existKey:self.userInfo[@"id"]];
  [op close];
}

- (IBAction)comTo:(id)sender {
}

- (IBAction)localTo:(id)sender {
  MapViewController *map = [[MapViewController alloc] init];
  map.userInfo = self.userInfo;
  [self.navigationController pushViewController:map animated:YES];
  map = nil;
}

- (IBAction)phoTo:(id)sender {
  
//  NSString *phone = [NSString stringWithFormat:@"tel://%@",[self.userInfo valueForKey:@"telephone"]];
//  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
  [self dialPhoneNumber:self.userInfo[@"telephone"]];
}

- (IBAction)clickBus:(id)sender {
  MapViewController *map = [[MapViewController alloc] init];
  map.userInfo = self.userInfo;
  [self.navigationController pushViewController:map animated:YES];
  [map performSelector:@selector(onClickBusSearch) withObject:nil afterDelay:1.0];
//  [map onClickBusSearch];
  map = nil;
}

- (IBAction)clickCar:(id)sender {
  MapViewController *map = [[MapViewController alloc] init];
  map.userInfo = self.userInfo;
  [self.navigationController pushViewController:map animated:YES];
   [map performSelector:@selector(onClickDriveSearch) withObject:nil afterDelay:1.0];
//  [map onClickDriveSearch];
  map = nil;
}

- (IBAction)clickWalk:(id)sender {
  MapViewController *map = [[MapViewController alloc] init];
  map.userInfo = self.userInfo;
  [self.navigationController pushViewController:map animated:YES];
   [map performSelector:@selector(onClickWalkSearch) withObject:nil afterDelay:1.0];
//  [map onClickWalkSearch];
  map = nil;
}

- (void) dialPhoneNumber:(NSString *)aPhoneNumber
{
  NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",aPhoneNumber]];
  if ( !phoneCallWebView ) {
    phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
  }
  [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
}


- (void)segmentedViewController:(AKSegmentedControl *)seg {
  
  NSLog(@"%d",[seg.selectedIndexes firstIndex]);
  NSInteger index = [seg.selectedIndexes firstIndex];
  switch (index) {
        case 0:
          _decription.text = [EUFunc delNonCh:self.userInfo[@"description1"]];
          break;
        case 1:
          _decription.text = @"暂无信息";
          break;
        case 2:
          _decription.text = @"暂无评论";
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
//  UIImage *buttonSocialImageNormal = [UIImage imageNamed:@"social-icon.png"];
  
  [buttonSocial setTitle:@"详情" forState:UIControlStateNormal];
  		  [buttonSocial setTitleColor:[UIColor colorWithRed:82.0/255.0 green:113.0/255.0 blue:131.0/255.0 alpha:1.0] forState:UIControlStateNormal];
  		  [buttonSocial setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
  		  [buttonSocial.titleLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
  		  [buttonSocial.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
  		  [buttonSocial setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
  
  [buttonSocial setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 5.0)];
  [buttonSocial setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateHighlighted];
  [buttonSocial setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateSelected];
  [buttonSocial setBackgroundImage:buttonBackgroundImagePressedLeft forState:(UIControlStateHighlighted|UIControlStateSelected)];
//  [buttonSocial setImage:buttonSocialImageNormal forState:UIControlStateNormal];
//  [buttonSocial setImage:buttonSocialImageNormal forState:UIControlStateSelected];
//  [buttonSocial setImage:buttonSocialImageNormal forState:UIControlStateHighlighted];
//  [buttonSocial setImage:buttonSocialImageNormal forState:(UIControlStateHighlighted|UIControlStateSelected)];
  
  // Button 2
  UIButton *buttonStar = [[UIButton alloc] init];
//  UIImage *buttonStarImageNormal = [UIImage imageNamed:@"star-icon.png"];
  
  [buttonStar setTitle:@"信息" forState:UIControlStateNormal];
  		  [buttonStar setTitleColor:[UIColor colorWithRed:82.0/255.0 green:113.0/255.0 blue:131.0/255.0 alpha:1.0] forState:UIControlStateNormal];
  		  [buttonStar setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
  		  [buttonStar.titleLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
  		  [buttonStar.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
  		  [buttonStar setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
  
  [buttonStar setBackgroundImage:buttonBackgroundImagePressedCenter forState:UIControlStateHighlighted];
  [buttonStar setBackgroundImage:buttonBackgroundImagePressedCenter forState:UIControlStateSelected];
  [buttonStar setBackgroundImage:buttonBackgroundImagePressedCenter forState:(UIControlStateHighlighted|UIControlStateSelected)];
//  [buttonStar setImage:buttonStarImageNormal forState:UIControlStateNormal];
//  [buttonStar setImage:buttonStarImageNormal forState:UIControlStateSelected];
//  [buttonStar setImage:buttonStarImageNormal forState:UIControlStateHighlighted];
//  [buttonStar setImage:buttonStarImageNormal forState:(UIControlStateHighlighted|UIControlStateSelected)];
  
  // Button 3
  UIButton *buttonSettings = [[UIButton alloc] init];
//  UIImage *buttonSettingsImageNormal = [UIImage imageNamed:@"settings-icon.png"];
  
  [buttonSettings setTitle:@"评论" forState:UIControlStateNormal];
  		  [buttonSettings setTitleColor:[UIColor colorWithRed:82.0/255.0 green:113.0/255.0 blue:131.0/255.0 alpha:1.0] forState:UIControlStateNormal];
  		  [buttonSettings setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
  		  [buttonSettings.titleLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
  		  [buttonSettings.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0]];
  		  [buttonSettings setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
  
  [buttonSettings setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateHighlighted];
  [buttonSettings setBackgroundImage:buttonBackgroundImagePressedRight forState:UIControlStateSelected];
  [buttonSettings setBackgroundImage:buttonBackgroundImagePressedRight forState:(UIControlStateHighlighted|UIControlStateSelected)];
//  [buttonSettings setImage:buttonSettingsImageNormal forState:UIControlStateNormal];
//  [buttonSettings setImage:buttonSettingsImageNormal forState:UIControlStateSelected];
//  [buttonSettings setImage:buttonSettingsImageNormal forState:UIControlStateHighlighted];
//  [buttonSettings setImage:buttonSettingsImageNormal forState:(UIControlStateHighlighted|UIControlStateSelected)];
  
  [segmentedControl1 setButtonsArray:@[buttonSocial, buttonStar, buttonSettings]];
  [self.view addSubview:segmentedControl1];
}

@end
