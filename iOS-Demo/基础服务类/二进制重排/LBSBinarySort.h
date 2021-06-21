//
//  LBSBinarySort.h
//  iOS-Demo
//
//  Created by lbs on 2021/6/21.
//  Copyright © 2021 LBS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 参考文章： iOS 优化篇 - 启动优化之Clang插桩实现二进制重排https://juejin.cn/post/6844904130406793224
 1. 在Build Setting添加 Other C Flag: -fsanitize-coverage=func,trace-pc-guard
 2. OC和Swift混合开发，在Build Setting添加 Other Swift Flag: -sanitize-coverage=func,-sanitize=undefined
 3. 查看沙盒temp文件夹下的符号文件
 4. 新建排序文件，在项目根目录touch lb.order，编辑启动时需要用到的符号
 5. 配置order文件, 在Build Setting下搜索Order File，配置路径 $(SRCROOT)/lb.order
 6. 查看重排之后的顺序。先在Build Setting的Write Link Map File设置为YES; 然后clean工程，运行，在Products的.appp文件 Show In Finder， 找到Intermediates.noindex文件下下的.txt文件； 定位到文件内容里面的"# Symbols:"进行查看。
 */
@interface LBSBinarySort : NSObject


/// 记录符号顺序，在temp下输出文件
+ (void)record;
@end

NS_ASSUME_NONNULL_END
