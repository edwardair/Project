//
//  QWeiBoView.m
//  QQ_WeiBo
//
//  Created by ZYJ on 12-12-13.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "OauthView.h"
#import "QWeiboSyncApi.h"
#import "UserAccount.h"
#import "ManageAppKeys.h"
#define AppKey @"801203744"
#define AppSecret @"3d643e2e2ef101ea706accc4bd4a6fed"

@implementation OauthView
- (id)init{
    if (self == [super init]) {
        [self loadQQWeb];
    }
    return self;
}
- (void)dealloc{
    [super dealloc];
}
#pragma mark 微博 入口
- (void)loadQQWeb {
    NSString *consumerKey = AppKey;
	NSString *consumerSecret = AppSecret;
    
	if (![consumerKey isEqualToString:@""] && ![consumerSecret isEqualToString:@""]) {
        
			QWeiboSyncApi *api = [[[QWeiboSyncApi alloc] init] autorelease];
			NSString *retString = [api getRequestTokenWithConsumerKey:consumerKey consumerSecret:consumerSecret];
			NSLog(@"Get requestToken:%@", retString);
			
			[[ManageAppKeys shareManageAppKeys] parseTokenKeyWithResponse:retString];
			
			UserAccount *user =
            [[UserAccount alloc] init];
			
//			[appDelegate.navigationController pushViewController:verifyController animated:YES];
			[user release];
		
		
	}
	
}
@end
