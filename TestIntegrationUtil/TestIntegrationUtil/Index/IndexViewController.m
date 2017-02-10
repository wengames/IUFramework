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
#import "SpringLayoutViewController.h"
#import "TabPageViewController.h"

@interface IndexViewController () <IUTableViewPreviewing>
{
    id _p;
    
    UIView *_magicView;
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
    
    __weak typeof(self) weakSelf = self;
    self.tableView.emptyViewGenerate = ^{
        UIView *view = [[UIView alloc] init].setBackgroundColor([UIColor cyanColor]);
        [view addSubview:[[UILabel alloc] init].setText(@"This is an empty view\n\nTap to reset data").setTextAlignment(NSTextAlignmentCenter).setNumberOfLines(0).setAutoresizingMask(UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight)];
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:weakSelf action:@selector(resetData)]];
        return view;
    };
    
    [self resetData];
        
    [self.view addSubview:[[UIImageView alloc] initWithFrame:CGRectMake(0, 400, 100, 100)].setImage([[UIImage imageNamed:@"filter_test.jpg"] blurredImageWithRadius:50]).setBackgroundColor([UIColor cyanColor]).bind(&_magicView)];
}

- (NSArray *)magicViewsTransitionToViewController:(UIViewController *)viewController {
    return @[_magicView];
}

- (NSArray *)magicViewsTransitionFromViewController:(UIViewController *)viewController {
    return @[_magicView];
}

- (void)resetData {
    self.tableView.datas = @[
                             [IndexModel modelWithTitle:@"Push(Landscape)"],
                             [IndexModel modelWithTitle:@"Push(None Navi, status bar auto change)"],
                             [IndexModel modelWithTitle:@"Present(Custom)"],
                             [IndexModel modelWithTitle:@"Empty Table View"],
                             [IndexModel modelWithTitle:@"Spring Layout"],
                             [IndexModel modelWithTitle:@"Tab Page View"],
                             [IndexModel modelWithTitle:@"CIFilter"]
                             ];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
        case 1:
        case 4:
        case 6:
        {
            [self.navigationController pushViewController:[self tableView:tableView viewControllerToPreviewAtIndexPath:indexPath] animated:YES];
        }
            break;
        case 5:
            [[IURouter router] open:@"TabPageViewController/1/2/3?tab=page"];
            break;
        case 2:
        {
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[[PresentedViewController alloc] init]];
            _p = [IUTransitioningDelegate transitioningDelegateWithType:IUTransitionTypeFade];
            navigationController.transitioningDelegate = _p;
            navigationController.modalPresentationStyle = UIModalPresentationCustom;
            [self presentViewController:navigationController animated:YES completion:nil];
        }
            break;
        case 3:
            tableView.datas = nil;
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
        case 4:
            return [[SpringLayoutViewController alloc] init];
        case 5:
            return [[TabPageViewController alloc] init];
        case 6:
        {
            IUFilterParameterEffectPreviewViewController *viewController = [[IUFilterParameterEffectPreviewViewController alloc] init];
            viewController.originImage = [UIImage imageNamed:@"filter_test.jpg"];
            return viewController;
        }
    }
    return nil;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
