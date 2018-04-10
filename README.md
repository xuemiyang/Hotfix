# Hotfix
IOS简单热修复。

只需要一行代码就可以对某个类的方法进行修复。
```objc
extern void evalString(NSString *js)
```

## 修复方法
修复方法
* className 类名
* selectorName 选择器名
* isClassMethod 是否为类方法
* option AspectOptions
             * AspectPositionAfter   = 0,            Called after the original implementation (default)
             * AspectPositionInstead = 1,            Will replace the original implementation.
             * AspectPositionBefore  = 2,            Called before the original implementation.
             * AspectOptionAutomaticRemoval = 1 << 3 Will remove the hook after the first execution.
* fixImpl 修复方法的实现
             * instance 方法target（实例对象或者类对象）
             * originInvocation 原始方法的invocation对象
             * originArguments 原始方法的参数
* function(instance, originInvocation, originArguments)
```objc
fixMethod(NSString *className, NSString *selectorName, BOOL isClassMethod, AspectOptions option, JSValue *fixImpl)
```
JS例子
```js
fixMethod('className', 'selectorName', false, 1, function(instance, originInvocation, originArguments) {
...
})
```

## 调用类方法（只支持3个参数的方法）
* className 类名
* selectorName 选择器名
* args 参数数组
```objc
id callClassMethod(NSString *className, NSString *selectorName, NSArray *args)
```
JS例子
```js
var result = callClassMethod('className', 'selectorName', [arg1, arg2, arg3])
```

##  调用实例方法（只支持3个参数的方法）
* className 类名
* selectorName 选择器名
* args 参数数组
```objc
id callInstanceMethod(id instance, NSString *selectorName, NSArray *args)
```
JS例子
```js
var result = callInstanceMethod(instance, 'selectorName', [arg1, arg2, arg3])
```

## 实例
```objc
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
```

```objc
NSString *js = @"
fixMethod('MySubObject', 'fixMethod', false, 1, function(instance,                                               originInvocation, originArguments) {
    console.log('bbbb'); 
    callInvocation(originInvocation); 
    var result = callInstanceMethod(instance, 'isBoolWithCount:', [20]); console.log(result); 
    var count = callInstanceMethod(instance, 'count');  console.log(count); 
    var obj = callInstanceMethod(instance, 'obj'); 
    console.log(obj); 
    callInstanceMethod(obj, 'setCount:', [888]); 
    count = callInstanceMethod(obj, 'count'); 
    console.log(count); 
    var url = callClassMethod('NSURL', 'URLWithString:', ['http://www.baidu.com']); 
    console.log(url); 
    var scheme = callInstanceMethod(url, 'scheme'); console.log(scheme); 
    var height = callClassMethod('MySubObject', 'getHeight'); console.log(height); 
    var str = callInstanceMethod(instance, 'twoArgMethod:arg2:', [87, 13.45]); 
    console.log(str); 
    str = callInstanceMethod(instance, 'threeArgMethod:arg2:arg3:', [99, 15.5, 88.23]); 
    console.log(str); 
})
";
evalString(js);
MySubObject *obj = [[MySubObject alloc] init];
[obj fixMethod];
```





