//
//  GirdView.h
//  cqhot
//
//  Created by ZL on 4/24/13.
//  Copyright (c) 2013 gitmac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GridViewDelegate <NSObject>

- (void)touchGridView:(id)gridView;

@end

@interface GridView : UIView

@property (nonatomic,weak) IBOutlet UIImageView *imageView;
@property (nonatomic,weak) IBOutlet UILabel *titleLabel;
@property (nonatomic,strong) NSDictionary *userInfo;
@property (assign, nonatomic) id <GridViewDelegate> delegate;
@end
