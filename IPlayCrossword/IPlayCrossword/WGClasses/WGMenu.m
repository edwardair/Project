//
//  WGMenuSprite.m
//  Classes
//
//  Created by ZYJ on 13-1-22.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "WGMenu.h"

@interface WGMenu()

@property (nonatomic,assign) SEL selector;
@property (nonatomic,retain) id target;

@end
@implementation WGMenu

static int kTagIndex;

//CCMenuItem
+(id) menuWithNames: (NSString *) name, ...
{
    kTagIndex = 0;
    
	va_list args;
	va_start(args,name);
    
	CCMenu * s = [[[self alloc] initWithNames: name vaList:args] autorelease];
    
    //默认下 CCMenu 坐标为CGPointZero
    s.position = CGPointZero;
    
	va_end(args);
	return s;
}
-(id) initWithNames: (NSString *) name vaList: (va_list) args
{

	NSMutableArray *array = nil;
	if( name ) {
		array = [NSMutableArray arrayWithObject:[self initItem:name]];
		NSString *i = va_arg(args, NSString*);

		while(i) {
			[array addObject:[self initItem:i]];
			i = va_arg(args, NSString*);
		}
	}
    
	return [self initWithArray:array];
}
-(WGMenuItem *)initItem:(NSString *)name_{
    NSArray *name = [name_ componentsSeparatedByString:@"."];

    WGMenuItem *item = [WGMenuItem itemWithNormalImage:name_
                                              selectedImage:[name[0] stringByAppendingString:@"_.png"]
                                                     target:self
                                                   selector:@selector(menuPressed:)];
    item.index = kTagIndex++;

    return item;
}

//setParent 并且 设置 delegate = parent
- (void)setMenuParent:(id )parent{
    [parent addChild:self];
}
- (void)setMenuParent:(id )parent z:(int )zOrder{
    [parent addChild:self z:zOrder];
}

//Position
- (void)setItemsPosition:(CGPoint ) p, ...{
    va_list args;
	va_start(args,p);
    
	[self setItemPosition:p vaList:args];
    
	va_end(args);
}
- (void)setItemPosition:(CGPoint )p vaList:(va_list) args{
    int k = self.children.count;
    int i = 0;
    WGMenuItem *item = [self.children objectAtIndex:i];
    item.position = p;
    CGPoint nextPos_ = va_arg(args, CGPoint);

    while (i<(k-1)) {
        ++i;
        item = [self.children objectAtIndex:i];
        item.position = nextPos_;
    }
}

//SEL
- (void)addTarget:(id )target selecotr:(SEL )selector{
    _target = target;
    _selector = selector;
}

//按钮点击触发方法
- (void)menuPressed:(WGMenuItem *)item{
    [_target performSelector:_selector withObject:item];
}

@end


@implementation WGMenuItem

@end
