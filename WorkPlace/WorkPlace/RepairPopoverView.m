//
//  RepairPopoverView.m
//  WorkPlace
//
//  Created by BlackApple on 13-4-18.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "RepairPopoverView.h"
#import "CommonMethod.h"
#import <QuartzCore/QuartzCore.h>

#define TableDataCount 3
#define Width 300.0
#define Height 150.0
@interface RepairPopoverView(){
    UIControl *dismissControl;
}
@end
@implementation RepairPopoverView
@synthesize rpvDelegate;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.layer.borderWidth = 1.0f;
        self.layer.cornerRadius = 10.0f;
        
        self.clipsToBounds = TRUE;
        dismissControl = [[UIControl alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
        [dismissControl addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
        
        self.frame = CGRectMake(applicationFrame().size.width/2-Width/2, applicationFrame().size.height/2-Height/2, Width, Height);
        self.backgroundColor = [UIColor whiteColor];
        
        UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:table];
        table.delegate = self;
        table.dataSource = self;
        
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
- (void)fadeIn
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    dismissControl.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:0];
    
    [UIView animateWithDuration:.2 animations:^{
        self.alpha = 1;
        dismissControl.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:.5];

        self.transform = CGAffineTransformMakeScale(.8, .8);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.2 animations:^{
            self.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }];
    
}
- (void)fadeOut
{
    [UIView animateWithDuration:.2 animations:^{
        self.transform = CGAffineTransformMakeScale(.8, .8);
//        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.2 animations:^{
            self.alpha = 0.f;
            dismissControl.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:0];

            self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        } completion:^(BOOL finished) {
            if (finished) {
                [dismissControl removeFromSuperview];
                [dismissControl release];

                [self removeFromSuperview];
            }
        }];
    }];
}

- (void)show:(id)delegate{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];

    [window addSubview:dismissControl];
    [window addSubview:self];
    self.rpvDelegate = delegate;
    [self fadeIn];
}
- (void)dismissView{
    [self fadeOut];
}

#pragma mark UITableView Delegate
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.f;
}
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return TableDataCount;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = indexPath.row;
    NSString *title = @"reason";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:title];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:title];
        [cell.textLabel  setTextAlignment:NSTextAlignmentCenter];
    }
    switch(row){
        case 0:
            cell.textLabel.text = @"黑屏";
            break;
        case 1:
            cell.textLabel.text = @"原因A";
            break;
        case 2:
            cell.textLabel.text = @"原因原因啊";
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (rpvDelegate) {
        [rpvDelegate cellSelected:indexPath.row];
        [self dismissView];
    }
}
- (void)dealloc{
    
    [super dealloc];
}

@end
