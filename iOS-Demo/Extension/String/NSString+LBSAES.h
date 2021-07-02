//
//  NSString+LBSAES.h
//  iOS-Demo
//
//  Created by lbs on 2021/6/23.
//  Copyright © 2021 LBS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (LBSAES)

/// AES128加密
- (NSString*)lbs_encryptWithAES;

/// AES128解密
- (NSString*)lbs_decryptWithAES;

@end

NS_ASSUME_NONNULL_END
