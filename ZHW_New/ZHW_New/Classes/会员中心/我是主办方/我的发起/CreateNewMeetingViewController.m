//
//  CreateNewMeetingViewController.m
//  ZhiHuiWang
//
//  Created by BlackApple on 13-3-25.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import "CreateNewMeetingViewController.h"
#import "ShowDownButton.h"
#import "UAndDLoad.h"
#import "SBJsonResolveData.h"
#import "MeetingMemberCell.h"
#import "StaticManager.h"
#import "GroupManagerView.h"
#import "MeetingManagerView.h"
#import "TimeChooseView.h"
#import "CommonMethod.h"
#import "RootViewController.h"
//#define Title @"新建会议"

@interface CreateNewMeetingViewController (){
    UIView *curPresentUIView;
}
@property (strong,nonatomic) id textKeyBoard;
@property (strong,nonatomic) TimeChooseView *timeChooseView;
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
    
    [RootViewController shareRootViewController].rootScrollView.scrollEnabled = NO;

    // Do any additional setup after loading the view from its nib.

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

    _bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 65, 320, applicationFrame().size.height-65)];
    _bottomScrollView.scrollEnabled = YES;
    [self.view addSubview:_bottomScrollView];

    [_meetingType initializeButton];
    [[SBJsonResolveData shareMeeting] setMeetingNameList:nil];
    NSMutableArray *a = [NSMutableArray arrayWithObject:@"女人"];
    NSMutableArray *b = [NSMutableArray arrayWithObject:@"娱乐"];
    NSMutableArray *c = [NSMutableArray arrayWithObject:@"体育"];
    NSMutableArray *d = [NSMutableArray arrayWithObject:@"房产"];
    NSMutableArray *e = [NSMutableArray arrayWithObject:@"财经"];
    NSMutableArray *f = [NSMutableArray arrayWithObject:@"国际"];
    NSMutableArray *g = [NSMutableArray arrayWithObject:@"国内"];
    NSMutableArray *A = [NSMutableArray arrayWithObjects:a,b,c,d,e,f,g, nil];
    _meetingType.showDataArray = A;

    //-------------------------人员管理
    [_MM_MeetingName initializeButton];
    _MM_MeetingName.delegate = self;
    _MM_MeetingName.selector = @selector(MM_MeetingNameButton);
    [[SBJsonResolveData shareMeeting] setMeetingNameList:nil];

    _MM_MeetingName.showDataArray = [[SBJsonResolveData shareMeeting] meetingNameList];


    
    _MM_MemberList.dataSource = self;
    _MM_MemberList.delegate = self;
    
    _MemberListOfAMeeting = [[NSMutableArray alloc]init];
    
    //-------------------------群组管理

    
    //-------------------------议程管理

    

    UIGestureRecognizer *emptyAreaTouched = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignKeyboardInOtherArea)];
    [emptyAreaTouched setCancelsTouchesInView:NO];

    [self.view addGestureRecognizer:emptyAreaTouched];
    
    [self CreateNewMeeting:nil];
    
    
    CGRect screenRect = [[UIScreen mainScreen]applicationFrame];
    
    _timeChooseView = [[TimeChooseView alloc]initWithFrame:CGRectMake(0, screenRect.size.height, screenRect.size.width, 216)];

    [self.parentViewController.view addSubview:_timeChooseView];
    [self.parentViewController.view bringSubviewToFront:_timeChooseView];

    
    UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    UIBarButtonItem *add = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(CreateNewMeeting_OK)];
    self.navigationItem.leftBarButtonItem = back;
    self.navigationItem.rightBarButtonItem = add;
    
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
    [RootViewController shareRootViewController].rootScrollView.scrollEnabled = YES;

}
- (void)reloadMemberList{
    
//    self.names = [UAndDLoad downLoadWithUrl:<#(NSString *)#>]
    [_MM_MemberList reloadData];
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
//        _coverImage.center = sender.center;
        [StaticManager chooseCover:_coverImage MoveTo:sender.center];
    }

    UIView *temp = nil;
    switch (sender.tag) {
        case CNM_C:
            temp = _createNewMeetingView;
            self.navigationItem.title = @"新建会议";
            _bottomScrollView.contentSize = CGSizeMake(_bottomScrollView.contentSize.width, 630);
            [self.navigationItem.rightBarButtonItem setTarget:self];
            [self.navigationItem.rightBarButtonItem setAction:@selector(CreateNewMeeting_OK)];
            break;
        case CNM_M:
            temp = _memberManageView;
            self.navigationItem.title = @"人员管理";
            _bottomScrollView.contentSize = CGSizeMake(_bottomScrollView.contentSize.width, 0);
            [self.navigationItem.rightBarButtonItem setAction:@selector(MM_AddMember)];
            [self.navigationItem.rightBarButtonItem setTarget:self];
            break;
        case CNM_G:
        {
            if (!_groupManageView) {
                NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"GroupManagerView" owner:self options:nil];
                _groupManageView = (GroupManagerView *)[nibs objectAtIndex:0];
                _groupManageView.superViewController = self;
                
            }
        }
            temp = (UIView *)_groupManageView;
            self.navigationItem.title = @"群组管理";
            _bottomScrollView.contentSize = CGSizeMake(_bottomScrollView.contentSize.width, 0);
            [self.navigationItem.rightBarButtonItem setAction:@selector(addOneGroup)];
            [self.navigationItem.rightBarButtonItem setTarget:_groupManageView];

            break;
        case CNM_S:
        {
            if (!_meetingManageView) {
                NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"MeetingManagerView" owner:self options:nil];
                _meetingManageView = (MeetingManagerView *)[nibs objectAtIndex:0];
                _meetingManageView.superViewController = self;
                
            }
        }
            temp = (UIView *)_meetingManageView;
            self.navigationItem.title = @"议程管理";
            _bottomScrollView.contentSize = CGSizeMake(_bottomScrollView.contentSize.width, 0);
            [self.navigationItem.rightBarButtonItem setAction:@selector(addButton)];
            [self.navigationItem.rightBarButtonItem setTarget:_meetingManageView];

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
            if (sender.tag == CNM_C) {
                [_bottomScrollView addSubview:temp];
            }else{
                [self.view addSubview:temp];
                CGRect frame = temp.frame;
                frame.origin.y += 65;
                frame.size.height = applicationFrame().size.height-65;
                temp.frame = frame;
                
                UITableView *table = nil;
                if (sender.tag == CNM_M) {
                    table = _MM_MemberList;
                }else if (sender.tag == CNM_G)
                    table = _groupManageView.GM_TableView;
                else
                    table = _meetingManageView.tableView;
                
                CGRect tableFrame = table.frame;
                tableFrame.size.height = temp.frame.size.height-[temp convertRect:tableFrame toView:self.view].origin.y;
                table.frame = tableFrame;
            }
        }
        if (curPresentUIView && ![curPresentUIView isEqual:temp]) {
            curPresentUIView.hidden = YES;
        }
        curPresentUIView = temp;
    }

}
#pragma mark --------------------新建会议  子菜单
#pragma mark 新建会议 中 "确"按钮
- (BOOL)checkPostEnable:(UIView *)curPresentView{
    if (_meetingType.meetingId<=-1) {
//        NSLog(@"会议类型 为空");
        return NO;
    }
    for (UIView *subView in curPresentView.subviews) {
        if ([subView isKindOfClass:[UITextField class]]) {
            UITextField *temp = (UITextField *)subView;
            //UITextField 当placeholder为“必填”，并且text为空时 无法上传
            if ([[temp placeholder] isEqualToString:@"必填"]) {
                if (temp.text.length==0) {
//                    NSLog(@"必填项为空 %@",temp.description);
                    return NO;
                }
            }
        }else if ([subView isKindOfClass:[UITextView class]]){
            UITextView *temp = (UITextView *)subView;
            //UITextView 默认为为“必填”，所以当text为空时 无法上传
            if (temp.text.length==0) {
//                NSLog(@"必填项为空 %@",temp.description);
                return NO;
            }
        }
    }
    return YES;
}
- (void )CreateNewMeeting_OK{
    if (![self checkPostEnable:_createNewMeetingView]) {
        [StaticManager showAlertWithTitle:nil message:@"必填项目不能为空" delegate:self cancelButtonTitle:@"OK" otherButtonTitle:nil];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_meetingName.text forKey:HYName];
    [params setObject:_meetingAddress.text forKey:HYAddress];
    [params setObject:[_meetingStartDate.text componentsSeparatedByString:@" "][0] forKey:HYStartTime];//
    [params setObject:[_meetingEndDate.text componentsSeparatedByString:@" "][0] forKey:HYEndTime];//
    [params setObject:_meetingSponsor.text forKey:HYZBF];
    [params setObject:_meetingJoiner.text?_meetingJoiner.text:@"" forKey:HYXBF];
     //TODO: 会议类型关键字无定义
    [params setObject:[NSString stringWithFormat:@"%d",_meetingType.meetingId] forKey:HYType];
    [params setObject:_meetingTheme.text forKey:HYTheme];
    [params setObject:_meetingRequriements.text forKey:HYRequirments];
    
    //上传数据
    [SBJsonResolveData createOneNewMeetingWithParams:params];
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
    _meetingType.meetingId = -1;
}

#pragma mark --------------------人员管理  子菜单
- (void)MM_MeetingNameButton{
//    NSLog(@"tableView %d 显示数据",btn.tag);
    int tag = _MM_MeetingName.meetingId;
    
    [self.MemberListOfAMeeting removeAllObjects];

    if (tag!=-1) {
        [SBJsonResolveData updateThisMeetingMembersWithIndex:tag];
        
        _MemberListOfAMeeting = [[SBJsonResolveData shareMeeting] thisMeetingMembers];
    }

    [_MM_MemberList reloadData];

}

- (void)MM_AddMember{
    if (_MM_MeetingName.meetingId==-1) {
        [StaticManager showAlertWithTitle:nil message:@"请选择一个会议" delegate:self cancelButtonTitle:@"确定" otherButtonTitle:nil];
        return;
    }
    CellPushedViewController *c = [[CellPushedViewController alloc]initWithNibName:@"CellPushedViewController" bundle:nil];
    c.delegate = self;

    [self presentModalViewController:c animated:YES];
    c.userDefineNavBar.topItem.title = @"添加参会代表";

    [c.sex setTitle:@"男" forState:UIControlStateNormal];
    [c.sex setTitle:@"男" forState:UIControlStateHighlighted];

}//添加
- (void)saveCell:(CellPushedViewController *)cellViewController addType:(int )type{

    //type = 0 为添加数据 //1 为修改数据
    //TODO: 人员添加或删除操作  同时更新服务器数据
    
    NSString *name = cellViewController.name.text;
    int sex = [cellViewController.sex.titleLabel.text isEqualToString:@"男"]?1:0;
    NSString *tel = cellViewController.tel.text;
    NSString *post = cellViewController.post.text;

    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:name forKey:CHDBName];
    [dic setObject:[NSNumber numberWithInt:sex] forKey:CHDBXb];
    [dic setObject:tel forKey:CHDBLxdh];
    [dic setObject:post forKey:CHDBZw];

    BOOL scuess = NO;
    
    switch (type) {
        case 0:
            //add
        {
            int index = _MM_MeetingName.meetingId;
            
          scuess = [SBJsonResolveData addPointMeetingWithIndex:index
                                                   Name:name
                                                    Sex:sex
                                                    Tel:tel
                                                   Post:post];
                        
        }
            break;
        case 1:
            //modify
        {
            int index = cellViewController.index;
            
           scuess = [SBJsonResolveData modifyPointMeetingWithIndex:index
                                                      Name:name
                                                       Sex:sex
                                                       Tel:tel
                                                      Post:post];
        }
            break;
        default:
            break;
    }
    
    if (scuess) {
        [cellViewController callBack];
        
        [_MM_MemberList reloadData];

    }else{
        [cellViewController editFail];
    }
    

}

#pragma mark --------------------群组管理  子菜单
- (void)GM_MeetingNameButton{
    
}

#pragma mark --------------------议程管理  子菜单


#pragma mark 注销键盘
- (IBAction)resignKeyboard:(id)sender {
    [sender resignFirstResponder];
    self.textKeyBoard = nil;
    [StaticManager resignParentView];
}

#pragma mark 点击空白区域 注销键盘  UIButton的下拉菜单
- (void)resignKeyboardInOtherArea{
    if (self.textKeyBoard) {
        [self.textKeyBoard resignFirstResponder];
        self.textKeyBoard = nil;
        [StaticManager resignParentView];

    }
    [_timeChooseView showPicker:NO withField:nil];

//    [self hideMeetingTypeButton];
}
//- (void)hideMeetingTypeButton
//{
//    if (!_meetingType.downScrollView.hidden) {
//        _meetingType.downScrollView.hidden = YES;
//    }
//}
#pragma mark UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    [self hideMeetingTypeButton];

//    NSLog(@"ShouldBeginEditing:%@",textField.text);
    NSLogFrame(textField.frame);
    if ([textField isEqual:_meetingStartDate] || [textField isEqual:_meetingEndDate]) {
        [_timeChooseView showPicker:YES withField:textField];
        if (self.textKeyBoard) {
            [self.textKeyBoard resignFirstResponder];
            self.textKeyBoard = nil;
        }
        return NO;
    }
    
    [StaticManager TextInputAnimationWithParentView:_bottomScrollView textView:textField];

    self.textKeyBoard = textField;

    [_timeChooseView showPicker:NO withField:nil];

    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

//    NSLog(@"%@",textField.text);
    if ([textField isEqual:_meetingStartDate] || [textField isEqual:_meetingEndDate]) {
        NSLog(@"处理时间格式");
        
    }
    
    return YES;
}

#pragma mark UITextView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
//    [self hideMeetingTypeButton];

    self.textKeyBoard = textView;
    
    [_timeChooseView showPicker:NO withField:nil];
        
    NSLog(@"%f,%f,%f,",textView.center.y,textView.frame.origin.y,_bottomScrollView.contentOffset.y);
    
    CGRect f2 = textView.frame;
    f2 = [_createNewMeetingView convertRect:f2 toView:_bottomScrollView];
    f2 = [_bottomScrollView convertRect:f2 toView:self.view];
    [StaticManager TextInputAnimationWithParentView:self.view textView:textView];

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
    return _MemberListOfAMeeting.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *title = @"Title";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:title];
    if (!cell) {
        cell = [[MeetingMemberCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:title];
//        NSLog(@"Cell:   %f,%f,%f,%f",cell.frame.origin.x,cell.frame.origin.y,cell.frame.size.width,cell.frame.size.height);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    
    NSUInteger row = [indexPath row];
    NSString *text = [[_MemberListOfAMeeting objectAtIndex:row] objectForKey:CHDBName];
    cell.textLabel.text = ![text isEqual:[NSNull null]]?text:@"";
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"tableViewCell 选中 %d",[indexPath row]);
    
//    MeetingMemberCell *cell = (MeetingMemberCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    CellPushedViewController *c = [[CellPushedViewController alloc]initWithNibName:@"CellPushedViewController" bundle:nil];
    c.navigationItem.title = @"编辑参会代表";
    c.delegate = self;
    //TODO: 传递cell的各参数
    NSUInteger row = [indexPath row];

    [self.navigationController pushViewController:c animated:YES];

    int sex = [[[_MemberListOfAMeeting objectAtIndex:row] objectForKey:CHDBXb] intValue];
    c.name.text = [[_MemberListOfAMeeting objectAtIndex:row] objectForKey:CHDBName];
    c.tel.text = [[_MemberListOfAMeeting objectAtIndex:row] objectForKey:CHDBLxdh];
    c.index = row;
    
    NSString *post = [[_MemberListOfAMeeting objectAtIndex:row] objectForKey:CHDBZw];
//    NSLog(@"%@",post);
    
    if (![post isEqual:[NSNull null]]) {
        c.post.text = post;
    }
    [c.sex setTitle:sex?@"男":@"女" forState:UIControlStateNormal];
    [c.sex setTitle:sex?@"男":@"女" forState:UIControlStateHighlighted];

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = [indexPath row];
    
    //tableView 删除数据操作 同时上传服务器删除数据
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
       BOOL scuess = [SBJsonResolveData deletePoitMeetingWithIndex:row];
        
        // Delete the row from the data source.
        if (scuess) {
            [_MM_MemberList deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }else
            [StaticManager showAlertWithTitle:nil message:@"删除参会代表失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitle:nil];
    
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
