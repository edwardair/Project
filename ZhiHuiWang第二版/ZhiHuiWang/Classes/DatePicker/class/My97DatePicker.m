//
//  My97DatePicker.m
//  htmlDatePickerDemo
//
//  Created by wu xiaoming on 13-1-23.
//  Copyright (c) 2013年 wu xiaoming. All rights reserved.
//

#import "My97DatePicker.h"
#import "GTMBase64.h"
#import <QuartzCore/QuartzCore.h>

#define  CUSTOM_PROTOCOL_SCHEME  @"applewebdata"
#define  CUSTOM_EXECUTESCRIPT @"_objectc_webview_executescript_"

@implementation My97DatePicker
@synthesize grayBG;
@synthesize webViewForSelectDate;
@synthesize datePickerBtn;

-(id)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    if (self)
    {
//        [self.layer setBorderWidth:1];
//        [self.layer setBorderColor:[UIColor orangeColor].CGColor ];
//        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//        self.font = [UIFont fontWithName:@"system" size:17];
//        self.delegate = self;
        
//        CGRect textFrame = self.frame;
//        CGRect datePickerFrame = textFrame;
//        datePickerFrame.size.width = 26;
//        datePickerFrame.size.height = 44;
//        datePickerFrame.origin.y = (textFrame.size.height - datePickerFrame.size.height) / 2;
//        datePickerFrame.origin.x = textFrame.size.width - datePickerFrame.size.width ;
//        datePickerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [datePickerBtn setFrame:datePickerFrame];
//        UIImage* img = [UIImage imageNamed:@"datePicker.png"];
//        [datePickerBtn setBackgroundImage:img forState:UIControlStateNormal];
//        [datePickerBtn addTarget:self action:@selector(selectDate) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:datePickerBtn];
        
    }

    return self;
}
- (void)drawRect:(CGRect)rect
{
    // Drawing code
//    CGRect frame = self.frame;
//    [self setFrame:frame];
    [self.layer setBorderWidth:1];
    [self.layer setBorderColor:[UIColor blackColor].CGColor ];
//    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    self.font = [UIFont fontWithName:@"system" size:17];
//    self.delegate = self;
    
//    CGRect textFrame = self.frame;
//    CGRect datePickerFrame = textFrame;
//    datePickerFrame.size.width = 26;
//    datePickerFrame.size.height = 44;
//    datePickerFrame.origin.y = (textFrame.size.height - datePickerFrame.size.height) / 2;
//    datePickerFrame.origin.x = textFrame.size.width - datePickerFrame.size.width ;
//    datePickerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [datePickerBtn setFrame:datePickerFrame];
//    UIImage* img = [UIImage imageNamed:@"datePicker.png"];
//    [datePickerBtn setBackgroundImage:img forState:UIControlStateNormal];
//    [datePickerBtn addTarget:self action:@selector(selectDate) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:datePickerBtn];

}

- (void)selectDate
{
    //准备好灰色蒙板
    [self readyGrayBG:0.4];
    //加载数据
    [self loadData];
}

-(void)loadData
{
    CGRect webFrame = CGRectMake(0, 0, 260, 280);
    webFrame.origin.x = (grayBG.frame.size.width - webFrame.size.width) / 2;
    webFrame.origin.y =  (grayBG.frame.size.height - webFrame.size.height) / 2;
    if (!webViewForSelectDate)
    {
        webViewForSelectDate = [[UIWebView alloc] initWithFrame:webFrame];
        webViewForSelectDate.delegate = self;
        webViewForSelectDate.backgroundColor = [UIColor whiteColor];
        webViewForSelectDate.scalesPageToFit = YES;
        webViewForSelectDate.opaque = NO;
        webViewForSelectDate.backgroundColor = [UIColor clearColor];
        webViewForSelectDate.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    }
    else
    {
        [webViewForSelectDate setFrame:webFrame];
    }
    //所有的资源都在My97DatePicker.bundle这个文件夹里
    NSString* htmlPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"My97DatePicker.bundle/datepicker.html"];
    
    NSURL* url = [NSURL fileURLWithPath:htmlPath];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [webViewForSelectDate loadRequest:request];
    
}
-(void)showWebView
{
    [grayBG addSubview:webViewForSelectDate];
    NSString* animationKey = @"transform";
    [webViewForSelectDate.layer removeAnimationForKey:animationKey];
    CAKeyframeAnimation * animation;
    
    animation = [CAKeyframeAnimation animationWithKeyPath:animationKey];
    animation.duration = 0.6;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    animation.values = values;
    animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseInEaseOut];
    [webViewForSelectDate.layer addAnimation:animation forKey:animationKey];
}
-(void)hideWebView
{
    CGRect endFrame;
    int showEndX = webViewForSelectDate.frame.origin.x + webViewForSelectDate.frame.size.width / 2 - 1;
    int showEndY = webViewForSelectDate.frame.origin.y + webViewForSelectDate.frame.size.height / 2 - 1;
    int endWidth = 0;
    int endHeight = 0;
    endFrame.origin.x = showEndX;
    endFrame.origin.y = showEndY;
    endFrame.size.width = endWidth;
    endFrame.size.height = endHeight;
    UIGraphicsBeginImageContext(CGSizeMake(webViewForSelectDate.frame.size.width, webViewForSelectDate.frame.size.height ));
    [webViewForSelectDate.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView* closeBgView = [[UIImageView alloc] initWithImage:viewImage];
    [closeBgView setFrame:webViewForSelectDate.frame];
    [webViewForSelectDate removeFromSuperview];
    [[UIApplication sharedApplication].keyWindow addSubview:closeBgView];
    [UIView transitionWithView:[UIApplication sharedApplication].keyWindow
                      duration:0.4
                       options:UIViewAnimationOptionTransitionNone
                    animations:^(void)
     {
         [closeBgView setFrame:endFrame];
     }
                    completion:^(BOOL finished)
     {
         if (finished)
         {
             //如果需要的话，动画结束时在这里做些事情
             
             [closeBgView removeFromSuperview];
             [self setGrayBgHidden];
         }
         
     }];
    
    
}
//准备灰色蒙板
-(void)readyGrayBG:(CGFloat)alpha
{
    CGRect grayFrame = [UIApplication sharedApplication].keyWindow.frame;
    grayFrame.origin.x = 0;
    grayFrame.origin.y = 0;
    if(grayBG == nil)
    {
        grayBG = [[UIView alloc] initWithFrame:grayFrame];
        //用来接收灰色蒙板点击事件的button
        UIButton *grayClickView = [[UIButton alloc] initWithFrame:grayFrame];
        [grayClickView addTarget:self action:@selector(onGrayBgClick) forControlEvents:UIControlEventTouchUpInside];
        [grayClickView setBackgroundColor:[UIColor clearColor]];
        [grayBG addSubview:grayClickView];
    }
    else
    {
        [grayBG removeFromSuperview];
        [grayBG setFrame:grayFrame];
        //用来接收点击事件的button
        UIView* grayClickView = [[grayBG subviews] objectAtIndex:0];
        [grayClickView setFrame:grayFrame];
    }
    grayBG.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:alpha];
    [[UIApplication sharedApplication].keyWindow addSubview:grayBG];
}
//点击了灰色蒙板
-(void)onGrayBgClick
{
    [self hideWebView];
}
-(void)setGrayBgHidden
{
    [grayBG removeFromSuperview];
}
#pragma mark - delegate of webview
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL* URL = [request URL];
    NSString* scheme = URL.scheme;
    NSString* resourceSpecifier = [URL resourceSpecifier];
    if ([scheme isEqualToString:CUSTOM_PROTOCOL_SCHEME])
    {
        //该分支是webview的js环境中通过window.location = "....."触发的
        NSString* paras = nil;
        NSRange range = [resourceSpecifier rangeOfString:CUSTOM_EXECUTESCRIPT];
        if (range.location != NSNotFound)
        {
            paras = [resourceSpecifier substringFromIndex:range.location + [CUSTOM_EXECUTESCRIPT length] ];
        }
        else
        {
            paras = [NSString stringWithString:resourceSpecifier];
        }
        if ([paras length] > 0)
        {
            NSData* decodeBase64Data = [GTMBase64 decodeString:paras ];
            paras = [NSString stringWithCString:[decodeBase64Data bytes] encoding:NSUTF8StringEncoding ];
        }
        
        
        [self window_nativePage_sendNeWRequest:webView];
        self.text = paras;
        [self hideWebView];
        return NO;
    }
    //其他方式，放行，交由浏览器自己处理
    return YES;
}
-(void)window_nativePage_sendNeWRequest:(UIWebView*)webView
{
    //window.location动作是放在浏览器注入脚本的一个队列里的，通过setTime方法用线程调用
    //这样可以防止后来的window.location覆盖掉之前的window.location,确保每个注入脚本的逻辑都能得到执行
    //每执行完一个window.location转向的逻辑都会调用一次sendNeWRequest,保持队列畅通
    [webView stringByEvaluatingJavaScriptFromString:@"window.nativePage.sendNeWRequest();"];
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self showWebView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //因为webview加载html可能会稍微耗时，弹出的时候隐藏在日历后面的input输入框会显示出来，因此等webview加载完毕再显示
    [self showWebView];
}
@end
