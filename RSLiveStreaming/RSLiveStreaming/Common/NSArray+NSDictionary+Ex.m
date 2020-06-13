//
//  NSArray+NSDictionary+Ex.m
//  网络请求功能
//
//  Created by Ron_Samkulami on 2020/5/25.
//  Copyright © 2020 Ron_Samkulami. All rights reserved.
//

#import "NSArray+NSDictionary+Ex.h"
#import <objc/runtime.h>

@implementation NSArray (Ex)
- (NSString *)descriptionWithLocale:(id)locale {
    NSMutableString *tmpStr = [NSMutableString string];
    [tmpStr appendString:@"(\r\n"];
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tmpStr appendFormat:@"\t%@,\r\n",obj];
    }];
    [tmpStr appendString:@")"];
    return tmpStr.copy;
}

// Swizzling交换方法
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method fromMethod = class_getInstanceMethod(self, @selector(objectAtIndex:));
        Method toMethod = class_getInstanceMethod(self, @selector(cm_objectAtIndex:));
        //如果已经实现该方法，则返回NO
        BOOL addResult = class_addMethod(self.class, @selector(objectAtIndex:), method_getImplementation(toMethod), method_getTypeEncoding(toMethod));
        if (addResult) {
            //如果添加成功，则此时objectAtIndex：已经指向了新的方法实现，要让cm_objectAtIndex:指向旧的方法实现
            class_replaceMethod(self.class, @selector(cm_objectAtIndex:), method_getImplementation(fromMethod), method_getTypeEncoding(fromMethod));
        }else{
            method_exchangeImplementations(fromMethod, toMethod);
        }
    });
    
}

- (id)cm_objectAtIndex:(NSUInteger)index {
    // 判断下标是否越界，如果越界就进入异常拦截
    if (index > self.count - 1) {
        @try {
            NSLog(@"越界，tryCatch");
            return [self cm_objectAtIndex:index];
        }
        @catch (NSException *exception) {
            // 在崩溃后会打印崩溃信息
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
            return nil;
        }
        @finally {}
    } // 如果没有问题，则正常进行方法调用
    else {
        NSLog(@"未越界，调用原生方法");
        return [self cm_objectAtIndex:index];
    }
}
@end

@implementation NSDictionary (Ex)

- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level
{
    NSMutableString *mStr = [NSMutableString string];
    NSMutableString *tab = [NSMutableString stringWithString:@""];
    for (int i = 0; i < level; i++) {
        [tab appendString:@"\t"];
    }
    [mStr appendString:@"{\n"];
    NSArray *allKey = self.allKeys;
    for (int i = 0; i < allKey.count; i++) {
        id value = self[allKey[i]];
        NSString *lastSymbol = (allKey.count == i + 1) ? @"":@";";
        if ([value respondsToSelector:@selector(descriptionWithLocale:indent:)]) {
            [mStr appendFormat:@"\t%@%@ = %@%@\n",tab,allKey[i],[value descriptionWithLocale:locale indent:level + 1],lastSymbol];
        } else {
            [mStr appendFormat:@"\t%@%@ = %@%@\n",tab,allKey[i],value,lastSymbol];
        }
    }
    [mStr appendFormat:@"%@}",tab];
    return mStr;
}

@end
