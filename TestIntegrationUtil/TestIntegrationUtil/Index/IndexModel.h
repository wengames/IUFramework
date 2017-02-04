//
//  IndexModel.h
//  TestIntegrationUtil
//
//  Created by admin on 2017/2/4.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IndexModel : NSObject

@property (nonatomic, strong) NSString *title;

+ (instancetype)modelWithTitle:(NSString *)title;

@end
