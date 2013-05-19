//
//  HelloWorldLayer.m
//  内存检测
//
//  Created by YJ Z on 12-9-6.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//


// Import the interfaces
#import "WGCheckRAM.h"

@implementation WGCheckRAM
- (void)openCheck{
    label = [CCLabelTTF labelWithString:nil fontName:@"Arial" fontSize:20];
    label.position = ccp(512, 384);
    label.color = ccRED;
    [self addChild:label z:INT32_MAX];
    [self schedule:@selector(update)];
}
- (void)update{
    [label setString:[NSString stringWithFormat:@"已使用内存%.2f,可使用内存:%.0f",[self usedMemory],[self availableMemory]]];
}
//检测内存
- (double)availableMemory
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),HOST_VM_INFO,(host_info_t)&vmStats,&infoCount);
    if(kernReturn != KERN_SUCCESS)
    {
        return NSNotFound;
    }
    NSLog(@"%f",((vm_page_size * vmStats.free_count) / 1024.0) / 1024.0);
    return ((vm_page_size * vmStats.free_count) / 1024.0) / 1024.0;
}

//MARK: 已使用内存
- (double)usedMemory
{
    task_basic_info_data_t taskInfo;
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    kern_return_t kernReturn = task_info(mach_task_self(),
                                         TASK_BASIC_INFO, (task_info_t)&taskInfo, &infoCount);
    if(kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    return taskInfo.resident_size / 1024.0 / 1024.0;
}

@end
