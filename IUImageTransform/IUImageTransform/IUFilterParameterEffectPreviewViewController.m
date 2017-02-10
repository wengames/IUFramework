//
//  IUFilterParameterEffectPreviewViewController.m
//  IUImageTransform
//
//  Created by admin on 2017/2/9.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "IUFilterParameterEffectPreviewViewController.h"
#import "UIImage+IUFilter.h"

@interface IUFilterParameterEffectPreviewViewController () <UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) UIImageView  *imageView;
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) NSArray      *filterCategories;
@property (nonatomic, strong) NSArray      *filterNames;

@end

@implementation IUFilterParameterEffectPreviewViewController

+ (instancetype)preview {
    IUFilterParameterEffectPreviewViewController *viewController = [[self alloc] init];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:viewController animated:NO completion:nil];
    return viewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadImage];
}

- (void)reloadImage {
    [self.originImage imageWithFilterName:self.filterNames[[self.pickerView selectedRowInComponent:1]] completion:^(UIImage *image) {
        self.imageView.image = image;
    }];
}

- (void)setOriginImage:(UIImage *)originImage {
    _originImage = originImage;
    [self reloadImage];
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 200);
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:_imageView];
    }
    return _imageView;
}

- (UIPickerView *)pickerView {
    if (_pickerView == nil) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.showsSelectionIndicator = YES;
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.frame = CGRectMake(0, self.view.bounds.size.height - 200, self.view.bounds.size.width, 200);
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        [self.view addSubview:_pickerView];
    }
    return _pickerView;
}

- (NSArray *)filterCategories {
    if (_filterCategories == nil) {
        _filterCategories = @[
                              kCICategoryDistortionEffect,
                              kCICategoryGeometryAdjustment,
                              kCICategoryCompositeOperation,
                              kCICategoryHalftoneEffect,
                              kCICategoryColorAdjustment,
                              kCICategoryColorEffect,
//                              kCICategoryTransition, // cause crash
                              kCICategoryTileEffect,
//                              kCICategoryGenerator, // cause crash
                              kCICategoryReduction,
//                              kCICategoryGradient, // cause crash
                              kCICategoryStylize,
                              kCICategorySharpen,
                              kCICategoryBlur,
                              kCICategoryVideo,
                              kCICategoryStillImage,
                              kCICategoryInterlaced,
                              kCICategoryNonSquarePixels,
                              kCICategoryHighDynamicRange,
                              kCICategoryBuiltIn
                              ];
    }
    return _filterCategories;
}

- (NSArray *)filterNames {
    if (_filterNames == nil) {
        _filterNames = [CIFilter filterNamesInCategory:self.filterCategories[[self.pickerView selectedRowInComponent:1]]];
    }
    return _filterNames;
}

#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [self.filterCategories count];
    }
    return [self.filterNames count];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.adjustsFontSizeToFitWidth = YES;
    if (component == 0) {
        label.text = [self.filterCategories[row] substringFromIndex:10];
    } else {
        label.text = [self.filterNames[row] substringFromIndex:2];
    }
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.filterNames = [CIFilter filterNamesInCategory:self.filterCategories[row]];
        [pickerView reloadComponent:1];
    }
    [self reloadImage];
}

@end
