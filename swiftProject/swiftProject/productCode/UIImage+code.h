//
//  UIImage+code.h
//  swiftProject
//
//  Created by 杨世川 on 2019/12/10.
//  Copyright © 2019 yangshichuan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (code)
+ (UIImage *)createQRCodeWithData:(NSString *)dataString logoImage:(UIImage *)logoImage imageSize:(CGFloat)size;
@end

NS_ASSUME_NONNULL_END
