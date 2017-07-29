//
//  ViewController.m
//  NSInvocation
//
//  Created by yuanye on 2017/7/28.
//  Copyright © 2017年 yuanye. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    // 1
    [self logAString:@"A" bString:@"B"];
    
    // 2
    // 可能会有内存泄漏 https://stackoverflow.com/questions/7017281/performselector-may-cause-a-leak-because-its-selector-is-unknown
    // 最多接收 2 个参数！
    [self performSelector:@selector(logAString:bString:) withObject:@"AA" withObject:@"BB"];
    
    // 3
    /*
     idx 0: target
     idx 1: selector
     idx 从 2 开始
     idx 不能超过 NSMethodSignature 的参数个数
     */
    SEL sel = @selector(logAString:bString:);
    NSMethodSignature *signature = [self methodSignatureForSelector:sel];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:self];
    [invocation setSelector:sel];
    NSString *aString = @"AAA";
    NSString *bString = @"BBB";
    [invocation setArgument:&aString atIndex:2];
    [invocation setArgument:&bString atIndex:3];
    // 强引用参数
    // [invocation retainArguments];
    [invocation invoke];
    
    [self example];
}

- (NSString *)logAString:(NSString *)aString bString:(NSString *)bString
{
    NSString *result = [NSString stringWithFormat:@"\naString:%@\nbString:%@", aString, bString];
    NSLog(@"%@", result);
    return result;
}


- (void)example
{
    SEL sel = @selector(sumA:b:);
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:sel];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    invocation.selector = sel;
    NSInteger number1 = 10;
    NSInteger number2 = 20;
    [invocation setArgument:&number1 atIndex:2];
    [invocation setArgument:&number2 atIndex:3];
    [invocation invoke];
    
    NSNumber *sum;
    [invocation getReturnValue:&sum];
    NSLog(@"sum:%@", sum);
}

- (NSNumber *)sumA:(NSInteger)a b:(NSInteger)b
{
    NSInteger sum = a + b;
    return @(sum);
}

@end
