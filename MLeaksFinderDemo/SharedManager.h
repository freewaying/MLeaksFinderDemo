//
//  SharedManager.h
//  MLeaksFinderDemo
//
//  Created by freewaying on 2017/12/6.
//  Copyright © 2017年 freewaying@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SharedManager : NSObject

@property (nonatomic, strong) id employee;

+ (instancetype)sharedInstance;

@end
