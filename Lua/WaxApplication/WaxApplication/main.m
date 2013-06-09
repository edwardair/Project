//
//  main.m
//  WaxApplication
//
//  Created by Apple on 13-6-3.
//  Copyright (c) 2013年 Apple. All rights reserved.
//

//这是发生奇迹的地方！
// Wax并不使用nib文件来装入主视图，一切在AppDelegate.lua文件里面完成
#import <UIKit/UIKit.h>
#import "wax.h"
#import "wax_http.h"
#import "wax_json.h"
#import "wax_filesystem.h"
int main(int argc, char *argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    wax_start("AppDelegate.lua", luaopen_wax_http, luaopen_wax_json, luaopen_wax_filesystem, nil);
    
    int retVal = UIApplicationMain(argc, argv, nil, @"AppDelegate");
    [pool release];
    return retVal;
}


