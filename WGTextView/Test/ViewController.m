//
//  ViewController.m
//  Test
//
//  Created by Apple on 13-6-9.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

#import "ViewController.h"
#import <WGTextViewFrameWork/WGTextView.h>
#define TEXT @"东南形胜，三吴都会，钱塘自古繁华。烟柳画桥，风帘翠幕，参差十万人家。云树绕堤沙，怒涛卷霜雪，天堑无涯。市列珠玑，户盈罗绮，竞豪奢。重湖叠清嘉，有三秋桂子，十里荷花。羌管弄晴，菱歌泛夜，嬉嬉钓叟莲娃。千骑拥高衙，乘醉听箫鼓，吟赏烟霞。异日图将好景，归去凤池夸。云树绕堤沙，怒涛卷霜雪，天堑无涯。市列珠玑，户盈罗绮，竞豪奢。重湖叠清嘉，有三秋桂子，十里荷花。羌管弄晴，菱歌泛夜，嬉嬉钓叟莲娃。千骑拥高衙，乘醉听箫鼓，吟赏烟霞。异日图将好景，归去凤池夸东南形胜，三吴都会，钱塘自古繁华。烟柳画桥，风帘翠幕，参差十万人家。云树绕堤沙，怒涛卷霜雪，天堑无涯。市列珠玑，户盈罗绮，竞豪奢。重湖叠清嘉，有三秋桂子，十里荷花。羌管弄晴，菱歌泛夜，嬉嬉钓叟莲娃。千骑拥高衙，乘醉听箫鼓，吟赏烟霞。异日图将好景，归去凤池夸。云树绕堤沙，怒涛卷霜雪，天堑无涯。市列珠玑，户盈罗绮，竞豪奢。重湖叠清嘉，有三秋桂子，十里荷花。羌管弄晴，菱歌泛夜，嬉嬉钓叟莲娃。千骑拥高衙，乘醉听箫鼓，吟赏烟霞。异日图将好景，归去凤池夸。"

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}
WGTextView *textView;
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];

    // Do any additional setup after loading the view from its nib.
    textView = [[WGTextView alloc]initWithFrame:CGRectMake(0, 0, 320, 300)];
    [self.view addSubview:textView];
    textView.lineHeight = 30.f;
    textView.text = TEXT;
    
    UIButton *b = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    [b setTitle:@"OK" forState:UIControlStateNormal];
    [self.view addSubview:b];
    [b setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [b addTarget:self action:@selector(avc) forControlEvents:UIControlEventTouchUpInside];

    
}

- (void)avc{
//    textView.lineHe/ight +=10;
    textView.font = [UIFont systemFontOfSize:22.f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
