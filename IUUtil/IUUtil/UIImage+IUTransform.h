//
//  UIImage+IUTransform.h
//  IUUtil
//
//  Created by admin on 2017/2/6.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (IUTransform)

/**
 *  压缩图片至 size(单位KB) 以下大小, 如无法压至该尺寸以下, 则取最大压缩尺寸
 *
 *  @param size    要求大小上限, 单位KB
 *  @return        压缩后的NSData
 */
- (NSData *)transformToDataBelowSize:(CGFloat)size;

/** 截取当前image对象rect区域内的图像 */
- (UIImage *)subImageWithRect:(CGRect)rect;

/** 压缩图片至指定尺寸 */
- (UIImage *)rescaleImageToSize:(CGSize)size;

/** 压缩图片至指定像素 */
- (UIImage *)rescaleImageToPX:(CGFloat )toPX;

/** 在指定的size里面生成一个平铺的图片 */
- (UIImage *)getTiledImageWithSize:(CGSize)size;

/** 渲染图片颜色为 color */
- (UIImage *)renderedImageWithColor:(UIColor *)color;

/** 获得灰度图 */
- (UIImage *)grayImage;

/** UIView转化为UIImage */
+ (UIImage *)imageFromView:(UIView *)view;

/** 将两个图片生成一张图片 */
+ (UIImage *)mergeImage:(UIImage *)firstImage withImage:(UIImage *)secondImage;
- (UIImage *)mergedImageWithImage:(UIImage *)image;

@end

@interface UIImage (IUColor)

/**
 *  生成纯色UIImage
 *
 *  @param   color  颜色
 *  @param   size   image尺寸
 *  @return  纯色UIImage
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 *  生成渐变色UIImage
 *
 *  @param size             尺寸
 *  @param direction        渐变方向(默认{0,1}, 垂直向下)
 *  @param colors           颜色数组(UIColor 或 CGColorRef)
 *  @return                 渐变色UIImage
 */
+ (UIImage *)imageWithColors:(NSArray *)colors size:(CGSize)size direction:(CGPoint)direction;
+ (UIImage *)imageWithColors:(NSArray *)colors size:(CGSize)size;

/**
 *  取图片某一像素的颜色
 *
 *  @param point    图片上的点
 *  @return         该点像素的颜色
 */
- (UIColor *)colorAtPixel:(CGPoint)point;

@end

@interface UIImage (IURotate)

/**
 *  纠正图片的方向
 *
 *  @return UIImage
 */
- (UIImage *)fixOrientation;

/**
 *  按给定的方向旋转图片
 *
 *  @param orient   UIImageOrientation枚举类
 *  @return         UIImage
 */
- (UIImage*)rotate:(UIImageOrientation)orient;

/**
 *  垂直翻转
 *
 *  @return UIImage
 */
- (UIImage *)flipVertical;

/**
 *  水平翻转
 *
 *  @return UIImage
 */
- (UIImage *)flipHorizontal;

/**
 *  将图片旋转degrees角度
 *
 *  @param degrees   角度
 *  @return          UIImage
 */
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

/**
 *  将图片旋转radians弧度
 *
 *  @param radians   弧度
 *  @return          UIImage
 */
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;

@end

@interface UIImage (IUGif)

/**
 *  通过gif生成UIImage
 *
 *  @param gifData   GIFData
 *  @return          UIImage
 */
+ (UIImage *)animatedImageWithGIFData:(NSData *)gifData;

/**
 *  通过gif生成UIImage
 *
 *  @param gifURL   GIF路径
 *  @return         UIImage
 */
+ (UIImage *)animatedImageWithGIFURL:(NSURL *)gifURL;

@end
