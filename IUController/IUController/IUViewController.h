//
//  IUViewController.h
//  IUController
//
//  Created by admin on 2017/1/24.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IUViewController : UIViewController

@property (nonatomic, assign)           BOOL             navigationBarHidden;   // default is NO;

@property (nonatomic, strong, readonly) UIScrollView     *scrollView;           // a scroll view fits view size, lazy loading

/// preset tableViewSytle for tableView below, default is UITableViewStylePlain, call before -tableView invoked
@property (nonatomic, assign)           UITableViewStyle  tableViewSytle;
@property (nonatomic, strong, readonly) UITableView      *tableView;            // a table view fits view size, lazy loading

/// preset layout for collectionView below, default is UICollectionViewFlowLayout with all 0 edges, call before -collectionView invoked
@property (nonatomic, strong)     UICollectionViewLayout *collectionViewLayout;
@property (nonatomic, strong, readonly) UICollectionView *collectionView;       // a collection view fits view size, lazy loading

@property (nonatomic, strong, readonly) UITapGestureRecognizer *hideKeyboardTapGestureRecognizer;
@property (nonatomic, assign, readonly) CGFloat           keyboardHeight;               // current keyboard height
@property (nonatomic, strong)           UIScrollView     *keyboardFittingScrollView;    // a scroll view to fit with keyboard, can be nil

@property (nonatomic, assign)           BOOL              viewHasAppeared;      // the view has appeared before or not

/// if property viewHasAppeared is NO, -viewWillAppear: will also invoke this method
- (void)viewWillAppearForTheFirstTime:(BOOL)animated;

/// [self.presentingViewController dismissViewControllerAnimated:YES completion:nil]
- (void)dismiss;
/// [self.view endEditing:YES]
- (void)hideKeyboard;
/// override point, will be invoked when keyboard height changed
- (void)keyboardHeightChanged;
///　retister peek action (if NOT iPhone6s & iOS9 or later, it does nothing)
- (void)registerPreviewingWithSourceView:(UIView *)sourceView viewControllerCreator:(IUViewController *(^)())creator;

@end
