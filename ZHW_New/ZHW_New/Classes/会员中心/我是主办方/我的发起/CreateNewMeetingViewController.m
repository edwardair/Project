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
//#import "CommonMethod.h"
#import "RootViewController.h"
#import "MemberCenterViewController.h"
#import "MyCreatedMeetings.h"
//#define Title @"新建会议"

@interface CreateNewMeetingViewController (){
    UIScrollView *curPresentSView;
}
@property (strong,nonatomic) UIView *textEditor;
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
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    UIBarButtonItem *add = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(CreateNewMeeting_OK)];
    self.navigationItem.leftBarButtonItem = back;
    self.navigationItem.rightBarButtonItem = add;

    // Do any additional setup after loading the view from its nib.
    CGRect screenRect = [[UIScreen mainScreen]applicationFrame];

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

    [self CreateNewMeeting:nil];
    
    _timeChooseView = [[TimeChooseView alloc]initWithFrame:CGRectMake(0, screenRect.size.height, screenRect.size.width, 216)];

    [self.parentViewController.view addSubview:_timeChooseView];
    [self.parentViewController.view bringSubviewToFront:_timeChooseView];

    _bs1.delegate = self;
    
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
    [RootViewController shareRootViewController].rootScrollView.scrollEnabled = YES;

    [self.preView updateTableViewDataSource];
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
    UIScrollView *tempScrollView = nil;
    switch (sender.tag) {
        case CNM_C:
            temp = _createNewMeetingView;
            self.navigationItem.title = @"新建会议";
            tempScrollView = _bs1;
            [self.navigationItem.rightBarButtonItem setTarget:self];
            [self.navigationItem.rightBarButtonItem setAction:@selector(CreateNewMeeting_OK)];
            [TapResignKeyBoard shareTapResignKeyBoard].tapDelegate = self;

            break;
        case CNM_M:
            temp = _memberManageView;
            self.navigationItem.title = @"人员管理";
            tempScrollView = _bs2;
            [self.navigationItem.rightBarButtonItem setAction:@selector(MM_AddMember)];
            [self.navigationItem.rightBarButtonItem setTarget:self];
            [TapResignKeyBoard shareTapResignKeyBoard].tapDelegate = nil;
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
            tempScrollView = _bs3;
            [self.navigationItem.rightBarButtonItem setAction:@selector(addOneGroup)];
            [self.navigationItem.rightBarButtonItem setTarget:_groupManageView];
            [TapResignKeyBoard shareTapResignKeyBoard].tapDelegate = nil;
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
            tempScrollView = _bs4;
            [self.navigationItem.rightBarButtonItem setAction:@selector(addButton)];
            [self.navigationItem.rightBarButtonItem setTarget:_meetingManageView];
            [TapResignKeyBoard shareTapResignKeyBoard].tapDelegate = nil;
            break;
        default:
            break;
    }

    
    //如果底部scrollView隐藏状态 则显示
    if (tempScrollView.hidden) {
        if (!temp.superview) {
            [tempScrollView addSubview:temp];
            if (sender.tag != CNM_C) {
                CGRect frame = temp.frame;
                frame.size.height = iPhone5?438:348;
                temp.frame = frame;
                tempScrollView.contentSize = CGSizeMake(temp.frame.size.width, temp.frame.size.height);

            }else{
                tempScrollView.contentSize = CGSizeMake(temp.frame.size.width, temp.frame.size.height+(iPhone5?0:75));
            }
        }
        tempScrollView.hidden = NO;
        if (!curPresentSView) {
            curPresentSView = tempScrollView;
            curPresentSView.hidden = NO;
        }else{
            curPresentSView.hidden = YES;
            curPresentSView = tempScrollView;
        }
        
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
}


#pragma mark UITextField Delegate
#pragma mark TapDelegate

- (UIView *)willFitPointOfView{
    return self.view;
}
- (float )orgCenterYOfView{
    return 208.f;
}
- (UIView *)curClickedText{
    return _textEditor;
}
- (BOOL)statusBarShow{
    return YES;
}
- (BOOL)navigationBarShow{
    return YES;
}
- (void)keyBoardWillAppearDelegate{
    //键盘显示时  把timeChooseView隐藏
    [_timeChooseView showPicker:NO withField:nil];
}
- (void)keyBoardWillDisAppearDelegate{
    self.textEditor = nil;
}
#pragma mark --------------------------

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    NSLogCGPoint(self.view.center);
    if ([textField isEqual:_meetingStartDate] || [textField isEqual:_meetingEndDate]) {
        if (self.textEditor) {
            [self.textEditor resignFirstResponder];
        }
        [_timeChooseView showPicker:YES withField:textField];
        return NO;
    }
    
    self.textEditor = textField;

    return YES;
}

#pragma mark UITextView Delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{

    self.textEditor = textView;
    
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
- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return _tableTitleView.frame.size.height;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    //  UILabel *result = nil;
    
    UIView *result = nil;
    
    if([tableView isEqual:_MM_MemberList] && section == 0){
        _tableTitleView.backgroundColor = [UIColor grayColor];
        return _tableTitleView;
    }
    
    return result;
    
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _MemberListOfAMeeting.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int row = indexPath.row;
    
    NSString *title = @"Title";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:title];
    UILabel *code;
    UILabel *name;
    UILabel *sexAndPost;
    UILabel *tel;
    if (!cell) {
        cell = [[MeetingMemberCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:title];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        code = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 44)];
        name = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 120, 22)];
        sexAndPost = [[UILabel alloc]initWithFrame:CGRectMake(50, 22, 120, 22)];
        tel = [[UILabel alloc]initWithFrame:CGRectMake(170, 0, 120, 44)];
        
        code.textAlignment = UITextAlignmentCenter;
        name.textAlignment = UITextAlignmentCenter;
        sexAndPost.textAlignment = UITextAlignmentCenter;
        tel.textAlignment = UITextAlignmentCenter;

        code.tag = 1;
        name.tag = 2;
        sexAndPost.tag = 3;
        tel.tag = 4;

        [cell addSubview:code];
        [cell addSubview:name];
        [cell addSubview:sexAndPost];
        [cell addSubview:tel];

    }else{
        code = (UILabel *)[cell viewWithTag:1];
        name = (UILabel *)[cell viewWithTag:2];
        sexAndPost = (UILabel *)[cell viewWithTag:3];
        tel = (UILabel *)[cell viewWithTag:4];
    }
    
    code.text = [NSString stringWithFormat:@"%03d",row+1];
    name.text = [[_MemberListOfAMeeting objectAtIndex:row] objectForKey:CHDBName];
    int sexNumber = [[[_MemberListOfAMeeting objectAtIndex:row] objectForKey:CHDBXb] intValue];
    NSString *sex = sexNumber?@"男":@"女";
    NSString *post = [[_MemberListOfAMeeting objectAtIndex:row] objectForKey:CHDBZw];
    sexAndPost.text = [NSString stringWithFormat:@"%@/%@",sex,post];
    tel.text = [[_MemberListOfAMeeting objectAtIndex:row] objectForKey:CHDBLxdh];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"tableViewCell 选中 %d",[indexPath row]);
    
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
//            [_MM_MemberList reloadData];
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
