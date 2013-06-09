//
//  UITextViewExtend.m
//  abs
//
//  Created by Apple on 13-6-8.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import "WGTextView.h"
#import "WGTableViewCell.h"
@interface WGTextView()
@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic,retain) NSMutableArray *dataArray;
@end
@implementation WGTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
        [self addSubview:_tableView];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _dataArray = [[NSMutableArray alloc]init];

        _font = [UIFont systemFontOfSize:DefaultFontSize] ;
    }
    return self;
}
- (void)dealloc{
    [_tableView release];
    _tableView = nil;
    [_dataArray release];
    _dataArray = nil;
    self.text = nil;
    self.font = nil;
    [super dealloc];
}

- (void)setText:(NSString *)text{
    [_text release];
    _text = [text copy];

    [self resetTextShow];
}
- (void)setLineHeight:(float)lineHeight{
    _lineHeight = lineHeight;
    [_tableView reloadData];
}
- (void)setFont:(UIFont *)font{
    _font = font;
    [self resetTextShow];
}

- (void)resetTextShow{
    [_dataArray removeAllObjects];
    
    NSMutableString *text = [NSMutableString stringWithString:_text];
    
    NSString *temp = nil;
    int index = 0;
    while (1) {
        if (index==text.length) {
            temp = text;
            NSLog(@"%@",temp);

            [_dataArray addObject:temp];
            break;
        }else{
            temp = [text substringToIndex:++index];
            if ([temp sizeWithFont:_font].width>self.frame.size.width) {
                //TODO: 判断 如果下一个字符为标点符号，则index往上递推到无标点的前一个字符
                temp = [text substringToIndex:--index];
                [_dataArray addObject:temp];
                [text deleteCharactersInRange:NSMakeRange(0, index)];
                index = 0;
                NSLog(@"%@",temp);
                temp = nil;
            }
        }
    }
    
    [_tableView reloadData];
        
    text = nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
#pragma mark UITableViewDelegate
- (float )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _lineHeight;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identify = @"WGTextView";
    WGTableViewCell *cell = (WGTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [WGTableViewCell initializeWithFrame:CGSizeMake(self.frame.size.width, _lineHeight) font:_font style:UITableViewCellStyleDefault reuseIdentifier:identify];
    }else{
        cell.cellLabel.font = _font;
    }
    cell.cellLabel.text = _dataArray[indexPath.row];

    return cell;
}

@end
