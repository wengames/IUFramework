//
//  ViewController.m
//  TestIntegrationUtil
//
//  Created by admin on 2017/1/19.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "ViewController.h"
#import "PortraitViewController.h"

@interface ViewController ()
{
    UIWindow *w;
    UIWindow *w2;
}
@end

@implementation ViewController

- (void)willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
    NSLog(@"parent:%@", parent);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"title";
    self.view.backgroundColor = [UIColor blackColor];
    
    /* IUChain */
    UITextField *t1, *t2;
    UISearchBar *s;
    [self.scrollView addSubview:[[UISearchBar alloc] init].setText(@"searchBar").bind(&s).setFrame(CGRectMake(100, 100, 200, 100))];
    [self.scrollView addSubview:[[UITextField alloc] init].setTextInputRestrict([IUTextInputRestrictPhone textInputRestrictWithSeparator:@"-"]).setBackgroundColor([UIColor cyanColor]).setText(@"13774322959").bind(&t1)];
    [self.scrollView addSubview:[[UITextField alloc] init].setTextInputRestrict([IUTextInputRestrictIdentityCard textInputRestrict]).setBackgroundColor([UIColor lightGrayColor]).setText(@"1234567890").bind(&t2).setFrame(CGRectMake(100, 300, 200, 100))];

    // adds constraints here or other codes
    t1.setTextAlignment(NSTextAlignmentCenter).frame = CGRectMake(100, 200, 200, 100);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view.window addSubview:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 20)].setBackgroundColor([UIColor blackColor])];
    });
    
//    NSLog(@"%@", [[UIApplication sharedApplication] keyWindow]);
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"%@", t1.phone);
//        w = [[UIWindow alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//        w.windowLevel = UIWindowLevelAlert;
//        w.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
//        w.clipsToBounds = YES;
//        w.rootViewController = [[ViewController alloc] init];
//        [w makeKeyAndVisible];
//        
//        NSLog(@"%@", [[UIApplication sharedApplication] keyWindow]);
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            w2 = [[UIWindow alloc] initWithFrame:CGRectMake(100, 300, 100, 100)];
//            w2.windowLevel = UIWindowLevelStatusBar;
//            w2.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
////            [w2 makeKeyAndVisible];
//            
//            NSLog(@"%@", [[UIApplication sharedApplication] keyWindow]);
//
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                w = nil;
//                NSLog(@"%@", [[UIApplication sharedApplication] keyWindow]);
//                
//                ;
//                [self presentViewController:[UIAlertController alertControllerWithTitle:@"t" message:@"m" preferredStyle:UIAlertControllerStyleAlert] animated:YES completion:^{
//                    NSLog(@"%@", [[UIApplication sharedApplication] keyWindow]);
//                }];
//                
////                [[[UIAlertView alloc] initWithTitle:@"t" message:@"m" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:nil] show];
////                
////                NSLog(@"%@", [[UIApplication sharedApplication] keyWindow]);
//
//            });
//
//        });
    
//    });
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self.view endEditing:YES];
//    [self presentViewController:[[PortraitViewController alloc] init] animated:YES completion:nil];
//}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}


@end
