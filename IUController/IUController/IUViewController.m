//
//  IUViewController.m
//  IUController
//
//  Created by admin on 2017/1/24.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "IUViewController.h"
#import "objc/runtime.h"

@interface NSObject (IUPreviewing)

@property (strong, nonatomic) IUViewController *(^previewControllerCreator)();

@end

static char TAG_OBJECT_PREVIEW_CONTROLLER_CREATOR;

@implementation NSObject (IUPreviewing)

- (void)setPreviewControllerCreator:(IUViewController *(^)())previewControllerCreator {
    objc_setAssociatedObject(self, &TAG_OBJECT_PREVIEW_CONTROLLER_CREATOR, previewControllerCreator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (IUViewController *(^)())previewControllerCreator {
    return objc_getAssociatedObject(self, &TAG_OBJECT_PREVIEW_CONTROLLER_CREATOR);
}

@end

@interface UIViewController (IUViewOwner)

- (BOOL)hasView:(UIView *)view;
- (BOOL)ownView:(UIView *)view;

@end

@interface IUViewController () <UITextFieldDelegate,UIViewControllerPreviewingDelegate>
{
    UIView *_editingView; // 编辑中的 textField 或 textView
    CGRect  _originFrame;
    BOOL    _isKeyboardVisible;
}

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicatorView;

@property (nonatomic, strong) UILabel *peekTitleLabel;
@property (nonatomic, assign) BOOL     isPeek;

@end

@interface IUViewController ()

@end

@implementation IUViewController

@synthesize scrollView                       = _scrollView,
            tableView                        = _tableView,
            collectionViewLayout             = _collectionViewLayout,
            collectionView                   = _collectionView,
            hideKeyboardTapGestureRecognizer = _hideKeyboardTapGestureRecognizer;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.tableViewSytle = UITableViewStylePlain;
    }
    return self;
}

#pragma mark - Life Cycle
- (void)willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
    if (self.parentViewController) {
        [self.peekTitleLabel removeFromSuperview];
    }
}

- (void)viewWillAppearForTheFirstTime:(BOOL)animated {
    // override point
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 直系导航控制器
    if ([self.parentViewController isKindOfClass:[UINavigationController class]]) {
        [self.navigationController setNavigationBarHidden:self.navigationBarHidden animated:animated];
        self.navigationController.interactivePopGestureRecognizer.enabled = !self.navigationInteractivePopGestureRecognizerDisabled;
    }
    
    [self addObserverForKeyboard];
    
    if (!self.viewHasAppeared) {
        self.viewHasAppeared = YES;
        [self viewWillAppearForTheFirstTime:animated];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeobserverForKeyboard];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self hideKeyboard];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    //禁止多按钮事件
    [self setExclusiveTouchForButtonsInView:self.view];
    if (self.peekTitleLabel.superview) {
        self.view.frame = CGRectMake(0, self.view.bounds.origin.y + self.peekTitleLabel.bounds.size.height, self.view.bounds.size.width, self.view.frame.size.height);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (self.navigationController == nil) {
        self.peekTitleLabel.text = self.navigationItem.title;
    }
}

#pragma mark - Actions
- (void)dismiss {
    if (self.presentingViewController) [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)hideKeyboard {
    [self.view endEditing:YES];
}

#pragma mark - Private Method
/// 注册键盘出现、消失通知
- (void)addObserverForKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //  Registering for textField notification.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_editingViewChanged:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_editingViewChanged:) name:UITextFieldTextDidEndEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_editingViewChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    
    //  Registering for textView notification.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_editingViewChanged:) name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_editingViewChanged:) name:UITextViewTextDidEndEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_editingViewChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

/// 移除键盘出现、消失通知
- (void)removeobserverForKeyboard {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidEndEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidEndEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}

/// 禁止多按钮事件
- (void)setExclusiveTouchForButtonsInView:(UIView *)view {
    for (UIView *subview in [view subviews]) {
        if([subview isKindOfClass:[UIButton class]]) {
            [((UIButton *)subview) setExclusiveTouch:YES];
        } else if ([subview isKindOfClass:[UIView class]]) {
            [self setExclusiveTouchForButtonsInView:subview];
        }
    }
}

#pragma mark - Lazy Loading
#pragma mark scrollView
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = self.view.bounds;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.contentSize = _scrollView.bounds.size;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.backgroundColor = self.view.backgroundColor;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

#pragma mark tableView
- (void)setTableViewSytle:(UITableViewStyle)tableViewSytle {
    if (_tableViewSytle == tableViewSytle) return;
    NSAssert(_tableView == nil, @"IUFramework error: call -setTableViewSytle: before -tableView invoked if you want to change the tableViewSytle");
    _tableViewSytle = tableViewSytle;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:self.tableViewSytle];
        _tableView.frame = self.view.bounds;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.01)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.01)];
        _tableView.sectionHeaderHeight = 0;
        _tableView.sectionFooterHeight = 0;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark collectionView
- (void)setCollectionViewLayout:(UICollectionViewLayout *)collectionViewLayout {
    if (_collectionViewLayout == collectionViewLayout) return;
    NSAssert(_collectionView == nil, @"IUFramework error: call -setCollectionViewLayout: before -collectionView invoked if you want to change the collectionViewLayout");
    _collectionViewLayout = collectionViewLayout;
}

- (UICollectionViewLayout *)collectionViewLayout {
    if (_collectionViewLayout == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsZero;
        layout.itemSize = self.view.bounds.size;
        _collectionViewLayout = layout;
    }
    return _collectionViewLayout;
}

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionViewLayout];
        _collectionView.frame = self.view.bounds;
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = self.view.backgroundColor;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (UILabel *)peekTitleLabel {
    if (!self.isPeek) return nil;
    if (_peekTitleLabel == nil) {
        _peekTitleLabel = [[UILabel alloc] init];
        _peekTitleLabel.frame = CGRectMake(0, -44, self.view.bounds.size.width, 44);
        _peekTitleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _peekTitleLabel.textAlignment = NSTextAlignmentCenter;
        
        UINavigationBar *navigationBar = [UINavigationBar appearance];
        _peekTitleLabel.backgroundColor = navigationBar.barTintColor ?: [UIColor blackColor];
        _peekTitleLabel.textColor = navigationBar.titleTextAttributes[NSForegroundColorAttributeName] ?: [UIColor whiteColor];
        _peekTitleLabel.font = navigationBar.titleTextAttributes[NSFontAttributeName] ?: [UIFont systemFontOfSize:20];
        [self.view addSubview:_peekTitleLabel];
    }
    return _peekTitleLabel;
}

- (UITapGestureRecognizer *)hideKeyboardTapGestureRecognizer {
    if (_hideKeyboardTapGestureRecognizer == nil) {
        _hideKeyboardTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    }
    return _hideKeyboardTapGestureRecognizer;
}

#pragma mark - Override
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

#pragma mark - UIViewControllerPreviewingDelegate
- (void)registerPreviewingWithSourceView:(UIView *)sourceView viewControllerCreator:(IUViewController *(^)())creator {
    if (creator && [self respondsToSelector:@selector(traitCollection)] &&
        [self.traitCollection respondsToSelector:@selector(forceTouchCapability)] &&
        self.traitCollection.forceTouchCapability != UIForceTouchCapabilityUnavailable) {
        sourceView.previewControllerCreator = creator;
        [self registerForPreviewingWithDelegate:self sourceView:sourceView];
    }
}

- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    IUViewController *viewController = nil;
    if (previewingContext.sourceView.previewControllerCreator) {
        viewController = previewingContext.sourceView.previewControllerCreator();
        viewController.isPeek = YES;
    }
    return viewController;
}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self.navigationController pushViewController:viewControllerToCommit animated:NO];
}

#pragma mark - UITextFieldDelegate
// 点击return键关闭键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - Keyboard Observer Method
- (UIScrollView *)keyboardFittingScrollView {
    if (_keyboardFittingScrollView == nil) {
        if (_scrollView) {
            return _scrollView;
        }
        if (_tableView) {
            return _tableView;
        }
        if (_collectionView) {
            return _collectionView;
        }
    }
    return nil;
}

- (void)_editingViewChanged:(NSNotification *)notification {
    _editingView = [self ownView:notification.object] ? notification.object : nil;
}

// 键盘出现, 保存底视图frame, 根据底视图类型, 滚动或移动底视图避让键盘
- (void)_keyboardWillShow:(NSNotification *)notification {
    if (_isKeyboardVisible) return;
    _isKeyboardVisible = YES;
    
    [(self.keyboardFittingScrollView ?: self.view) addGestureRecognizer:self.hideKeyboardTapGestureRecognizer];
    _originFrame = self.view.frame;
    
    _keyboardHeight = [[notification userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [self adjustFrameToFitKeyboard];
    
    [self keyboardHeightChanged];
}

- (void)_keyboardWillChangeFrame:(NSNotification *)notification {
    if (!_isKeyboardVisible) return;
    
    _keyboardHeight = [[notification userInfo][UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    [self adjustFrameToFitKeyboard];
    
    [self keyboardHeightChanged];
}

// 键盘消失, 还原frame大小, 移除键盘出现、消失通知, 释放编辑视图、底视图
- (void)_keyboardWillHide:(NSNotification *)notification {
    if (!_isKeyboardVisible) return;
    _isKeyboardVisible = NO;
    
    [(self.keyboardFittingScrollView ?: self.view) removeGestureRecognizer:self.hideKeyboardTapGestureRecognizer];
    _keyboardHeight = 0;
    self.view.frame = _originFrame;
    _editingView = nil;
    
    [self keyboardHeightChanged];
}

- (void)keyboardHeightChanged {
    // override point
}

/// 根据当前键盘高度调整 self.keyboardFittingScrollView 的 frame, 随后滚动至输入框可见位置
- (void)adjustFrameToFitKeyboard {
    if (self.keyboardFittingScrollView == nil) return;
    
    CGRect frame = _originFrame;
    
    CGRect windowFrame = [self.view.superview convertRect:_originFrame toView:self.view.window];
    CGFloat delta = _keyboardHeight - ([[UIScreen mainScreen] bounds].size.height - windowFrame.origin.y - windowFrame.size.height);
    delta = MAX(0, delta);
    frame.size.height -= delta;
    
    self.view.frame = frame;
    
    // 调整frame的同时滚动视图会失败, 需要延时
    [self performSelector:@selector(scrollToShowEditingView) withObject:nil afterDelay:0];
}

/// 滚动 self.keyboardFittingScrollView 至输入框可见位置
- (void)scrollToShowEditingView {
    CGRect rect = [_editingView convertRect:_editingView.bounds toView:self.keyboardFittingScrollView];
    rect.size.height += 20;
    [self.keyboardFittingScrollView scrollRectToVisible:rect animated:YES];
}

@end

@implementation UIViewController (IUViewOwner)

- (BOOL)hasView:(UIView *)view {
    if (![view isKindOfClass:[UIView class]]) return NO;
    while (view) {
        if (self.view == view) {
            return YES;
        }
        view = view.superview;
    }
    return NO;
}

- (BOOL)ownView:(UIView *)view {
    if ([self hasView:view]) {
        for (UIViewController *viewController in self.childViewControllers) {
            if ([viewController hasView:view]) {
                return NO;
            }
        }
        return YES;
    }
    return NO;
}

@end
