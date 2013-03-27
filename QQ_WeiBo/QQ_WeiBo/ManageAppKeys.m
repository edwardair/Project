//
//  ManageAppKeys.m
//  QQ_WeiBo
//
//  Created by ZYJ on 12-12-13.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "ManageAppKeys.h"
#import "NSURL+QAdditions.h"

#define AppKey			@"appKey"
#define AppSecret		@"appSecret"
#define AppTokenKey		@"tokenKey"
#define AppTokenSecret	@"tokenSecret"

@implementation ManageAppKeys
//int
static ManageAppKeys *manage = nil;

+(id)shareManageAppKeys{
    if (manage == nil) {
        manage = [[ManageAppKeys alloc]init];
    }
    return manage;
}

#pragma mark -
#pragma mark instance methods

- (void)parseTokenKeyWithResponse:(NSString *)aResponse {
	
	NSDictionary *params = [NSURL parseURLQueryString:aResponse];
	self.tokenKey = [params objectForKey:@"oauth_token"];
	self.tokenSecret = [params objectForKey:@"oauth_token_secret"];
	
}

- (void)saveDefaultKey {
	
	[[NSUserDefaults standardUserDefaults] setValue:self.appKey forKey:AppKey];
	[[NSUserDefaults standardUserDefaults] setValue:self.appSecret forKey:AppSecret];
	[[NSUserDefaults standardUserDefaults] setValue:self.tokenKey forKey:AppTokenKey];
	[[NSUserDefaults standardUserDefaults] setValue:self.tokenSecret forKey:AppTokenSecret];
	[[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)dealloc {
	
	self.appKey = nil;
	self.appSecret = nil;
	self.tokenKey = nil;
	self.tokenSecret = nil;
	self.verifier = nil;
	
    [super dealloc];
}

@end
