//
//  Hotfix.h
//  Hotfix
//
//  Created by TCLios2 on 2018/4/10.
//  Copyright © 2018年 TCLios2. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 修复方法
 className 类名
 selectorName 选择器名
 isClassMethod 是否为类方法
 option AspectOptions
 AspectPositionAfter   = 0,            Called after the original implementation (default)
 AspectPositionInstead = 1,            Will replace the original implementation.
 AspectPositionBefore  = 2,            Called before the original implementation.
 AspectOptionAutomaticRemoval = 1 << 3 Will remove the hook after the first execution.
 fixImpl 修复方法的实现
 instance 方法target（实例对象或者类对象）
 originInvocation 原始方法的invocation对象
 originArguments 原始方法的参数
 function(instance, originInvocation, originArguments)
 fixMethod(NSString *className, NSString *selectorName, BOOL isClassMethod, AspectOptions option, JSValue *fixImpl)
 
 JS: fixMethod('className', 'selectorName', false, 1, function(instance, originInvocation, originArguments) {
 ...
 })
 
 调用类方法（只支持3个参数的方法）
 className 类名
 selectorName 选择器名
 args 参数数组
 id callClassMethod(NSString *className, NSString *selectorName, NSArray *args)
 
 JS: var result = callClassMethod('className', 'selectorName', [arg1, arg2, arg3]);
 
 调用实例方法（只支持3个参数的方法）
 className 类名
 selectorName 选择器名
 args 参数数组
 id callInstanceMethod(id instance, NSString *selectorName, NSArray *args)
 
 JS: var result = callInstanceMethod(instance, 'selectorName', [arg1, arg2, arg3]);
 
 Importance: 只能通过方法来访问成员变量。
 */
extern void evalString(NSString *js);
