//
//  TestModel.m
//  TestIntegrationUtil
//
//  Created by admin on 2017/2/4.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "TestModel.h"

@implementation TestModel

+ (instancetype)modelWithNumber:(NSString *)number {
    TestModel *model = [[self alloc] init];
    model.number = number;
    return model;
}

@end
