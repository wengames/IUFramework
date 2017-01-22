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
#import <IUNetworking/IUNetworking.h>
#import <IUController/IUController.h>
#import <IUUtil/IUUtil.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    /* IUChain */
    UITextField *t1, *t2;
    UISearchBar *s;
    [self.view addSubview:[[UISearchBar alloc] init].setText(@"searchBar").bind(&s).setFrame(CGRectMake(100, 100, 200, 100))];
    [self.view addSubview:[[UITextField alloc] init].setTextInputRestrict([IUTextInputRestrictPhone textInputRestrictWithSeparator:@"-"]).setBackgroundColor([UIColor cyanColor]).setText(@"13774322959").bind(&t1)];
    [self.view addSubview:[[UITextField alloc] init].setTextInputRestrict([IUTextInputRestrictIdentityCard textInputRestrict]).setBackgroundColor([UIColor lightGrayColor]).setText(@"1234567890").bind(&t2).setFrame(CGRectMake(100, 300, 200, 100))];

    // adds constraints here or other codes
    t1.setTextAlignment(NSTextAlignmentCenter).frame = CGRectMake(100, 200, 200, 100);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"%@", t1.phone);
    });
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
