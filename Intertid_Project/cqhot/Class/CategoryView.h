//
//  categoryView.h
//  cqhot
//
//  Created by ZL on 4/22/13.
//  Copyright (c) 2013 gitmac. All rights reserved.
//

#import "EUView.h"

@protocol CategoryViewDelegate;
@interface CategoryView : EUView<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,copy) NSArray *items;
@property (nonatomic,copy) NSString *sectionTitle;
@property (nonatomic,assign) id<CategoryViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
- (IBAction)clickSearch:(id)sender;
- (IBAction)clickFavorites:(id)sender;
- (IBAction)clickLocation:(id)sender;
- (IBAction)clickPrise:(id)sender;


@end


@protocol CategoryViewDelegate <NSObject>

- (void)categoryDidSelectedIndexPath:(NSIndexPath *)indexPath;

@end

