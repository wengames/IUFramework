//
//  IndexModel.m
//  TestIntegrationUtil
//
//  Created by admin on 2017/2/4.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "IndexModel.h"

@implementation IndexModel

+ (instancetype)modelWithTitle:(NSString *)title {
    IndexModel *model = [[self alloc] init];
    model.title = title;
    return model;
}

@end
