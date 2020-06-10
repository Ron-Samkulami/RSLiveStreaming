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
    Method fromMethod = class_getInstanceMethod(objc_getClass("__NSArray0"), @selector(objectAtIndex:));
    Method toMethod = class_getInstanceMethod(objc_getClass("__NSArray0"), @selector(cm_objectAtIndex:));
    method_exchangeImplementations(fromMethod, toMethod);
}

- (id)cm_objectAtIndex:(NSUInteger)index {
    // 判断下标是否越界，如果越界就进入异常拦截
    if (self.count-1 < index) {
        @try {
            return [self cm_objectAtIndex:index];
        }
        @catch (NSException *exception) {
            // 在崩溃后会打印崩溃信息。如果是线上，可以在这里将崩溃信息发送到服务器
            NSLog(@"---------- %s Crash Because Method %s  ----------\n", class_getName(self.class), __func__);
            NSLog(@"%@", [exception callStackSymbols]);
            return nil;
        }
        @finally {}
    } // 如果没有问题，则正常进行方法调用
    else {
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
