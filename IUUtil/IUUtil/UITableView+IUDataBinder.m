//
//  UITableView+IUDataBinder.m
//  IUUtil
//
//  Created by admin on 2017/1/24.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "UITableView+IUDataBinder.h"
#import "UIView+IUEmpty.h"
#import "objc/runtime.h"

static char TAG_TABLE_VIEW_DATA_BINDER;

@interface IUTableViewDataBinder : NSObject <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) NSArray *datas;

- (void)setDatas:(NSArray *)datas animated:(BOOL)animated;

@property (nonatomic, weak) id<UITableViewDataSource> dataSource;
@property (nonatomic, weak) id<IUTableViewPreviewing> delegate;

@property (nonatomic, strong) NSMutableDictionary <NSString *, UITableViewCell *> *templateCellsByIdentifiers;

@end

@interface UITableView () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong, readonly) IUTableViewDataBinder *dataBinder;

@end

@implementation UITableView (IUDataBinder)

+ (void)load {
    if ([self instancesRespondToSelector:@selector(setLayoutMargins:)] || [self instancesRespondToSelector:@selector(setSeparatorInset:)]) {
        method_exchangeImplementations(class_getInstanceMethod(self, @selector(initWithFrame:style:)), class_getInstanceMethod(self, @selector(iu_initWithFrame:style:)));
    }
}

- (instancetype)iu_initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    UITableView *obj = [self iu_initWithFrame:frame style:style];
    if (obj) {
        if ([obj respondsToSelector:@selector(setLayoutMargins:)]) obj.layoutMargins = UIEdgeInsetsZero;
        if ([obj respondsToSelector:@selector(setSeparatorInset:)]) obj.separatorInset = UIEdgeInsetsZero;
    }
    return obj;
}

- (IUTableViewDataBinder *)dataBinder {
    IUTableViewDataBinder *dataBinder = objc_getAssociatedObject(self, &TAG_TABLE_VIEW_DATA_BINDER);
    if (dataBinder == nil) {
        dataBinder = [[IUTableViewDataBinder alloc] init];
        objc_setAssociatedObject(self, &TAG_TABLE_VIEW_DATA_BINDER, dataBinder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        dataBinder.tableView = self;
        dataBinder.dataSource = self.dataSource;
        dataBinder.delegate = self.delegate;
        
        self.dataSource = dataBinder;
        self.delegate = dataBinder;
    }
    return dataBinder;
}

- (void)setDatas:(NSArray *)datas {
    [self setDatas:datas animated:YES];
}

- (NSArray *)datas {
    return self.dataBinder.datas;
}

- (void)setDatas:(NSArray *)datas animated:(BOOL)animated {
    [self.dataBinder setDatas:datas animated:animated];
}

- (UIViewController *)viewController {
    UIResponder *responder = self;
    while (responder != nil && ![responder isKindOfClass:[UIViewController class]]) {
        responder = [responder nextResponder];
    }
    return responder;
}

@end

@implementation IUTableViewDataBinder

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [super respondsToSelector:aSelector] || [self.dataSource respondsToSelector:aSelector] || [self.delegate respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([self.dataSource respondsToSelector:aSelector]) {
        return self.dataSource;
    } else if ([self.delegate respondsToSelector:aSelector]) {
        return self.delegate;
    }
    return [super forwardingTargetForSelector:aSelector];
}

- (void)setDatas:(NSArray *)datas {
    [self setDatas:datas animated:YES];
}

- (void)setDatas:(NSArray *)datas animated:(BOOL)animated {
    if (!animated) {
        
        _datas = datas;
        [self.tableView reloadData];
        
    } else {
        NSUInteger oldLength = [self.tableView numberOfSections];
        NSUInteger newLength = [datas count];
        _datas = datas;
        if (oldLength == newLength) {
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newLength)] withRowAnimation:UITableViewRowAnimationFade];
            
        } else if (oldLength > newLength) {
            
            [self.tableView beginUpdates];
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newLength)] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(newLength, oldLength - newLength)] withRowAnimation:UITableViewRowAnimationFade];
            
            [self.tableView endUpdates];
            
        } else {
            
            [self.tableView beginUpdates];
            
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, oldLength)] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(oldLength, newLength - oldLength)] withRowAnimation:UITableViewRowAnimationFade];
            
            [self.tableView endUpdates];
            
        }
        
    }
    
    [self.tableView setEmpty:[_datas count] == 0 animated:animated];
}

#pragma mark UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.dataSource respondsToSelector:_cmd]) {
        return [self.dataSource numberOfSectionsInTableView:tableView];
    }
    return [self.datas count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.dataSource respondsToSelector:_cmd]) {
        return [self.dataSource tableView:tableView numberOfRowsInSection:section];
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:_cmd]) {
        return [self.delegate tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return [self cellHeightWithData:self.datas[indexPath.section] inTableView:tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dataSource respondsToSelector:_cmd]) {
        return [self.dataSource tableView:tableView cellForRowAtIndexPath:indexPath];
    }
    
    id data = self.datas[indexPath.section];
    
    Class cellClass = [self cellClassWithData:data];
    
    UITableViewCell <IUTableViewCellModelSettable> *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(cellClass)];
    if (cell == nil) {
        cell = [cellClass alloc];
        cell = [cell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(cellClass)];
        
        UIViewController *viewController = self.tableView.viewController;
        if ([viewController respondsToSelector:@selector(traitCollection)] &&
            [viewController.traitCollection respondsToSelector:@selector(forceTouchCapability)] &&
            viewController.traitCollection.forceTouchCapability != UIForceTouchCapabilityUnavailable) {
            [viewController registerForPreviewingWithDelegate:self sourceView:cell];
        }
    }
    
    if ([cell respondsToSelector:@selector(setModel:)]) cell.model = data;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:_cmd]) {
        [self.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark UIViewControllerPreviewingDelegate
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    if ([self.delegate respondsToSelector:@selector(tableView:viewControllerToPreviewAtIndexPath:)]) {
        UIViewController *viewController = [self.delegate tableView:self.tableView viewControllerToPreviewAtIndexPath:[self.tableView indexPathForCell:previewingContext.sourceView]];
        if ([viewController respondsToSelector:@selector(setIsPeek)]) {
            [viewController setValue:@YES forKey:@"isPeek"];
        }
        return viewController;
    }
    return nil;
}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self.tableView.viewController.navigationController pushViewController:viewControllerToCommit animated:NO];
}

#pragma mark Private Method
- (NSMutableDictionary<NSString *,UITableViewCell *> *)templateCellsByIdentifiers {
    if (_templateCellsByIdentifiers == nil) {
        _templateCellsByIdentifiers = [@{} mutableCopy];
    }
    return _templateCellsByIdentifiers;
}

- (Class)cellClassWithData:(id)data {
    Class cellClass = nil;
    @try {
        cellClass = NSClassFromString([data valueForKey:@"cellClassName"]);
    } @catch (NSException *exception) {
        cellClass = nil;
    }
    for (int i = 0; cellClass == nil && i < 6; i++) {
        NSString *cellClassName = NSStringFromClass([data class]);
        if (i < 3) {
            if ([cellClassName hasSuffix:@"Model"]) {
                cellClassName = [cellClassName substringToIndex:cellClassName.length - 5];
            } else {
                continue;
            }
        }
        switch (i % 3) {
            case 0:
                cellClassName = [cellClassName stringByAppendingString:@"TableViewCell"];
                break;
            case 1:
                cellClassName = [cellClassName stringByAppendingString:@"TableCell"];
                break;
            case 2:
                cellClassName = [cellClassName stringByAppendingString:@"Cell"];
                break;
                
            default:
                break;
        }
        
        cellClass = NSClassFromString(cellClassName);
    }
    
    NSAssert(cellClass != nil, @"cell class is NOT declared");
    
    return cellClass;
}

- (CGFloat)cellHeightWithData:(id)data inTableView:(UITableView *)tableView {
    Class cellClass = [self cellClassWithData:data];
    UITableViewCell <IUTableViewCellModelSettable> *templateCell = [self templateCellWithCellClass:cellClass];
    [templateCell prepareForReuse];
    if ([templateCell respondsToSelector:@selector(setModel:)]) templateCell.model = data;
    return [self heightWithCell:templateCell inTableView:tableView];
}

- (UITableViewCell *)templateCellWithCellClass:(Class)cellClass {
    NSString *templateIdentifier = [NSStringFromClass(cellClass) stringByAppendingString:@"_TEMPLATE"];
    UITableViewCell *templateCell = self.templateCellsByIdentifiers[templateIdentifier];
    if (templateCell == nil) {
        templateCell = [cellClass alloc];
        templateCell = [templateCell initWithStyle:UITableViewCellStyleDefault reuseIdentifier:templateIdentifier];
        templateCell.contentView.translatesAutoresizingMaskIntoConstraints = NO;
        self.templateCellsByIdentifiers[templateIdentifier] = templateCell;
    }
    return templateCell;
}

- (CGFloat)heightWithCell:(UITableViewCell *)cell inTableView:(UITableView *)tableView {
    CGFloat contentViewWidth = CGRectGetWidth(tableView.frame);
    
    // If a cell has accessory view or system accessory type, its content view's width is smaller
    // than cell's by some fixed values.
    if (cell.accessoryView) {
        contentViewWidth -= 16 + CGRectGetWidth(cell.accessoryView.frame);
    } else {
        static const CGFloat systemAccessoryWidths[] = {
            [UITableViewCellAccessoryNone] = 0,
            [UITableViewCellAccessoryDisclosureIndicator] = 34,
            [UITableViewCellAccessoryDetailDisclosureButton] = 68,
            [UITableViewCellAccessoryCheckmark] = 40,
            [UITableViewCellAccessoryDetailButton] = 48
        };
        contentViewWidth -= systemAccessoryWidths[cell.accessoryType];
    }
    
    // If not using auto layout, you have to override "-sizeThatFits:" to provide a fitting size by yourself.
    // This is the same height calculation passes used in iOS8 self-sizing cell's implementation.
    //
    // 1. Try "- systemLayoutSizeFittingSize:" first. (skip this step if 'fd_enforceFrameLayout' set to YES.)
    // 2. Warning once if step 1 still returns 0 when using AutoLayout
    // 3. Try "- sizeThatFits:" if step 1 returns 0
    // 4. Use a valid height or default row height (44) if not exist one
    
    CGFloat fittingHeight = 0;
    
    if (contentViewWidth > 0) {
        // Add a hard width constraint to make dynamic content views (like labels) expand vertically instead
        // of growing horizontally, in a flow-layout manner.
        NSLayoutConstraint *widthFenceConstraint = [NSLayoutConstraint constraintWithItem:cell.contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:contentViewWidth];
        [cell.contentView addConstraint:widthFenceConstraint];
        
        // Auto layout engine does its math
        fittingHeight = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
        [cell.contentView removeConstraint:widthFenceConstraint];
    }
    
    if (fittingHeight == 0) {
        fittingHeight = [cell sizeThatFits:CGSizeMake(contentViewWidth, 0)].height;
    }
    
    // Still zero height after all above.
    if (fittingHeight == 0) {
        // Use default row height.
        fittingHeight = tableView.rowHeight ?: 44;
    }
    
    // Add 1px extra space for separator line if needed, simulating default UITableViewCell.
    if (tableView.separatorStyle != UITableViewCellSeparatorStyleNone) {
        fittingHeight += 1.0 / [UIScreen mainScreen].scale;
    }
    
    return fittingHeight;
}

@end

@interface UITableViewCell (IUSeparatorSetting)

@end

@implementation UITableViewCell (IUSeparatorSetting)

+ (void)load {
    if ([self instancesRespondToSelector:@selector(setLayoutMargins:)] || [self instancesRespondToSelector:@selector(setSeparatorInset:)]) {
        method_exchangeImplementations(class_getInstanceMethod(self, @selector(initWithStyle:reuseIdentifier:)), class_getInstanceMethod(self, @selector(iu_initWithStyle:reuseIdentifier:)));
    }
}

- (instancetype)iu_initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    UITableViewCell *obj = [self iu_initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (obj) {
        if ([obj respondsToSelector:@selector(setLayoutMargins:)]) obj.layoutMargins = UIEdgeInsetsZero;
        if ([obj respondsToSelector:@selector(setSeparatorInset:)]) obj.separatorInset = UIEdgeInsetsZero;
    }
    return obj;
}

@end
