//
//  SpringLayoutViewController.m
//  TestIntegrationUtil
//
//  Created by admin on 2017/2/6.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "SpringLayoutViewController.h"

@interface SpringLayoutViewController () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegateFlowLayout,IUCollectionViewDelegateWaterfallLayout>
{
    UIView *_magicView;
}
@end

@implementation SpringLayoutViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.navigationItem.title = @"Spring Layout";
        self.collectionViewLayout = [[IUCollectionViewSpringFlowLayout alloc] init];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear : %@", self.tabBarItem.title);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear : %@", self.tabBarItem.title);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear : %@", self.tabBarItem.title);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear : %@", self.tabBarItem.title);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"view"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"view"];
    [self.collectionView layoutIfNeeded];
    
//    [self.view addSubview:[[UIView alloc] initWithFrame:CGRectMake(200, 300, 100, 100)].setBackgroundColor([UIColor cyanColor]).bind(&_magicView)];
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 10;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 50;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(arc4random() % 30 + 1, arc4random() % 30 + 1);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor randomColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(0, arc4random() % 50 + 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(0, arc4random() % 50 + 10);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"view" forIndexPath:indexPath];
    view.backgroundColor = [UIColor randomColor];
    return view;
}

- (NSInteger)numberOfWaterfallInCollectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout {
    return 6;
}

@end
