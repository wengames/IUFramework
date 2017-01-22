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
    
    // IUChain
    UIView *v;
    UILabel *l;
    [self.view addSubview:[[UIView alloc] init].setFrame(CGRectMake(100, 100, 100, 100)).setContentMode(UIViewContentModeScaleToFill).setBackgroundColor([UIColor redColor]).bind(&v)];
    [self.view addSubview:[[UILabel alloc] init].setBackgroundColor([UIColor cyanColor]).setText(@"xxx").bind(&l)];
    NSLog(@"%@", v);
    l.setTextAlignment(NSTextAlignmentCenter).frame = CGRectMake(100, 200, 100, 100);
}

@end
