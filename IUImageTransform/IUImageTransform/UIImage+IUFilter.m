//
//  UIImage+IUFilter.m
//  IUImageTransform
//
//  Created by admin on 2017/2/9.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "UIImage+IUFilter.h"

@implementation UIImage (IUFilter)

- (UIImage *)imageWithFilterName:(NSString *)filterName {
    //将UIImage转换成CIImage
    CIImage *ciImage = [[CIImage alloc] initWithImage:self];
    
    //创建滤镜
    CIFilter *filter = [CIFilter filterWithName:filterName keysAndValues:kCIInputImageKey, ciImage, nil];
    if (filter == nil) {
        return self;
    }
    
    //已有的值不改变，其他的设为默认值
    [filter setDefaults];
    
    //获取绘制上下文
    CIContext *context = [CIContext contextWithOptions:nil];
    
    //渲染并输出CIImage
    CIImage *outputImage = [filter outputImage];
    
    //创建CGImage句柄
    CGImageRef cgImage = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    //获取图片
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    
    //释放CGImage句柄
    CGImageRelease(cgImage);

    return image;
}

- (void)imageWithFilterName:(NSString *)filterName completion:(void (^)(UIImage *))completion {
    if (completion == nil) return;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UIImage *image = [self imageWithFilterName:filterName];
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(image);
        });
    });
}

- (UIImage *)invertImage {
    return [self imageWithFilterName:@"CIColorInvert"];
}

@end
