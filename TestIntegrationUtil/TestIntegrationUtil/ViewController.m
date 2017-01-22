//
//  ViewController.m
//  TestIntegrationUtil
//
//  Created by admin on 2017/1/19.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "ViewController.h"
#import <IUChain/IUChain.h>
#import <IUTextInput/IUTextInput.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    /* IUChain */
    UIView *v;
    UILabel *l;
    UITextField *t;
    UISearchBar *s;
    [self.view addSubview:[[UILabel alloc] init].setBackgroundColor([UIColor cyanColor]).setText(@"xxx").bind(&l)];
    [self.view addSubview:[[UITextField alloc] init].setTextInputRestrict([IUTextInputRestrictNumberWithFormat textInputRestrictWithFormat:@"0000 "]).setBackgroundColor([UIColor lightGrayColor]).setText(@"xxx").bind(&t).setFrame(CGRectMake(100, 300, 200, 100))];
    [self.view addSubview:[[UISearchBar alloc] init].setText(@"searchBar").bind(&s).setFrame(CGRectMake(100, 100, 200, 100))];

    // adds constraints here or other codes
    l.setTextAlignment(NSTextAlignmentCenter).frame = CGRectMake(100, 200, 200, 100);
}

@end
