//
//  CommonTableView.h
//  ZHW_New
//
//  Created by BlackApple on 13-4-12.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonTableViewCell.h"
@protocol CommonTableViewDelegate;
@interface CommonTableView : UITableView<UITableViewDelegate,UITableViewDataSource>{
    id<CommonTableViewDelegate> commonTableViewDelegate;
}
@property (assign,nonatomic) id<CommonTableViewDelegate> commonTableViewDelegate;
//行 数据
@property (strong,nonatomic) NSMutableArray *rowSource;
//块 数据
@property (strong,nonatomic) NSMutableArray *sectionSource;
//Cell title
@property (strong,nonatomic) NSString *cellTitle;
//Cell 高度数据
@property (strong,nonatomic) NSMutableArray *cellRowHeight;
@end


@protocol CommonTableViewDelegate <NSObject>
@required
- (void)setCellLabelsFrams:(CommonTableViewCell *)cell;
- (void)cellClickedAtIndexPath:(NSIndexPath *)path;

@end