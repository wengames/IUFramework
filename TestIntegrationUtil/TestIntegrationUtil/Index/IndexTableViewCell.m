//
//  IndexTableViewCell.m
//  TestIntegrationUtil
//
//  Created by admin on 2017/2/4.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "IndexTableViewCell.h"

@implementation IndexTableViewCell

- (void)setModel:(IndexModel *)model {
    _model = model;
    self.textLabel.text = model.title;
}

@end
