//
//  QOauthKey.h
//  QWeiboSDK4iOS
//
//  Created on 11-1-12.
//  
//

#import <Foundation/Foundation.h>


@interface QOauthKey : NSObject {
	
	NSString *consumerKey;
	NSString *consumerSecret;
	NSString *tokenKey;
	NSString *tokenSecret;
	NSString *verify;
	NSString *callbackUrl;

}

@property (nonatomic, assign) NSString *consumerKey;
@property (nonatomic, assign) NSString *consumerSecret;
@property (nonatomic, assign) NSString *tokenKey;
@property (nonatomic, assign) NSString *tokenSecret;
@property (nonatomic, assign) NSString *verify;
@property (nonatomic, assign) NSString *callbackUrl;


@end
