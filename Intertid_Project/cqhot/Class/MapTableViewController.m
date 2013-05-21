//
//  MapTableViewController.m
//  cqhot
//
//  Created by ZL on 4/25/13.
//  Copyright (c) 2013 gitmac. All rights reserved.
//

#import "MapTableViewController.h"
#import "BMapKit.h"

@interface MapTableViewController ()

@end

@implementation MapTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  
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
  self.navigationItem.leftBarButtonItem = item;
  item = nil;
  
  self.title = @"导航线路列表";
}

- (void)backTo {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [_items count] - 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"indexPath"];
  }
    
    // Configure the cell...
  BMKStep *step = _items[indexPath.row];
  NSArray *ar = [step.content componentsSeparatedByString:@"-"];
  cell.textLabel.text = [ar objectAtIndex:0];
  if ([ar count] > 1) {
     cell.detailTextLabel.text = [ar lastObject];
  }
 
  
  NSString *judge = step.content;
  NSString *directionImageName = @"turn_depart.png";
  if ([judge hasPrefix:@"直行"]) {
    directionImageName = @"turn_straight.png";
  }
  else if ([judge hasPrefix:@"调头"]) {
    directionImageName = @"turn_uturn.png";
  }
  else if ([judge hasPrefix:@"右"]) {
    directionImageName = @"turn_right.png";
  }
  else if ([judge hasPrefix:@"左"]) {
    directionImageName = @"turn_left.png";
  }
  else if ([judge hasPrefix:@"稍向右"]) {
    directionImageName = @"turn_slight_right.png";
  }
  else if ([judge hasPrefix:@"稍向左"]) {
    directionImageName = @"turn_slight_left.png";
  }
  else if ([judge hasPrefix:@"到达"]) {
    directionImageName = @"da_destination.png";
  }
  cell.imageView.image = [UIImage imageNamed:directionImageName];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  if (_delegate && [_delegate respondsToSelector:@selector(mapTableItems:didSelectedIndexPath:)]) {
    [_delegate mapTableItems:_items didSelectedIndexPath:indexPath];
  }
  [self.navigationController popViewControllerAnimated:YES];
}

@end
