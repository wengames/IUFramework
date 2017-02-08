//
//  NonNaviPushedViewController.m
//  TestIntegrationUtil
//
//  Created by admin on 2017/2/4.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "NonNaviPushedViewController.h"

@interface NonNaviPushedViewController ()

@end

@implementation NonNaviPushedViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.navigationItem.title = @"Non Navi Pushed";
        self.navigationBarHidden = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self.view addSubview:[[UILabel alloc] initWithFrame:self.view.bounds].setTextColor([UIColor whiteColor]).setText(@"Pan Anywhere To Back ➡️").setAutoresizingMask(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight).setTextAlignment(NSTextAlignmentCenter)];
}

@end
