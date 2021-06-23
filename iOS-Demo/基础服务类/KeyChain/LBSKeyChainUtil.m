//
//  LBSKeyChainUtil.m
//  iOS-Demo
//
//  Created by lbs on 2021/6/23.
//  Copyright © 2021 LBS. All rights reserved.
//

#import "LBSKeyChainUtil.h"
#import <Security/Security.h>

@implementation LBSKeyChainUtil

/// 根据特定的Service创建一个用于操作KeyChain的Dictionary
+ (NSMutableDictionary *)_keyChainQueryDictionaryWithIdentifier:(NSString *)identifier {
    NSMutableDictionary *keyChainQueryDictaionary = [[NSMutableDictionary alloc]init];
    // 通用密码类型
    [keyChainQueryDictaionary setObject:(id)kSecClassGenericPassword forKey:(id)kSecClass];
    [keyChainQueryDictaionary setObject:identifier forKey:(id)kSecAttrService];
    [keyChainQueryDictaionary setObject:identifier forKey:(id)kSecAttrAccount];
    return keyChainQueryDictaionary;
}


/// 保存数据
/// @param data 需要存的数据（内部会归档）
+ (BOOL)saveData:(nullable id)data forIdentifier:(NSString *)identifier {
    // 获取存储的数据的条件
    NSMutableDictionary *keychainQuery = [self _keyChainQueryDictionaryWithIdentifier:identifier];
    // 删除旧的数据
    SecItemDelete((CFDictionaryRef)keychainQuery);
    // 设置新的数据
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    // 添加数据
    OSStatus status= SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
    if (status == noErr) {
        return YES;
    }
    return NO;
}


/// 读取数据
+ (id)queryDataWithIdentifier:(NSString *)identifier {
    id result;
    NSMutableDictionary *keyChainQuery = [self _keyChainQueryDictionaryWithIdentifier:identifier];
    // 查询结果返回到 kSecValueData
    [keyChainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    // 只返回搜索到的第一条数据
    [keyChainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    // 创建一个数据对象
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keyChainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            result = [NSKeyedUnarchiver  unarchiveObjectWithData:(__bridge NSData *)keyData];
        }
        @catch (NSException *exception) {
            NSLog(@"不存在数据");
        }
        @finally {
            
        }
    }
    if (keyData) {
        CFRelease(keyData);
    }
    return result;
}


/// 更新数据
+ (BOOL)updateData:(nullable id)data forIdentifier:(NSString *)identifier {
    // 通过标记获取数据更新的条件
    NSMutableDictionary *searchDictionary = [self _keyChainQueryDictionaryWithIdentifier:identifier];
    
    if (!searchDictionary) {
        return NO;
    }
    // 创建更新数据字典
    NSMutableDictionary *updateDictionary = [[NSMutableDictionary alloc] init];
    // 存储数据
    [updateDictionary setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    // 获取存储的状态
    OSStatus status = SecItemUpdate((CFDictionaryRef)searchDictionary,
                                    (CFDictionaryRef)updateDictionary);
    if (status == errSecSuccess) {
        return YES;
    }
    return NO;
}


/// 删除数据
+ (BOOL)deleteDataWithIdentifier:(NSString *)identifier {
    NSMutableDictionary *keyChainDictionary = [self _keyChainQueryDictionaryWithIdentifier:identifier];
    OSStatus status = SecItemDelete((CFDictionaryRef)keyChainDictionary);
    if (status == noErr) {
        return YES;
    }
    return NO;
}
@end
