//
//  ViewController.m
//  abc
//
//  Created by BlackApple on 13-4-16.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (strong,nonatomic) UITextField* tt;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboard:) name:UIKeyboardWillShowNotification object:nil];
    
    _t1.delegate = self;
    _t2.delegate = self;
    _t3.delegate = self;

    
    UIGestureRecognizer *g = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click)];
    [self.view addGestureRecognizer:g];
    [g setCancelsTouchesInView:NO];
}
- (void)click{
    [_t1 resignFirstResponder];
    [_t2 resignFirstResponder];
    [_t3 resignFirstResponder];
}
void NSLogFrame(CGRect frame){
    NSLog(@"%f,%f,%f,%f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
}

- (void)keyboard:(id )sender{
    NSLog(@"键盘 显现");
    
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    
    CGRect frame = _tt.frame;
    NSLogFrame(frame);
    
   frame = [_s convertRect:frame toView:self.view];
    NSLogFrame(frame);

    CGPoint p = _tt.center;
    p = [_s convertPoint:p toView:self.view];
    
    NSLog(@"%f,%f",p.x,p.y);
    NSLog(@"%f,%f",frame.origin.x+frame.size.width/2,frame.origin.y+frame.size.height/2);
    
    float sub = p.y-(rect.size.height-216.0-frame.size.height/2);
    
    
    [UIView beginAnimations:@"MoveUp" context:nil];
    [UIView setAnimationDuration:.2f];
    NSLog(@"上移 ");
    self.view.transform = CGAffineTransformMakeTranslation(0, -sub);
    [UIView commitAnimations];
    

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _tt = textField;
    return YES;
}


@end
