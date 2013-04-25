//
//  CommonTableView.m
//  ZHW_New
//
//  Created by BlackApple on 13-4-12.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "CommonTableView.h"
#import "CommonMethod.h"
@implementation CommonTableView
@synthesize commonTableViewDelegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.delegate = self;
        self.dataSource = self;
        
        _sectionSource = [[NSMutableArray alloc]init];
        _rowSource = [[NSMutableArray alloc]init];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)setRowSource:(NSMutableArray *)rowSource{
//    [_rowSource release];
    _rowSource = [rowSource retain];
    [self reloadData];
}
- (void)setSectionSource:(NSMutableArray *)sectionSource{
//    [_sectionSource release];
    _sectionSource = [_sectionSource retain];
    [self reloadData];
}
#pragma mark UITablesView delegate
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
        
    UIView *result = nil;
    //组 数据不存在情况下 不设置标题
    if (!_sectionSource || _sectionSource.count==0) {
        return result;
    }
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.text = [_sectionSource objectAtIndex:section];
    label.backgroundColor = [UIColor grayColor];
    [label sizeToFit];
    label.frame = CGRectMake(label.frame.origin.x, 0, 320, label.frame.size.height);
    CGRect resultFrame = CGRectMake(0.0f, 0.0f, label.frame.size.height, label.frame.size.width + 10.0f);
    result = [[UIView alloc]initWithFrame:resultFrame];
    [result addSubview:label];

    return result;
    
}
- (float )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_cellRowHeight &&_cellRowHeight.count==0)
        return [[[_cellRowHeight objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] floatValue];
    else
        //默认 30.f 高度
        return 30.f;
}
- (NSInteger )numberOfSectionsInTableView:(UITableView *)tableView{
    if (!_sectionSource || _sectionSource.count<=1) {
        return 1;
    }else{
        return _sectionSource.count;
    }
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_rowSource objectAtIndex:section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = _cellTitle?_cellTitle:@"Default";
    
    CommonTableViewCell *cell = (CommonTableViewCell *)[tableView dequeueReusableCellWithIdentifier:title];
    if (!cell) {
        cell =  [[CommonTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:title];
    }    
    NSMutableArray *data = [[_rowSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    if (![data isKindOfClass:[NSMutableArray class]]) {
        cell.textLabel.text = writeEnable((NSString *)data);
        cell.textLabel.textColor = [UIColor blackColor];
    }else{
        BOOL resetFrame = [cell addLabelsWithMutableArray:data];
        if (resetFrame) {
            [commonTableViewDelegate setCellLabelsFrams:cell];
        }
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [commonTableViewDelegate cellClickedAtIndexPath:indexPath];
}
//- (void)dealloc{
////    self.rowSource = nil;
////    self.sectionSource = nil;
//    [super dealloc];
//}
@end
