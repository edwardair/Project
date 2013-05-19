//
//  PngPixelErgodic.h
//  LGF15_KeWen
//
//  Created by ZYJ on 12-12-25.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "WGCocos2d.h"

@interface WGPngPixelErgodic : NSObject {
    
}
+(NSMutableArray *)RequestImagePixelData:(UIImage *)Image
                            atTouchPoint:(CGPoint )touchLocation
                               touchedSp:(CCSprite *)sp_;
@end
