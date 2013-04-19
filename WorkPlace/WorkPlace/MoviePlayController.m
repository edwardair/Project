//
//  MoviePlayController.m
//  WorkPlace
//
//  Created by BlackApple on 13-4-18.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "MoviePlayController.h"
#import "CommonMethod.h"
#import "RepairPopoverView.h"
#import "PDViewController.h"
#import "IWRViewController.h"
#import "CheckBoxView.h"
@interface MoviePlayController (){
    UILabel *connected;
    NSMutableArray *dataTitle;
}

@end

@implementation MoviePlayController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}
- (void)detail{
    NSLogString(@"详情");
    [self ProjectDetails:nil];
}
- (void)repair{
    NSLogString(@"报修");
    [self IWannaRepairs:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *detail = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Detail.png"] style:UIBarButtonItemStylePlain target:self action:@selector(detail)];
    UIBarButtonItem *repair = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Repair.png"] style:UIBarButtonItemStylePlain target:self action:@selector(repair)];

    self.navigationItem.rightBarButtonItems = @[detail,repair];
    
    // Do any additional setup after loading the view from its nib.
    CGRect movieViewFrame = _MoviePlayer.frame;
    connected = [[UILabel alloc]init];
    [_MoviePlayer addSubview:connected];
    [connected release];
    connected.center = CGPointMake(movieViewFrame.size.width/2, movieViewFrame.size.height/2);
    
    dataTitle = [[NSMutableArray alloc]init];
    [dataTitle addObject:@"项目名称     "];
    [dataTitle addObject:@"监理单位     "];
    [dataTitle addObject:@"施工单位     "];
    [dataTitle addObject:@"项目负责人   "];
    [dataTitle addObject:@"联系方式     "];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
//    [_MoviePlayer release];
//    [dataTitle release];
//    [connected release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMoviePlayer:nil];
    [super viewDidUnload];
}
- (IBAction)ConnectMovie:(id)sender {
    if ([connected.text isEqualToString:@"连接中..."]) {
        return;
    }
    connected.text = @"连接中...";
    [CommonMethod autoSizeLabel:connected];
}

- (IBAction)BreakMovie:(id)sender {
    if ([connected.text isEqualToString:@"已断开"]) {
        return;
    }
    connected.text = @"已断开";
    [CommonMethod autoSizeLabel:connected];
}

- (IBAction)DirectionController:(id)sender {
    NSLog(@"方向控制");
}

- (IBAction)ProjectDetails:(id)sender {
    NSLog(@"项目详情");
    
    PDViewController *pd = [[PDViewController alloc]initWithNibName:@"PDViewController" bundle:nil];
    [self.navigationController pushViewController:pd animated:YES];
    [pd initLabelsTextWithDic:_dataSource];
    
//    CGFloat xWidth = self.view.bounds.size.width - 20.0f;
//    CGFloat yHeight = 272.0f;
//    CGFloat yOffset = (self.view.bounds.size.height - yHeight)/2.0f;
//    UIPopoverListView *poplistview = [[UIPopoverListView alloc] initWithFrame:CGRectMake(10, yOffset, xWidth, yHeight)];
//    poplistview.delegate = self;
//    poplistview.datasource = self;
//    poplistview.listView.scrollEnabled = FALSE;
//    [poplistview setTitle:@"项目详情"];
//    [poplistview show];
//    [poplistview release];

}

- (IBAction)IWannaRepairs:(id)sender {
    NSLogString(@"我要报修");
//    RepairPopoverView *repair = [[RepairPopoverView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
//    [repair show];
    
    IWRViewController *iwr = [[IWRViewController alloc]initWithNibName:@"IWRViewController" bundle:nil];
    [self.navigationController pushViewController:iwr animated:YES];

}


#pragma mark - UIPopoverListViewDataSource

- (UITableViewCell *)popoverListView:(UIPopoverListView *)popoverListView
                    cellForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [popoverListView.listView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
       cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                reuseIdentifier:identifier] autorelease];
    }
    
    int row = indexPath.row;
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@%@",dataTitle[row],_dataSource[row]];
//    cell.userInteractionEnabled = NO;
//    cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

- (NSInteger)popoverListView:(UIPopoverListView *)popoverListView
       numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

#pragma mark - UIPopoverListViewDelegate
- (void)popoverListView:(UIPopoverListView *)popoverListView
     didSelectIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s : %d", __func__, indexPath.row);
    // your code here
}

- (CGFloat)popoverListView:(UIPopoverListView *)popoverListView
   heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}


@end
