//
//  IUFilterParameterEffectPreviewViewController.h
//  IUImageTransform
//
//  Created by admin on 2017/2/9.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IUFilterParameterEffectPreviewViewController : UIViewController

@property (nonatomic, strong)           UIImage *originImage;
@property (nonatomic, strong, readonly) UIImage *filteredImage;

+ (instancetype)preview;

@end
