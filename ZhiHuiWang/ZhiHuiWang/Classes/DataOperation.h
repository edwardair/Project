//
//  DataOperation.h
//  ZhiHuiWang
//
//  Created by BlackApple on 13-3-27.
//  Copyright (c) 2013年 BlackApple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataOperation : NSOperation{
}

@property (nonatomic,strong) UIImage *theImage;
- (NSString *) UpLoading;
@end
