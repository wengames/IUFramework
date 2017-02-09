//
//  NSObject+IUMethodSwizzle.h
//  IUMethodSwizzle
//
//  Created by admin on 2017/2/9.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (IUMethodSwizzle)

+ (void)swizzleInstanceSelector:(SEL)fromSelector toSelector:(SEL)toSelector;
+ (void)swizzleClassSelector:(SEL)fromSelector toSelector:(SEL)toSelector;

@end
