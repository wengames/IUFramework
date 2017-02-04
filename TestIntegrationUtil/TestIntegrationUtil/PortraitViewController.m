//
//  PortraitViewController.m
//  TestIntegrationUtil
//
//  Created by admin on 2017/1/24.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "PortraitViewController.h"
#import "TestModel.h"

@interface PortraitViewController () <UITableViewDelegate>

@end

@implementation PortraitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.tableView.datas = @[
                             [TestModel modelWithNumber:@"1"],
                             [TestModel modelWithNumber:@"2"],
                             [TestModel modelWithNumber:@"3"],
                             [TestModel modelWithNumber:@"4"],
                             [TestModel modelWithNumber:@"5"],
                             [TestModel modelWithNumber:@"6"],
                             [TestModel modelWithNumber:@"7"]
                             ];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.tableView.datas = @[
                                 [TestModel modelWithNumber:@"11"],
                                 [TestModel modelWithNumber:@"22"],
                                 [TestModel modelWithNumber:@"33"],
                                 [TestModel modelWithNumber:@"44"],
                                 [TestModel modelWithNumber:@"55"]
                                 ];
    });
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

@end
