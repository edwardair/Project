//
//  categoryView.m
//  cqhot
//
//  Created by ZL on 4/22/13.
//  Copyright (c) 2013 gitmac. All rights reserved.
//

#import "CategoryView.h"
#import "UIImageView+WebCache.h" 
@implementation CategoryView


#pragma UITableViewDelegate



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  __autoreleasing UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 30)];
  UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ng_group_sliding_tab_bg.9.png"]];
  imageView.frame = view.bounds;
  [view addSubview:imageView];
  
  UIImageView *sep = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ng_group_sliding_tab_div_1.png"]];
  sep.frame = CGRectMake(0, 28, 160, 2);
  
  [view addSubview:sep];

  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 30)];
  label.textColor = [UIColor whiteColor];
  label.backgroundColor = [UIColor clearColor];
  label.font = [UIFont boldSystemFontOfSize:17];
  label.text = _sectionTitle;
  [view addSubview:label];
  label = nil;
  
  return view;
  
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_items count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *identifier = @"cell";
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
  }
  NSDictionary *dctTmp  = _items[indexPath.row];
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
  [imageView setImageWithURL:[NSURL URLWithString:dctTmp[@"pictureurl"]]];
  [[cell contentView] addSubview:imageView];
  
  UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 100, 60)];
  [titleLabel setTextColor:[UIColor whiteColor]];
  [titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
  [titleLabel setText:dctTmp[@"name"]];
  [titleLabel setBackgroundColor:[UIColor clearColor]];
  
  [[cell contentView] addSubview:titleLabel];
  
  UIImageView *separator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ng_group_sliding_tab_div_1.png"]];
  separator.frame = CGRectMake(0, 59, 160, 1);
  [[cell contentView] addSubview:separator];
  
  
  UIImageView *selectedBackgroundView = [[UIImageView alloc] initWithFrame:cell.bounds];
  UIImage *backroundImage = [UIImage imageNamed:@"btn_blue_normal.9.png"];
  selectedBackgroundView.image = [backroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(5, 7, 5, 7)];
 
  cell.selectedBackgroundView = selectedBackgroundView;
  
  selectedBackgroundView = nil;
  backroundImage = nil;
  
  separator = nil;
  titleLabel = nil;
  imageView = nil;

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  if (_delegate &&  [_delegate respondsToSelector:@selector(categoryDidSelectedIndexPath:)]) {
    [_delegate categoryDidSelectedIndexPath:indexPath];
  }
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  return YES;
}

- (IBAction)clickSearch:(id)sender {
}

- (IBAction)clickFavorites:(id)sender {
}

- (IBAction)clickLocation:(id)sender {
}

- (IBAction)clickPrise:(id)sender {
}
@end
