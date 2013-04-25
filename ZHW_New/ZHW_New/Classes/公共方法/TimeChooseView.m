//
//  TimeChooseView.m
//  ZhiHuiWang
//
//  Created by BlackApple on 13-4-8.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "TimeChooseView.h"
#import "CommonMethod.h"
@interface TimeChooseView(){
    UITapGestureRecognizer *emptyTouched;
}
@end
@implementation TimeChooseView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.hidden = YES;

//        _year = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
//        [self addSubview:_year];
//        _year.backgroundColor = [UIColor lightGrayColor];
//        _year.textAlignment = UITextAlignmentCenter;
        _datePicker = [[UIDatePicker alloc] init];
//        _datePicker.frame = CGRectMake(0, _year.frame.size.height, frame.size.width, 216);
        [_datePicker setLocale:[NSLocale currentLocale]];
        [_datePicker setTimeZone:[NSTimeZone localTimeZone]];
        [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_datePicker];
        
        
        emptyTouched = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignTimeChooseView)];
        [[[[UIApplication sharedApplication] keyWindow] rootViewController].view addGestureRecognizer:emptyTouched];
//        [emptyTouched setCancelsTouchesInView:NO];
        emptyTouched.enabled = NO;
        
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
- (void)dateChanged:(UIDatePicker *)p{
    NSDate *date = [p date];

    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSMutableString *dateAndTime =  [NSMutableString stringWithString:[formatter stringFromDate:date]];
    
    NSString *totalDate = [NSString stringWithFormat:@"%@:00",dateAndTime];
    _timeField.text = totalDate;

    NSRange rang = {4,12};
    [dateAndTime deleteCharactersInRange:rang];

//    self.year.text = [NSString stringWithFormat:@"%@年",dateAndTime];
    
}
- (void)setTimeField:(UITextField *)timeField{
    _timeField = timeField;
    
    if (timeField.text.length>0) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date=[formatter dateFromString:timeField.text];
        [_datePicker setDate:date];
    }else{
        [_datePicker setDate:[NSDate date]];
    }
    [self dateChanged:_datePicker];

}
- (void)resignTimeChooseView{
    [self showPicker:NO withField:nil];
}

- (void)showPicker:(BOOL)show withField:(UITextField *)field{
    //如果 show为YES并且view.hidden 为NO；或者 NO和YES，则不进行下面操作
    if ((show && !self.hidden) || (!show && self.hidden)) {
        if ((show && !self.hidden) && ![field isEqual:_timeField]) {
            self.timeField = field;
        }
        return;
    }
    
    //允许点击空区域隐藏self
    emptyTouched.enabled = show;

    self.timeField = field;
        
    float transformY = (show?-1:1)*(self.frame.size.height);
//    NSLog(@"%f",transformY);
    [UIView beginAnimations:@"TimeChooseView" context:NULL];
    
    [UIView setAnimationDuration:.25f];
    
    if (!show) {
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(hide)];
    }else
        self.hidden = NO;
    
    self.transform = CGAffineTransformMakeTranslation(0, transformY);
    
    [UIView commitAnimations];
    
}
- (void)hide{
    self.hidden = YES;
}

@end
