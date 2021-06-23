//
//  LBSKeyChainUtil.h
//  iOS-Demo
//
//  Created by lbs on 2021/6/23.
//  Copyright © 2021 LBS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/// 系统keychain操作工具类。可以存储
@interface LBSKeyChainUtil : NSObject

/// 保存数据。返回成功与否
/// @param data 需要存的数据（内部会归档）。其实传空的时候也相当于delete
/// @param identifier 数据唯一标识
+ (BOOL)saveData:(nullable id)data forIdentifier:(NSString *)identifier;

/// 读取数据。返回的数据是经过解档的。
/// @param identifier 数据唯一标识
+ (nullable id)queryDataWithIdentifier:(NSString *)identifier;

/// 更新数据。返回成功与否。
/// @param data 需要存的数据（内部会归档）
/// @param identifier 数据唯一标识
+ (BOOL)updateData:(nullable id)data forIdentifier:(NSString *)identifier;

/// 删除数据。返回成功与否
/// @param identifier 数据唯一标识
+ (BOOL)deleteDataWithIdentifier:(NSString *)identifier;


@end

NS_ASSUME_NONNULL_END
