//
//  UIImage+YFImage.m
//  自家扩展
//


#import "UIImage+YFImage.h"

@implementation UIImage (YFImage)

//把图片切成正方形 
+ (UIImage *)clipImageWithImage:(UIImage *)image {
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    //取宽高中 较小的一个
    CGFloat minSize = MIN(imageHeight, imageWidth);
    CGRect newRect = CGRectMake(0, 0, minSize, minSize);
    CGImageRef ImageRef = CGImageCreateWithImageInRect(image.CGImage, newRect);
    UIGraphicsBeginImageContext(newRect.size);
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextDrawImage(ref, newRect, ImageRef);
    UIImage *imageB = [UIImage imageWithCGImage:ImageRef];
    UIGraphicsEndImageContext();
    return imageB;
}

//把图片切成 某一个尺寸
+ (UIImage *)clipImageWithImage:(UIImage *)image withFrame:(CGRect)frame {
    CGRect newRect = frame;
    CGImageRef ImageRef = CGImageCreateWithImageInRect(image.CGImage, newRect);
    UIGraphicsBeginImageContext(newRect.size);
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextDrawImage(ref, newRect, ImageRef);
    UIImage *imageB = [UIImage imageWithCGImage:ImageRef];
    UIGraphicsEndImageContext();
    return imageB;
}

//将图片分解成m行 n列的小图片
+ (NSMutableArray *)clipImageWithImage:(UIImage *)image withConuntM:(int)countM withCountN:(int)countN {
    NSMutableArray *array = [NSMutableArray array];
    //首先这个图片已经是正方形的,然后设置他的宽高
    //m行的图片宽度
    CGFloat imageSizeWidth = image.size.width / (CGFloat)countM;
    //n列图片高度
    CGFloat imageSizeHeigh = image.size.height / (CGFloat)countN;

    for (int i = 0; i < countM; i++) {
        for (int j = 0; j < countN; j++) {
        
        
            CGRect newRect = CGRectMake((CGFloat)j * imageSizeWidth, (CGFloat)i * imageSizeHeigh, imageSizeWidth, imageSizeHeigh);
            CGImageRef ImageRef = CGImageCreateWithImageInRect(image.CGImage, newRect);
            UIGraphicsBeginImageContext(newRect.size);
            CGContextRef ref = UIGraphicsGetCurrentContext();
            CGContextDrawImage(ref, newRect, ImageRef);
        
            //通过imageRef生成一个image
            UIImage *imageB = [UIImage imageWithCGImage:ImageRef];
            UIGraphicsEndImageContext();
            //将每一个小图片加入到数组中
        
            [array addObject:imageB];
        }
    }
    return array;;
}



@end
