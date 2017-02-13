//
//  NSObject+IUChain.m
//  IUChain
//
//  Created by admin on 2017/1/19.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "NSObject+IUChain.h"
#import <UIKit/UIKit.h>
#import <objc/message.h>
#import "NSObject+IUMethodSwizzle.h"

#define IU_MESSAGE_SEND(type) ^(type obj) { [self setValue:@(obj) forKey:key]; return self; };

@implementation NSObject (IUChain)

id iuChainDynamicMethodIMP(id self, SEL _cmd) {
    NSString *selString = NSStringFromSelector(_cmd);
    if ([selString length] > 3) {
        NSString *key = [[selString substringWithRange:NSMakeRange(3, 1)] lowercaseString];
        key = [selString stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:key];
        selString = [selString stringByAppendingString:@":"];
        if ([self respondsToSelector:NSSelectorFromString(selString)]) {
            
            NSString *argumentType = [NSString stringWithCString:[[self methodSignatureForSelector:NSSelectorFromString(selString)] getArgumentTypeAtIndex:2] encoding:NSUTF8StringEncoding];
            
            if ([@"{CGRect={CGPoint=dd}{CGSize=dd}}" isEqualToString:argumentType]) {
                return ^(CGRect obj) {
                    [self setValue:[NSValue valueWithCGRect:obj] forKey:key];
                    return self;
                };
            } else if ([@"{CGPoint=dd}" isEqualToString:argumentType]) {
                return ^(CGPoint obj) {
                    [self setValue:[NSValue valueWithCGPoint:obj] forKey:key];
                    return self;
                };
            } else if ([@"{CGSize=dd}" isEqualToString:argumentType]) {
                return ^(CGSize obj) {
                    [self setValue:[NSValue valueWithCGSize:obj] forKey:key];
                    return self;
                };
            } else if ([@"{UIEdgeInsets=dddd}" isEqualToString:argumentType]) {
                return ^(UIEdgeInsets obj) {
                    [self setValue:[NSValue valueWithUIEdgeInsets:obj] forKey:key];
                    return self;
                };
            } else if ([@"{UIOffset=dd}" isEqualToString:argumentType]) {
                return ^(UIOffset obj) {
                    [self setValue:[NSValue valueWithUIOffset:obj] forKey:key];
                    return self;
                };
            } else if ([@"{CGVector=dd}" isEqualToString:argumentType]) {
                return ^(CGVector obj) {
                    [self setValue:[NSValue valueWithCGVector:obj] forKey:key];
                    return self;
                };
            } else if ([@"{CGAffineTransform=dddddd}" isEqualToString:argumentType]) {
                return ^(CGAffineTransform obj) {
                    [self setValue:[NSValue valueWithCGAffineTransform:obj] forKey:key];
                    return self;
                };
            } else if ([@"{CATransform3D=dddddddddddddddd}" isEqualToString:argumentType]) {
                return ^(CATransform3D obj) {
                    [self setValue:[NSValue valueWithCATransform3D:obj] forKey:key];
                    return self;
                };
            } else if ([@"{NSRange=dd}" isEqualToString:argumentType]) {
                return ^(NSRange obj) {
                    [self setValue:[NSValue valueWithRange:obj] forKey:key];
                    return self;
                };
            } else if ([@"q" isEqualToString:[argumentType lowercaseString]]) { // q NSInteger, long, long long
                return IU_MESSAGE_SEND(NSInteger);
            } else if ([@"i" isEqualToString:[argumentType lowercaseString]]) { // i int
                return IU_MESSAGE_SEND(int);
            } else if ([@"s" isEqualToString:[argumentType lowercaseString]]) { // s short
                return IU_MESSAGE_SEND(short);
            } else if ([@"d" isEqualToString:[argumentType lowercaseString]]) { // d CGFloat, double
                return IU_MESSAGE_SEND(double);
            } else if ([@"f" isEqualToString:[argumentType lowercaseString]]) { // f float
                return IU_MESSAGE_SEND(float);
            } else if ([@"b" isEqualToString:[argumentType lowercaseString]]) { // b BOOL
                return IU_MESSAGE_SEND(BOOL);
            } else if ([@"*" isEqualToString:argumentType]) { // * char
                return IU_MESSAGE_SEND(char);
            } else if ([@":" isEqualToString:argumentType]) { // : SEL
                return ^(SEL obj) {
                    objc_msgSend(self, NSSelectorFromString(selString), obj);
                    return self;
                };
            } else if ([@"@" isEqualToString:argumentType]) { // @ id
                return ^(id obj) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [self performSelector:NSSelectorFromString(selString) withObject:obj];
#pragma clang diagnostic pop
                    return self;
                };
            }
        }
    }
    return ^{ return self; };
}

+ (void)load {
    [self swizzleClassSelector:@selector(resolveInstanceMethod:) toSelector:@selector(iuChain_NSObject_resolveInstanceMethod:)];
}

+ (BOOL)iuChain_NSObject_resolveInstanceMethod:(SEL)sel {
    BOOL resolved = [self iuChain_NSObject_resolveInstanceMethod:sel];
    if (!resolved) {
        NSString *selString = NSStringFromSelector(sel);
        // "set"开头 && 非":"结尾 && 第4个字符为大写
        if ([selString hasPrefix:@"set"] &&
            ![selString hasSuffix:@":"] &&
            [selString length] > 3 && [[[selString substringWithRange:NSMakeRange(3, 1)] uppercaseString] isEqualToString:[selString substringWithRange:NSMakeRange(3, 1)]]) {
            class_addMethod([self class],sel,(IMP)iuChainDynamicMethodIMP,"@@:");
            resolved = YES;
        }
    }
    return resolved;
}

- (NSObject *(^)(__strong id *))bind {
    return ^(__strong id *obj) {
        *obj = self;
        return self;
    };
}

- (NSObject *)configure:(void (^)(NSObject *))configure {
    configure(self);
    return self;
}

@end
