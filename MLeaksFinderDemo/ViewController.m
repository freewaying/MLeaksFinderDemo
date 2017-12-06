//
//  ViewController.m
//  MLeaksFinderDemo
//
//  Created by freewaying on 2017/12/6.
//  Copyright © 2017年 freewaying@gmail.com. All rights reserved.
//

#import "ViewController.h"
#import "Consumer.h"
#import "SharedManager.h"
#import <MLeaksFinder/MLeaksFinder.h>

/** Test
 *  1: block引起的循环引用
 *  2: 属性引起的循环引用
 *  3: 单例引起的内存泄漏
 *  4: dispatch_after引起的延迟释放
 *  4: 对类添加白名单
 *  5: 对类实例添加白名单
 *  6: 扩展实现对其他类的内存泄漏检测
 */
#define TEST 1

@interface ViewController ()

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) Consumer *consumer;
@property (nonatomic, copy) void (^completionBlock)(void);

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor colorWithRed:(153.0/255.0) green:(153.0/255.0) blue:(153.0/255.0) alpha:1.0];
    self.title = @"MLeaksFinderDemo";
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"A sunny day";
    [self.view addSubview:label];
    [label sizeToFit];
    label.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2 + 20);
    
    
#if TEST == 1 || TEST == 5
    //    __weak typeof(self) weakSelf = self;
    self.completionBlock = ^{
        //        __strong typeof(weakSelf) self = weakSelf;
        self.index = 2;
    };
#endif
    
#if TEST == 2
    self.consumer = [[Consumer alloc] init];
    self.consumer.delegate = self;
#endif
    
#if TEST == 3
    [SharedManager sharedInstance].employee = self;
#endif
    
#if TEST == 5
    [NSObject addClassNamesToWhitelist:@[NSStringFromClass([self class])]];
#endif
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
#if TEST == 4
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"%@ dispear", self);
    });
#endif
}

- (IBAction)clickMeButtonClicked:(id)sender {
    [self.navigationController pushViewController:[[[self class] alloc] init] animated:YES];
}

/// 扩展
- (BOOL)willDealloc {
#if TEST == 6
    return NO;
#endif
    
    if (![super willDealloc]) {
        return NO;
    }
#if TEST == 7
    MLCheck(self.test);
#endif
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"vc dealloc");
}

@end

