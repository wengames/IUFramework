//
//  NSNull+IURedirect.m
//  IUNetworking
//
//  Created by admin on 2017/2/6.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "NSNull+IURedirect.h"

@implementation NSNull (IURedirect)

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([NSString instancesRespondToSelector:aSelector]) {
        return @"";
    } else if ([NSNumber instancesRespondToSelector:aSelector]) {
        return @0;
    } else if ([NSArray instancesRespondToSelector:aSelector]) {
        return @[];
    } else if ([NSDictionary instancesRespondToSelector:aSelector]) {
        return @{};
    } else if ([NSSet instancesRespondToSelector:aSelector]) {
        return [NSSet set];
    } else if ([NSData instancesRespondToSelector:aSelector]) {
        return [NSData data];
    } else if ([NSDate instancesRespondToSelector:aSelector]) {
        return [NSDate date];
    }
    return self;
}

@end
