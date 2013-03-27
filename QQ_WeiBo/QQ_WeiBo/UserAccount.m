//
//  QVerifyWebViewController.m
//  QWeiboSDK4iOSDemo
//
//  Created   on 11-1-14.
//   
//

#import "UserAccount.h"
#import "QWeiboSyncApi.h"
#import "ManageAppKeys.h"

#define VERIFY_URL @"http://open.t.qq.com/cgi-bin/authorize?oauth_token="

@implementation UserAccount

- (id)init{
    if (self == [super init]) {
        
    }
    return self;
}
- (void)dealloc {
    [super dealloc];
}
//加载 WebView
- (void)loadQWebView{
    mWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 300)];
	mWebView.delegate = self;
	[self addSubview:mWebView];

	NSString *url = [NSString stringWithFormat:@"%@%@", VERIFY_URL, [[ManageAppKeys shareManageAppKeys] tokenKey]];
	NSURL *requestUrl = [NSURL URLWithString:url];
	NSURLRequest *request = [NSURLRequest requestWithURL:requestUrl];
	[mWebView loadRequest:request];

}

#pragma mark -
#pragma mark private methods

-(NSString*) valueForKey:(NSString *)key ofQuery:(NSString*)query
{
	NSArray *pairs = [query componentsSeparatedByString:@"&"];
	for(NSString *aPair in pairs){
		NSArray *keyAndValue = [aPair componentsSeparatedByString:@"="];
		if([keyAndValue count] != 2) continue;
		if([[keyAndValue objectAtIndex:0] isEqualToString:key]){
			return [keyAndValue objectAtIndex:1];
		}
	}
	return nil;
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
	
	NSString *query = [[request URL] query];
	NSString *verifier = [self valueForKey:@"oauth_verifier" ofQuery:query];
	
	if (verifier && ![verifier isEqualToString:@""]) {
				
		QWeiboSyncApi *api = [[[QWeiboSyncApi alloc] init] autorelease];
		NSString *retString = [api getAccessTokenWithConsumerKey:[[ManageAppKeys shareManageAppKeys]appKey]
												  consumerSecret:[[ManageAppKeys shareManageAppKeys]appSecret] 
												 requestTokenKey:[[ManageAppKeys shareManageAppKeys]tokenKey] 
											  requestTokenSecret:[[ManageAppKeys shareManageAppKeys]tokenSecret] 
														  verify:verifier];
		NSLog(@"\nget access token:%@", retString);
		[[ManageAppKeys shareManageAppKeys] parseTokenKeyWithResponse:retString];
		[[ManageAppKeys shareManageAppKeys] saveDefaultKey];
		
//		QWeiboDemoViewController *demo = [[QWeiboDemoViewController alloc] init];
//		[appDelegate.navigationController popViewControllerAnimated:NO];
//		[appDelegate.navigationController pushViewController:demo animated:YES];
//		[demo release];
		
		return NO;
	}
	
	return YES;
}


@end
