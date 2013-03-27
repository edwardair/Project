//
//  ManageAppKeys.h
//  QQ_WeiBo
//
//  Created by ZYJ on 12-12-13.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ManageAppKeys : NSObject {
    
}
@property (nonatomic, copy) NSString *appKey;
@property (nonatomic, copy) NSString *appSecret;
@property (nonatomic, copy) NSString *tokenKey;
@property (nonatomic, copy) NSString *tokenSecret;
@property (nonatomic, copy) NSString *verifier;
@property (nonatomic, copy) NSString *response;

+(id)shareManageAppKeys;

- (void)parseTokenKeyWithResponse:(NSString *)response;

- (void)saveDefaultKey;

@end
