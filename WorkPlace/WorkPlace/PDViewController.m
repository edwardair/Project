//
//  PDViewController.m
//  WorkPlace
//
//  Created by BlackApple on 13-4-19.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "PDViewController.h"
#import "CommonMethod.h"
@interface PDViewController ()

@end

@implementation PDViewController

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

- (void)initLabelsTextWithDic:(NSMutableArray *)dic{
    for (UIView *label in self.view.subviews) {
        if ([label isKindOfClass:[UILabel class]]) {
            UILabel *temp = (UILabel *)label;
            temp.text = [NSString stringWithFormat:@"%@%@",temp.text,dic[temp.tag-1]];
            [CommonMethod autoSizeLabel:temp withFont:systemFontSize(DefaultSystemFontSize)];
        }
    }
}

@end
