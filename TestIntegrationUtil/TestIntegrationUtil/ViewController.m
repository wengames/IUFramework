//
//  ViewController.m
//  TestIntegrationUtil
//
//  Created by admin on 2017/1/19.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "ViewController.h"
#import <IUChain/IUChain.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:[[UIView alloc] init].setFrame(CGRectMake(100, 100, 100, 100)).setBackgroundColor([UIColor redColor])];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
