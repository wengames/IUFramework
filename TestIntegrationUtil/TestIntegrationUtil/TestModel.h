//
//  TestModel.h
//  TestIntegrationUtil
//
//  Created by admin on 2017/2/4.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TestModel : NSObject

@property (nonatomic, strong) NSString *number;

+ (instancetype)modelWithNumber:(NSString *)number;

@end
