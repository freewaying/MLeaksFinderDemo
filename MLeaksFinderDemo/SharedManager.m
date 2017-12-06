//
//  SharedManager.m
//  MLeaksFinderDemo
//
//  Created by freewaying on 2017/12/6.
//  Copyright © 2017年 freewaying@gmail.com. All rights reserved.
//

#import "SharedManager.h"

@implementation SharedManager

+ (instancetype)sharedInstance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

@end
