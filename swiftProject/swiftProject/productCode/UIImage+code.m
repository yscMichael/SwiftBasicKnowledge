//
//  UIImage+code.m
//  swiftProject
//
//  Created by 杨世川 on 2019/12/10.
//  Copyright © 2019 yangshichuan. All rights reserved.
//

#import "UIImage+code.h"
#import <CoreImage/CoreImage.h>

@implementation UIImage (code)

+ (UIImage *)createQRCodeWithData:(NSString *)dataString logoImage:(UIImage *)logoImage imageSize:(CGFloat)size
{
    // 1. 创建一个二维码滤镜实例(CIFilter)
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 滤镜恢复默认设置
    [filter setDefaults];

    // 2. 给滤镜添加数据
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    // 使用KVC的方式给filter赋值
    [filter setValue:data forKeyPath:@"inputMessage"];

    // 3. 生成二维码
    CIImage *codeImage = [filter outputImage];


    return [[[UIImage alloc] init] QRCodeUIImageFormCIImage:codeImage logoImage:logoImage withSize:size];
}

- (UIImage *)QRCodeUIImageFormCIImage:(CIImage *)image logoImage:(UIImage *)logoImage withSize:(CGFloat)size
{

    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));

    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);

    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    UIImage *newCodeImage = [UIImage imageWithCGImage:scaledImage];
    
    return [self addImage:newCodeImage logo:logoImage];
}
/**
 在一张图片上添加logo或者水印；
 warn 不支持jpg的图片

 @param image 原始的图片
 @param logoImage 要添加的logo
 @return 返回一张新的图片
 */
-(UIImage *)addImage:(UIImage *)image logo:(UIImage *)logoImage
{
    if (logoImage == nil)
    {
        return image;
    }
    //原始图片的宽和高，可以根据需求自己定义
    CGFloat w = image.size.width;
    CGFloat h = image.size.height;
    //logo的宽和高，也可以根据需求自己定义
    CGFloat logoWidth = w * 0.25;
    CGFloat logoHeight = h * 0.25;
    //绘制
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 444 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), image.CGImage);
    //绘制的logo位置,可自己调整
    CGContextDrawImage(context, CGRectMake((w - logoWidth)/2,(h - logoHeight)/2, logoWidth, logoHeight), [logoImage CGImage]);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return [UIImage imageWithCGImage:imageMasked];
}
@end
