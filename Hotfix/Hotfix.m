//
//  Hotfix.m
//  Hotfix
//
//  Created by TCLios2 on 2018/4/10.
//  Copyright © 2018年 TCLios2. All rights reserved.
//

#import "Hotfix.h"
#import "YYModel.h"
#import "Aspects.h"
#import <JavaScriptCore/JavaScriptCore.h>

static bool _YYEncodingTypeIsDouble(YYEncodingType type) {
    return type == YYEncodingTypeFloat || type == YYEncodingTypeDouble || type == YYEncodingTypeLongDouble;
}

static id _sendMsg(YYClassMethodInfo *info, id obj, NSArray *args) {
    int count = (int)info.argumentTypeEncodings.count;
    YYEncodingType types[count-2];
    for (int i=2; i<count; i++) {
        NSString *arg = info.argumentTypeEncodings[i];
        YYEncodingType type = YYEncodingGetType(arg.UTF8String);
        types[i-2] = type;
    }
    count = count - 2;
    void **outArgs[count];
    for (int i=0; i<count; i++) {
        YYEncodingType type = types[i];
        if (type == YYEncodingTypeBool) {
            BOOL value = [args[i] boolValue];
            outArgs[i] = (void *)(BOOL *)&value;
        } else if (type == YYEncodingTypeInt8) {
            int8_t value = [args[i] charValue];
            outArgs[i] = (void *)(int8_t *)&value;
        } else if (type == YYEncodingTypeUInt8) {
            uint8_t value = [args[i] unsignedCharValue];
            outArgs[i] = (void *)(uint8_t *)&value;
        } else if (type == YYEncodingTypeInt16) {
            int16_t value = [args[i] shortValue];
            outArgs[i] = (void *)(int16_t *)&value;
        } else if (type == YYEncodingTypeUInt16) {
            uint16_t value = [args[i] unsignedShortValue];
            outArgs[i] = (void *)(uint16_t *)&value;
        } else if (type == YYEncodingTypeInt32) {
            int32_t value = [args[i] intValue];
            outArgs[i] = (void *)(int32_t *)&value;
        } else if (type == YYEncodingTypeUInt32) {
            uint32_t value = [args[i] unsignedIntValue];
            outArgs[i] = (void *)(uint32_t *)&value;
        } else if (type == YYEncodingTypeInt64) {
            int64_t value = [args[i] longLongValue];
            outArgs[i] = (void *)(int64_t *)&value;
        } else if (type == YYEncodingTypeUInt64) {
            uint64_t value = [args[i] unsignedLongLongValue];
            outArgs[i] = (void *)(uint64_t *)&value;
        } else if (type == YYEncodingTypeObject || type == YYEncodingTypeBlock || type == YYEncodingTypePointer || type == YYEncodingTypeCString || type == YYEncodingTypeCArray) {
            void *value = (__bridge void *)args[i];
            outArgs[i] = (void *)&value;
        } else if (type == YYEncodingTypeClass) {
            Class value;
            [args[i] getValue:&value];
            outArgs[i] = (void *)&value;
        } else if (type == YYEncodingTypeSEL) {
            SEL value;
            [args[i] getValue:&value];
            outArgs[i] = (void *)&value;
        }
    }
    
    YYEncodingType type = YYEncodingGetType(info.returnTypeEncoding.UTF8String);
    void *result = nil;
    if (count == 0) {
        if (type == YYEncodingTypeFloat) {
            return @(((float (*)(id, SEL))(void *)info.imp)(obj, info.sel));
        } else if (type == YYEncodingTypeDouble || type == YYEncodingTypeLongDouble) {
            return @(((double (*)(id, SEL))(void *)info.imp)(obj, info.sel));
        }  else {
            result = ((void * (*)(id, SEL))(void *)info.imp)(obj, info.sel);
        }
    } else if (count == 1) {
        if (_YYEncodingTypeIsDouble(type)) {
            if (_YYEncodingTypeIsDouble(types[0])) {
                return @(((double (*)(id, SEL, double))(void *)info.imp)(obj, info.sel, [args[0] doubleValue]));
            } else {
                return @(((double (*)(id, SEL, void *))(void *)info.imp)(obj, info.sel, *outArgs[0]));
            }
        }  else {
            if (_YYEncodingTypeIsDouble(types[0])) {
                result = ((void * (*)(id, SEL, double))(void *)info.imp)(obj, info.sel, [args[0] doubleValue]);
            } else {
                result = ((void * (*)(id, SEL, void *))(void *)info.imp)(obj, info.sel, *outArgs[0]);
            }
        }
    } else if (count == 2) {
        if (_YYEncodingTypeIsDouble(type)) {
            if (_YYEncodingTypeIsDouble(types[0]) && !_YYEncodingTypeIsDouble(types[1])) {
                return @(((double (*)(id, SEL, double, void *))(void *)info.imp)(obj, info.sel, [args[0] doubleValue], *outArgs[1]));
            } else if (!_YYEncodingTypeIsDouble(types[0]) && _YYEncodingTypeIsDouble(types[1])) {
                return @(((double (*)(id, SEL, void *, double))(void *)info.imp)(obj, info.sel, *outArgs[0], [args[1] doubleValue]));
            } else if (_YYEncodingTypeIsDouble(types[0]) && _YYEncodingTypeIsDouble(types[1])) {
                return @(((double (*)(id, SEL, double, double))(void *)info.imp)(obj, info.sel, [args[0] doubleValue], [args[1] doubleValue]));
            } else {
                return @(((double (*)(id, SEL, void *, void *))(void *)info.imp)(obj, info.sel, *outArgs[0], *outArgs[1]));
            }
        } else {
            if (_YYEncodingTypeIsDouble(types[0]) && !_YYEncodingTypeIsDouble(types[1])) {
                result = ((void * (*)(id, SEL, double, void *))(void *)info.imp)(obj, info.sel, [args[0] doubleValue], *outArgs[1]);
            } else if (!_YYEncodingTypeIsDouble(types[0]) && _YYEncodingTypeIsDouble(types[1])) {
                result = ((void * (*)(id, SEL, void *, double))(void *)info.imp)(obj, info.sel, *outArgs[0], [args[1] doubleValue]);
            } else if (_YYEncodingTypeIsDouble(types[0]) && _YYEncodingTypeIsDouble(types[1])) {
                result = ((void * (*)(id, SEL, double, double))(void *)info.imp)(obj, info.sel, [args[0] doubleValue], [args[1] doubleValue]);
            } else {
                result = ((void * (*)(id, SEL, void *, void *))(void *)info.imp)(obj, info.sel, *outArgs[0], *outArgs[1]);
            }
        }
    } else if (count == 3) {
        if (_YYEncodingTypeIsDouble(type)) {
            if (_YYEncodingTypeIsDouble(types[0]) && !_YYEncodingTypeIsDouble(types[1]) && !_YYEncodingTypeIsDouble(types[2])) {
                return @(((double (*)(id, SEL, double, void *, void *))(void *)info.imp)(obj, info.sel, [args[0] doubleValue], *outArgs[1], *outArgs[2]));
            } else if (!_YYEncodingTypeIsDouble(types[0]) && _YYEncodingTypeIsDouble(types[1]) && !_YYEncodingTypeIsDouble(types[2])) {
                return @(((double (*)(id, SEL, void *, double, void *))(void *)info.imp)(obj, info.sel, *outArgs[0], [args[1] doubleValue], *outArgs[2]));
            } else if (!_YYEncodingTypeIsDouble(types[0]) && !_YYEncodingTypeIsDouble(types[1]) && _YYEncodingTypeIsDouble(types[2])) {
                return @(((double (*)(id, SEL, void *, void *, double))(void *)info.imp)(obj, info.sel, *outArgs[0], *outArgs[1], [args[2] doubleValue]));
            } else if (!_YYEncodingTypeIsDouble(types[0]) && _YYEncodingTypeIsDouble(types[1]) && _YYEncodingTypeIsDouble(types[2])) {
                return @(((double (*)(id, SEL, void *, double, double))(void *)info.imp)(obj, info.sel, *outArgs[0], [args[1] doubleValue], [args[2] doubleValue]));
            } else if (_YYEncodingTypeIsDouble(types[0]) && !_YYEncodingTypeIsDouble(types[1]) && _YYEncodingTypeIsDouble(types[2])) {
                return @(((double (*)(id, SEL, double, void *, double))(void *)info.imp)(obj, info.sel, [args[0] doubleValue], *outArgs[1], [args[2] doubleValue]));
            } else if (_YYEncodingTypeIsDouble(types[0]) && _YYEncodingTypeIsDouble(types[1]) && !_YYEncodingTypeIsDouble(types[2])) {
                return @(((double (*)(id, SEL, double, double, void *))(void *)info.imp)(obj, info.sel, [args[0] doubleValue], [args[1] doubleValue], *outArgs[2]));
            } else if (_YYEncodingTypeIsDouble(types[0]) && _YYEncodingTypeIsDouble(types[1]) && _YYEncodingTypeIsDouble(types[2])) {
                return @(((double (*)(id, SEL, double, double, double))(void *)info.imp)(obj, info.sel, [args[0] doubleValue], [args[1] doubleValue], [args[2] doubleValue]));
            } else if (!_YYEncodingTypeIsDouble(types[0]) && !_YYEncodingTypeIsDouble(types[1]) && !_YYEncodingTypeIsDouble(types[2])) {
                return @(((double (*)(id, SEL, void *, void *, void *))(void *)info.imp)(obj, info.sel, *outArgs[0], *outArgs[1], *outArgs[2]));
            }
        } else {
            if (_YYEncodingTypeIsDouble(types[0]) && !_YYEncodingTypeIsDouble(types[1]) && !_YYEncodingTypeIsDouble(types[2])) {
                result = ((void * (*)(id, SEL, double, void *, void *))(void *)info.imp)(obj, info.sel, [args[0] doubleValue], *outArgs[1], *outArgs[2]);
            } else if (!_YYEncodingTypeIsDouble(types[0]) && _YYEncodingTypeIsDouble(types[1]) && !_YYEncodingTypeIsDouble(types[2])) {
                result = ((void * (*)(id, SEL, void *, double, void *))(void *)info.imp)(obj, info.sel, *outArgs[0], [args[1] doubleValue], *outArgs[2]);
            } else if (!_YYEncodingTypeIsDouble(types[0]) && !_YYEncodingTypeIsDouble(types[1]) && _YYEncodingTypeIsDouble(types[2])) {
                result = ((void * (*)(id, SEL, void *, void *, double))(void *)info.imp)(obj, info.sel, *outArgs[0], *outArgs[1], [args[2] doubleValue]);
            } else if (!_YYEncodingTypeIsDouble(types[0]) && _YYEncodingTypeIsDouble(types[1]) && _YYEncodingTypeIsDouble(types[2])) {
                result = ((void * (*)(id, SEL, void *, double, double))(void *)info.imp)(obj, info.sel, *outArgs[0], [args[1] doubleValue], [args[2] doubleValue]);
            } else if (_YYEncodingTypeIsDouble(types[0]) && !_YYEncodingTypeIsDouble(types[1]) && _YYEncodingTypeIsDouble(types[2])) {
                result = ((void * (*)(id, SEL, double, void *, double))(void *)info.imp)(obj, info.sel, [args[0] doubleValue], *outArgs[1], [args[2] doubleValue]);
            } else if (_YYEncodingTypeIsDouble(types[0]) && _YYEncodingTypeIsDouble(types[1]) && !_YYEncodingTypeIsDouble(types[2])) {
                result = ((void * (*)(id, SEL, double, double, void *))(void *)info.imp)(obj, info.sel, [args[0] doubleValue], [args[1] doubleValue], *outArgs[2]);
            } else if (_YYEncodingTypeIsDouble(types[0]) && _YYEncodingTypeIsDouble(types[1]) && _YYEncodingTypeIsDouble(types[2])) {
                result = ((void * (*)(id, SEL, double, double, double))(void *)info.imp)(obj, info.sel, [args[0] doubleValue], [args[1] doubleValue], [args[2] doubleValue]);
            } else if (!_YYEncodingTypeIsDouble(types[0]) && !_YYEncodingTypeIsDouble(types[1]) && !_YYEncodingTypeIsDouble(types[2])) {
                result = ((void * (*)(id, SEL, void *, void *, void *))(void *)info.imp)(obj, info.sel, *outArgs[0], *outArgs[1], *outArgs[2]);
            }
        }
    }
    if (type == YYEncodingTypeObject || type == YYEncodingTypeBlock || type == YYEncodingTypePointer || type == YYEncodingTypeCString || type == YYEncodingTypeCArray) {
        return (__bridge id)result;
    } else if (type != YYEncodingTypeVoid) {
        if (type == YYEncodingTypeBool) {
            return @((BOOL)result);
        } else if (type == YYEncodingTypeInt8) {
            return @((int8_t)result);
        } else if (type == YYEncodingTypeUInt8) {
            return @((uint8_t)result);
        } else if (type == YYEncodingTypeInt16) {
            return @((int16_t)result);
        } else if (type == YYEncodingTypeUInt16) {
            return @((uint16_t)result);
        } else if (type == YYEncodingTypeInt32) {
            return @((int32_t)result);
        } else if (type == YYEncodingTypeUInt32) {
            return @((uint32_t)result);
        } else if (type == YYEncodingTypeInt64) {
            return @((int64_t)result);
        } else if (type == YYEncodingTypeUInt64) {
            return @((uint64_t)result);
        } else {
            return [NSValue value:&result withObjCType:info.returnTypeEncoding.UTF8String];
        }
    } else {
        return nil;
    }
}

void evalString(NSString *js) {
    static JSContext *_context;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _context = [[JSContext alloc] init];
        [_context setExceptionHandler:^(JSContext *context, JSValue *value) {
            NSLog(@"Oops: %@", value);
        }];
        _context[@"fixMethod"] = ^(NSString *className, NSString *selectorName, BOOL isClassMethod, AspectOptions option, JSValue *fixImpl) {
            Class klass = NSClassFromString(className);
            if (isClassMethod) {
                klass = object_getClass(klass);
            }
            SEL sel = NSSelectorFromString(selectorName);
            [klass aspect_hookSelector:sel withOptions:option usingBlock:^(id<AspectInfo> aspectInfo){
                [fixImpl callWithArguments:@[aspectInfo.instance, aspectInfo.originalInvocation, aspectInfo.arguments]];
            } error:nil];
        };
        
        _context[@"callClassMethod"] = ^id(NSString *className, NSString *selectorName, NSArray *args) {
            Class klass = NSClassFromString(className);
            Class metaCls = object_getClass(klass);
            YYClassInfo *classInfo = [YYClassInfo classInfoWithClass:metaCls];
            YYClassMethodInfo *methodInfo = classInfo.methodInfos[selectorName];
            while (!methodInfo && classInfo.superCls) {
                classInfo = [YYClassInfo classInfoWithClass:classInfo.superCls];
                methodInfo = classInfo.methodInfos[selectorName];
            }
            if (methodInfo) {
                return _sendMsg(methodInfo, klass, args);
            }
            return nil;
        };
        
        _context[@"callInstanceMethod"] = ^id(id instance, NSString *selectorName, NSArray *args) {
            YYClassInfo *classInfo = [YYClassInfo classInfoWithClass:[instance class]];
            YYClassMethodInfo *methodInfo = classInfo.methodInfos[selectorName];
            while (!methodInfo && classInfo.superCls) {
                classInfo = [YYClassInfo classInfoWithClass:classInfo.superCls];
                methodInfo = classInfo.methodInfos[selectorName];
            }
            if (methodInfo) {
                return _sendMsg(methodInfo, instance, args);
            }
            return nil;
        };
        
        _context[@"callInvocation"] = ^(NSInvocation *invocation) {
            [invocation invoke];
        };
        
        // helper
        [_context evaluateScript:@"var console = {}"];
        
        _context[@"console"][@"log"] = ^(id message) {
            NSLog(@"Javascript log: %@",message);
        };
    });
    [_context evaluateScript:js];
}
