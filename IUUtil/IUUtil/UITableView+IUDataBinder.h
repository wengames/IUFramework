//
//  UITableView+IUDataBinder.h
//  IUUtil
//
//  Created by admin on 2017/1/24.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IUTableViewCellClassDeclaration <NSObject>

// or implement -[valueForKey:@"cellClassName"]
// if NOT implement, it will find cell class name by transform self class name
// (append "TableViewCell", "TableCell", "Cell" and remove "Model" at last)
@optional
- (NSString *)cellClassName; // class which conforms Protocol IUTableViewCellModelSettable

@end

@interface UITableView (IUDataBinder)

@property (nonatomic, strong) NSArray <id<IUTableViewCellClassDeclaration>> *datas; // datas in sections, call method below with animated YES

- (void)setDatas:(NSArray *)datas animated:(BOOL)animated;

@end

@protocol IUTableViewCellModelSettable <NSObject>

@optional
@property (nonatomic, strong) id model;

@end
