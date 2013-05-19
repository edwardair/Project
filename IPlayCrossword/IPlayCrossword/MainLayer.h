//
//  MainLayer.h
//  iPlayCrossWord
//
//  Created by 丝瓜&冬瓜 on 13-5-4.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WGCocos2d.h"

@interface MainLayer : WGLayer {
    
}
+(MainLayer *)shareStaticMainLayer;
- (void)resetFilesStyle;
@end
