//
//  HotfixTests.m
//  HotfixTests
//
//  Created by TCLios2 on 2018/4/10.
//  Copyright © 2018年 TCLios2. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Hotfix.h"

@interface MyObject : NSObject
- (NSString *)isBoolWithCount:(int)count;
- (void)fixMethod;
- (NSString *)twoArgMethod:(NSInteger)arg1 arg2:(CGFloat)arg2;
- (NSString *)threeArgMethod:(NSInteger)arg1 arg2:(CGFloat)arg2 arg3:(CGFloat)arg3;
@property (nonatomic, assign) NSInteger count;
@end

@implementation MyObject
- (instancetype)init {
    if (self = [super init]) {
        _count = 102;
    }
    return self;
}
- (NSString *)isBoolWithCount:(int)count {
    return [NSString stringWithFormat:@"sss%d", count];
}
- (void)fixMethod {
    NSLog(@"ssss");
}
- (NSString *)twoArgMethod:(NSInteger)arg1 arg2:(CGFloat)arg2 {
    return [NSString stringWithFormat:@"arg1=%d, arg2=%f", (int)arg1, arg2];
}
- (NSString *)threeArgMethod:(NSInteger)arg1 arg2:(CGFloat)arg2 arg3:(CGFloat)arg3; {
    return [NSString stringWithFormat:@"arg1=%d, arg2=%f, arg3=%f", (int)arg1, arg2, arg3];
}
@end

@interface MySubObject : MyObject
@property (nonatomic, strong) MyObject *obj;
+ (CGFloat)getHeight;
+ (NSInteger)getIntegerWithCount:(NSInteger)count;
@end

@implementation MySubObject
- (instancetype)init {
    if (self = [super init]) {
        _obj = [[MyObject alloc] init];
    }
    return self;
}

+ (CGFloat)getHeight {
    return 77.9;
}

+ (NSInteger)getIntegerWithCount:(NSInteger)count {
    return 80 * count;
}

@end

@interface HotfixTests : XCTestCase

@end

@implementation HotfixTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSString *js = @"fixMethod('MySubObject', 'fixMethod', false, 1, function(instance, originInvocation, originArguments) {console.log('bbbb'); callInvocation(originInvocation); var result = callInstanceMethod(instance, 'isBoolWithCount:', [20]); console.log(result); var count = callInstanceMethod(instance, 'count'); console.log(count); var obj = callInstanceMethod(instance, 'obj'); console.log(obj); callInstanceMethod(obj, 'setCount:', [888]); count = callInstanceMethod(obj, 'count'); console.log(count); var url = callClassMethod('NSURL', 'URLWithString:', ['http://www.baidu.com']); console.log(url); var scheme = callInstanceMethod(url, 'scheme'); console.log(scheme); var height = callClassMethod('MySubObject', 'getHeight'); console.log(height); var str = callInstanceMethod(instance, 'twoArgMethod:arg2:', [87, 13.45]); console.log(str); str = callInstanceMethod(instance, 'threeArgMethod:arg2:arg3:', [99, 15.5, 88.23]); console.log(str); })";
    evalString(js);
    MySubObject *obj = [[MySubObject alloc] init];
    [obj fixMethod];
    NSLog(@"end");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
