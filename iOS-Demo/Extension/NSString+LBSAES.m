//
//  NSString+LBSAES.m
//  iOS-Demo
//
//  Created by lbs on 2021/6/23.
//  Copyright © 2021 LBS. All rights reserved.
//

#import "NSString+LBSAES.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

static NSString *const PSW_AES_KEY = @"TESTPASSWORD";
static NSString *const AES_IV_PARAMETER = @"AES00IVPARAMETER";

@implementation NSString (LBSAES)

// base128加密
- (NSString*)lbs_encryptWithAES {
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *AESData = [self AES128operation:kCCEncrypt
                                       data:data
                                        key:PSW_AES_KEY
                                         iv:AES_IV_PARAMETER];
    NSString *baseStr = [AESData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return baseStr;
}

/// base128解密
- (NSString*)lbs_decryptWithAES {
    NSData *baseData = [[NSData alloc]initWithBase64EncodedString:self options:0];
    
    NSData *AESData = [self AES128operation:kCCDecrypt
                                       data:baseData
                                        key:PSW_AES_KEY
                                         iv:AES_IV_PARAMETER];
    NSString *decStr = [[NSString alloc] initWithData:AESData encoding:NSUTF8StringEncoding];
    return decStr;
}

/**
 *  AES加解密算法
 *
 *  @param operation kCCEncrypt（加密）kCCDecrypt（解密）
 *  @param contentData      待操作Data数据
 *  @param key       key
 *  @param iv        向量
 */
- (NSData *)AES128operation:(CCOperation)operation data:(NSData *)contentData key:(NSString *)key iv:(NSString *)iv {
    
    NSUInteger dataLength = contentData.length;
    // 为结束符'\\0' +1
    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    // 密文长度 <= 明文长度 + BlockSize
    size_t encryptSize = dataLength + kCCBlockSizeAES128;
    void *encryptedBytes = malloc(encryptSize);
    size_t actualOutSize = 0;
    NSString *const kInitVector = iv; //16位偏移，CBC模式才有
    NSData *initVector = [kInitVector dataUsingEncoding:NSUTF8StringEncoding];
    CCCryptorStatus cryptStatus = CCCrypt(
    operation,//kCCEncrypt 代表加密 kCCDecrypt代表解密
    kCCAlgorithmAES,//加密算法
    kCCOptionPKCS7Padding,  // 系统默认使用 CBC，然后指明使用 PKCS7Padding，iOS只有CBC和ECB模式，如果想使用ECB模式，可以这样编写  kCCOptionPKCS7Padding | kCCOptionECBMode
    keyPtr,//公钥
    kCCKeySizeAES128,//密钥长度128
    initVector.bytes,//偏移字符串
    contentData.bytes,//编码内容
    dataLength,//数据长度
    encryptedBytes,//加密输出缓冲区
    encryptSize,//加密输出缓冲区大小
    &actualOutSize);//实际输出大小
    if (cryptStatus == kCCSuccess) {
    // 返回编码后的数据
    return [NSData dataWithBytesNoCopy:encryptedBytes length:actualOutSize];
    }
    free(encryptedBytes);
    return nil;
}



@end
