//
//  RepairPopoverView.h
//  WorkPlace
//
//  Created by BlackApple on 13-4-18.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RPVDelegate;
@interface RepairPopoverView : UIView<UITableViewDataSource,UITableViewDelegate>{
    id<RPVDelegate> rpvDelegate;
}
@property (nonatomic,assign) id<RPVDelegate> rpvDelegate;
- (void)show:(id)delegate;
@end

@protocol RPVDelegate <NSObject>
@required
- (void)cellSelected:(int )index;

@end