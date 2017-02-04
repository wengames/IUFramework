//
//  IndexViewController.m
//  TestIntegrationUtil
//
//  Created by admin on 2017/2/4.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "IndexViewController.h"
#import "IndexModel.h"
#import "PushedViewController.h"
#import "NonNaviPushedViewController.h"
#import "PresentedViewController.h"

@interface IndexViewController () <IUTableViewPreviewing>
{
    id _p;
}
@end

@implementation IndexViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.navigationItem.title = @"Index";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.datas = @[
                             [IndexModel modelWithTitle:@"Push"],
                             [IndexModel modelWithTitle:@"Push(None Navi, status bar auto change)"],
                             [IndexModel modelWithTitle:@"Present(Custom)"],
                             ];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
        case 1:
            [self.navigationController pushViewController:[self tableView:tableView viewControllerToPreviewAtIndexPath:indexPath] animated:YES];
            break;
        case 2:
        {
            UIViewController *viewController = [[PresentedViewController alloc] init];
            _p = [IUTransitioningDelegate transitioningDelegateWithType:IUTransitionTypeFade];
            viewController.transitioningDelegate = _p;
            [self presentViewController:viewController animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}

- (UIViewController *)tableView:(UITableView *)tableView viewControllerToPreviewAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return [[PushedViewController alloc] init];
        case 1:
            return [[NonNaviPushedViewController alloc] init];
    }
    return nil;
}

@end
