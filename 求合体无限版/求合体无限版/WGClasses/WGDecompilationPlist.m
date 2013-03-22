



#import "WGDecompilationPlist.h"

@implementation WGDecompilationPlist

#pragma --------------------------------
#pragma CCsprite 与 UIImage 互转 原始代码
//  CCsprite 与 UIImage 互转 原始代码
//+(CCSprite *) convertImageToSprite:(UIImage *) image {
//    
//    CCTexture2D *texture = [[CCTexture2D alloc] initWithImage:image.CGImage resolutionType:kCCResolutionUnknown];
//    
//    CCSprite    *sprite = [CCSprite spriteWithTexture:texture];
//    
//    [texture release];
//    
//    return sprite;
//    
//}
//
//+(UIImage *) convertSpriteToImage:(CCSprite *)sprite {
//    
//    CGPoint p = sprite.anchorPoint;   
//    
//    [sprite setAnchorPoint:ccp(0,0)];  
//    
//    CCRenderTexture *renderer = [CCRenderTexture renderTextureWithWidth:sprite.contentSize.width height:sprite.contentSize.height];
//    
//    [renderer begin];
//    
//    [sprite visit];  
//    
//    [renderer end];   
//    
//    [sprite setAnchorPoint:p];  
//    
//    return [UIImage imageWithData:[renderer getUIImageAsDataFromBuffer:kCCImageFormatPNG]];
//    
//}

#pragma mark -----读取plist文件中包含的所有子元素，返回数组
+(NSArray *)calculatingTheNumberOfTheFrames:(NSString *)fileName ofType:(NSString *)type {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:fileName ofType:type];  
    
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    NSMutableDictionary *dateOfFrames = [data objectForKey:@"frames"];
    NSArray *array_ = [dateOfFrames allKeys];
    
    return array_;
}

+(void ) DecomplilationPlist:(NSString *)plistName{
   NSArray *name = [plistName componentsSeparatedByString:@"."];

    [[[WGDecompilationPlist node] cache] addSpriteFramesWithFile:plistName];
    
    NSArray *array_ = [self calculatingTheNumberOfTheFrames:name[0] ofType:name[1]];
    for (int i = 0; i < array_.count; i++) {
        NSString *pngName = [array_ objectAtIndex:i];
        
        CCSprite *sp = [CCSprite spriteWithSpriteFrameName:pngName];
        
        UIImage *image = [self convertSpriteToImage:sp];
        
        NSString *savePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@",pngName]];
        
        NSLog(@"savePath文件路径：%@",savePath);
        
        [UIImagePNGRepresentation(image) writeToFile:savePath atomically:YES];
    }

}
#pragma mark ------将UIImage转化为CCSprite
+(CCSprite *) convertImageToSprite:(UIImage *) image {
    
    CCTexture2D *texture = [[CCTextureCache sharedTextureCache] addCGImage:image.CGImage forKey:kCCResolutionUnknown];
    
    CCSprite    *sprite = [CCSprite spriteWithTexture:texture];

    return sprite;
    
}
#pragma mark ------将CCSprite转化为UIImage
+(CCRenderTexture *)drawSprite:(CCNode *)node OnRender:(CCRenderTexture *)render{
    CGPoint p = node.anchorPoint;
    
    [node setAnchorPoint:ccp(0,0)];
    
    [render begin];
    
    [node visit];
    
    [render end];
    
    [node setAnchorPoint:p];

    return render;
}
+(UIImage *) convertSpriteToImage:(CCSprite *)sprite {//可以映射 label 文字
    
        
    CCRenderTexture *renderer = [CCRenderTexture renderTextureWithWidth:sprite.contentSize.width height:sprite.contentSize.height];
    
    renderer = [WGDecompilationPlist drawSprite:sprite OnRender:renderer];
    
    return [renderer getUIImage];
}

@end
