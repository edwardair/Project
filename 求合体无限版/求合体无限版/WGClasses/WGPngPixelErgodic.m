
//  PngPixelErgodic.m
//  LGF15_KeWen
//
//  Created by ZYJ on 12-12-25.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "WGPngPixelErgodic.h"


@implementation WGPngPixelErgodic
#pragma mark ----------------
#pragma mark 遍历图片像素点
CGColorSpaceRef colorSpace;
void *bitmapData; //内存空间的指针，该内存空间的大小等于图像使用RGB通道所占用的字节数。

//CGContextRef CreateRGBABitmapContext(CGImageRef inImage)
+ (CGContextRef )CreateRGBABitmapContext:(CGImageRef ) inImage
{
	CGContextRef context = NULL;
	int bitmapByteCount;
	int bitmapBytesPerRow;
    
	size_t pixelsWide = CGImageGetWidth(inImage); //获取横向的像素点的个数
	size_t pixelsHigh = CGImageGetHeight(inImage);
    
    
    
	bitmapBytesPerRow	= (pixelsWide * 4); //每一行的像素点占用的字节数，每个像素点的ARGB四个通道各占8个bit(0-255)的空间
	bitmapByteCount	= (bitmapBytesPerRow * pixelsHigh); //计算整张图占用的字节数
    
	colorSpace = CGColorSpaceCreateDeviceRGB();//创建依赖于设备的RGB通道
	//分配足够容纳图片字节数的内存空间
	bitmapData = malloc( bitmapByteCount );
    //创建CoreGraphic的图形上下文，该上下文描述了bitmaData指向的内存空间需要绘制的图像的一些绘制参数
	context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedLast);
    //Core Foundation中通过含有Create、Alloc的方法名字创建的指针，需要使用CFRelease()函数释放
    
	return context;
}

// 返回一个指针，该指针指向一个数组，数组中的每四个元素都是图像上的一个像素点的RGBA的数值(0-255)，用无符号的char是因为它正好的取值范围就是0-255
+(NSMutableArray *)RequestImagePixelData:(UIImage *)Image
                            atTouchPoint:(CGPoint )touchLocation
                               touchedSp:(CCSprite *)sp_{
    CGPoint p = [sp_ convertToNodeSpace:touchLocation];
	CGImageRef inImage = [Image CGImage];
    //	CGSize size = [Image size];
    //使用上面的函数创建上下文
	CGContextRef cgctx = [self CreateRGBABitmapContext:inImage];
	
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = {{0,0},{w,h}};     //将目标图像绘制到指定的上下文，实际为上下文内的bitmapData。
	CGContextDrawImage(cgctx, rect, inImage);
	unsigned char *data;
    data = (unsigned char*)CGBitmapContextGetData (cgctx);
    //释放上面的函数创建的上下文
    
    int offset = 4*(w*round(Image.size.height-p.y)+round(p.x));
    NSMutableArray *array_ = [NSMutableArray array];
    
    [array_ addObject:[NSNumber numberWithInt:data[offset+0]]];
    [array_ addObject:[NSNumber numberWithInt:data[offset+1]]];
    [array_ addObject:[NSNumber numberWithInt:data[offset+2]]];
    [array_ addObject:[NSNumber numberWithInt:data[offset+3]]];
    
    CGColorSpaceRelease( colorSpace );
    free(bitmapData);
	CGContextRelease(cgctx);
    
    return array_;
}

@end
