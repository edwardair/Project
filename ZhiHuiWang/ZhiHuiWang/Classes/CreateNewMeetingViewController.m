//
//  CreateNewMeetingViewController.m
//  ZhiHuiWang
//
//  Created by BlackApple on 13-3-25.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "CreateNewMeetingViewController.h"
#import "My97DatePicker.h"
#import "ShowDownButton.h"
#import "UAndDLoad.h"
#import "SBJsonResolveData.h"
#import "MeetingMemberCell.h"
#define Title @"新建会议"

@interface CreateNewMeetingViewController (){
    UIView *curPresentUIView;
}
@property (strong,nonatomic) id textKeyBoard;
@end

@implementation CreateNewMeetingViewController

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

    self.parentViewController.navigationController.title = Title;
    
    //-------------------------新建会议
    _meetingName.delegate = self;
    _meetingStartDate.delegate = self;
    _meetingEndDate.delegate = self;
    _meetingAddress.delegate = self;
    _meetingSponsor.delegate = self;
    _meetingJoiner.delegate = self;
    _meetingTheme.delegate = self;
    _meetingRequriements.delegate = self;
    
    _meetingTheme.editable = YES;
    _meetingRequriements.editable = YES;

    _bottomScrollView.contentSize = CGSizeMake(_bottomScrollView.contentSize.width, _bottomScrollView.contentSize.height+700);
    
    _bottomScrollView.delegate = self;

<<<<<<< HEAD
    [_meetingType initializeButton];
    _meetingType.downMenus = [SBJsonResolveData shareMeeting].meetingNameList;
    
=======
//    NSData *data = [UAndDLoad downLoadWithUrl:GetMeetingList];
//    NSMutableArray *nameArray = [self getMeetingNameList:data];
//    [_meetingType initializeButtonData:nameArray];

>>>>>>> n
    //-------------------------人员管理
    [_MM_MeetingName initializeButton];
    _MM_MeetingName.downMenus = [SBJsonResolveData shareMeeting].meetingNameList;
    _MM_MeetingName.delegate = self;
    _MM_MeetingName.selector = @selector(MM_MeetingNameButton);

    _MM_MemberList.dataSource = self;
    _MM_MemberList.delegate = self;
    
   self.names = [NSMutableArray arrayWithObjects:@"A",@"B",@"C",@"A",@"A",@"A",@"B",@"C",@"A",@"A",@"A",@"B",@"C",@"A",@"A",nil];
    
    [_MM_MemberList reloadData];
    

    //-------------------------群组管理
    //-------------------------议程管理

    
    
    UIGestureRecognizer *emptyAreaTouched = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignKeyboardInOtherArea)];
    [emptyAreaTouched setCancelsTouchesInView:NO];

    [_bottomScrollView addGestureRecognizer:emptyAreaTouched];
    
    [self CreateNewMeeting:nil];
    
}
- (void)reloadMemberList{
    self.names = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",@"1",@"2",@"3",nil];
    [_MM_MemberList reloadData];
}
#pragma mark 弹出警告
- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)msg
                  delegate:(id )delegate
         cancelButtonTitle:(NSString *)cancle
          otherButtonTitle:(NSString *)other{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:msg delegate:delegate cancelButtonTitle:cancle otherButtonTitles:other, nil];
    [alert show];
}
#pragma mark 新建会议  二级 按钮
enum{
    CNM_C,
    CNM_M,
    CNM_G,
    CNM_S,
};
- (IBAction)CreateNewMeeting:(UIButton *)sender{
    //sender为nil是 tag默认为0

    //选中框
    if (sender) {
        _coverImage.center = sender.center;
    }

    UIView *temp = nil;
    switch (sender.tag) {
        case CNM_C:
            temp = _createNewMeetingView;
            break;
        case CNM_M:
            temp = _memberManageView;
            break;
        case CNM_G:
            temp = nil;
            break;
        case CNM_S:
            temp = nil;
            break;
        default:
            break;
    }

    if (temp) {
        if (temp.superview) {
            if (temp.hidden) {
                temp.hidden = NO;
            }
        }else{
            [_bottomScrollView addSubview:temp];
            [temp setTransform:CGAffineTransformMakeTranslation(0, 65)];
        }
        if (curPresentUIView && ![curPresentUIView isEqual:temp]) {
            curPresentUIView.hidden = YES;
        }
        curPresentUIView = temp;
    }

}
#pragma mark --------------------新建会议  子菜单
#pragma mark 新建会议 中 "确定"按钮
- (BOOL)checkPostEnable:(UIView *)curPresentView{
    if (_meetingType.meetingId<=1) {
        NSLog(@"会议类型 为空");
        return NO;
    }
    for (UIView *subView in curPresentView.subviews) {
        if ([subView isKindOfClass:[UITextField class]]) {
            UITextField *temp = (UITextField *)subView;
            //UITextField 当placeholder为“必填”，并且text为空时 无法上传
            if ([[temp placeholder] isEqualToString:@"必填"]) {
                if (temp.text.length==0) {
                    NSLog(@"必填项为空 %@",temp.description);
                    return NO;
                }
            }
        }else if ([subView isKindOfClass:[UITextView class]]){
            UITextView *temp = (UITextView *)subView;
            //UITextView 默认为为“必填”，所以当text为空时 无法上传
            if (temp.text.length==0) {
                NSLog(@"必填项为空 %@",temp.description);
                return NO;
            }
        }
    }
    return YES;
}
- (IBAction)CreateNewMeeting_OK{
    if (![self checkPostEnable:_createNewMeetingView]) {
        [self showAlertWithTitle:nil message:@"必填项目不能为空" delegate:self cancelButtonTitle:@"OK" otherButtonTitle:nil];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_meetingName.text forKey:HYName];
    [params setObject:_meetingAddress.text forKey:HYAddress];
    [params setObject:_meetingStartDate.text forKey:HYStartTime];
    [params setObject:_meetingEndDate.text forKey:HYEndTime];
    [params setObject:_meetingSponsor.text forKey:HYZBF];
    [params setObject:_meetingJoiner.text?_meetingJoiner.text:@"" forKey:HYXBF];
     //TODO: 会议类型关键字无定义
//    [params setObject:_meetingType forKey:HYTheme]; 
    [params setObject:_meetingTheme.text forKey:HYTheme];
    [params setObject:_meetingRequriements.text forKey:HYRequirments];
    
    //上传数据
    [UAndDLoad upLoad:params withURL:ModifyData];
    
}
#pragma mark 新建会议 中 "全部重置"按钮
- (IBAction)CreateNewMeeting_ResetAll{
    for (UIView *subView in _createNewMeetingView.subviews) {
        if ([subView isKindOfClass:[UITextView class]]) {
            [(UITextView *)subView setText:nil];
        }else if ([subView isKindOfClass:[UITextField class]]) {
            [(UITextField *)subView setText:nil];
        }
    }
    [_meetingType setTitle:@"--请选择--" forState:UIControlStateNormal];
    _meetingType.meetingId = 0;
}

#pragma mark --------------------人员管理  子菜单
- (void)MM_MeetingNameButton{
    NSLog(@"tableView 显示数据");
    [self reloadMemberList];
}
- (IBAction)MM_AddMember:(id)sender{
    UIView *addView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].applicationFrame];
    addView.backgroundColor = [UIColor grayColor];
    [_memberManageView addSubview:addView];
}//添加


#pragma mark --------------------群组管理  子菜单
#pragma mark --------------------议程管理  子菜单


#pragma mark 注销键盘
- (IBAction)resignKeyboard:(id)sender {
    [sender resignFirstResponder];
    self.textKeyBoard = nil;

}

#pragma mark 点击空白区域 注销键盘  UIButton的下拉菜单
- (void)resignKeyboardInOtherArea{
    if (self.textKeyBoard) {
        [self.textKeyBoard resignFirstResponder];
        self.textKeyBoard = nil;
    }
    [self hideMeetingTypeButton];
}
- (void)hideMeetingTypeButton
{
    if (!_meetingType.downScrollView.hidden) {
        _meetingType.downScrollView.hidden = YES;
    }
}
#pragma mark UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self hideMeetingTypeButton];

    NSLog(@"ShouldBeginEditing:%@",textField.text);
    self.textKeyBoard = textField;
    
    if ([textField isEqual:_meetingStartDate] || [textField isEqual:_meetingEndDate]) {
        [(My97DatePicker *)textField selectDate];
        return NO;
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    NSLog(@"%@",textField.text);
    if ([textField isEqual:_meetingStartDate] || [textField isEqual:_meetingEndDate]) {
        NSLog(@"处理时间格式");
        
    }
    
    return YES;
}

#pragma mark UITextView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [self hideMeetingTypeButton];

    self.textKeyBoard = textView;

    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [self resignKeyboard:textView];
        return NO;
    }
    return YES;
}
#pragma mark UITableView Delegate
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _names.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = @"Title";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:title];
    if (!cell) {
        cell = [[MeetingMemberCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:title];
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, cell.frame.size.height);
    }
    
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [_names objectAtIndex:row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"tableViewCell 选中 %d",[indexPath row]);
    
    MeetingMemberCell *cell = (MeetingMemberCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    CellPushedViewController *c = [[CellPushedViewController alloc]initWithNibName:@"CellPushedViewController" bundle:nil];
//    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:c];
    [self.parentViewController.navigationController pushViewController:c animated:YES];
    
    c.field.text = cell.name;
    c.title = cell.name;
    
//    UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:nil action:nil];
//    nav.navigationItem.backBarButtonItem = back;

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.names removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source.
        [_MM_MemberList deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        [_MM_MemberList insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];

    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
