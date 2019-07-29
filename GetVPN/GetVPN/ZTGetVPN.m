//
//  ZTGetVPN.m
//  test090
//
//  Created by zhang teng on 2019/7/29.
//  Copyright © 2019 zhang teng. All rights reserved.
//

#import "ZTGetVPN.h"


#include <CommonCrypto/CommonCrypto.h>

@implementation ZTGetVPN

- (instancetype)init {
    
    if (self = [super init]) {
        NSArray *urlArr = @[@"https://www.passion123.live/myapi/egetinfo?&platform=ios&ver=1.9.30&unicode=6EE114FD-8A13-416F-B9F1-A13D62B6BAE3&deviceid=6EE114FD-8A13-416F-B9F1-A13D62B6BAE3&code=LNXYI1L&recomm_code=E9EPEMW&device_token=4ae4986386da607305b9a993a3eba209cafbf2c791871fd03ab33a4917cb4777&f=2019-06-10&install=2019-06-10&xf_fans=0&token=&t=1564386582.0160542",
        @"https://www.passion123.live/api/elinks?&platform=ios&ver=1.9.30&unicode=6EE114FD-8A13-416F-B9F1-A13D62B6BAE3&deviceid=6EE114FD-8A13-416F-B9F1-A13D62B6BAE3&code=LNXYI1L&recomm_code=E9EPEMW&device_token=4ae4986386da607305b9a993a3eba209cafbf2c791871fd03ab33a4917cb4777&f=2019-06-10&install=2019-06-10&xf_fans=0&token=&t=1564386582.913467",
        @"https://www.reload123.live/api/eversion?&platform=ios&ver=1.9.30&unicode=6EE114FD-8A13-416F-B9F1-A13D62B6BAE3&deviceid=6EE114FD-8A13-416F-B9F1-A13D62B6BAE3&code=LNXYI1L&recomm_code=E9EPEMW&device_token=4ae4986386da607305b9a993a3eba209cafbf2c791871fd03ab33a4917cb4777&f=2019-06-10&install=2019-06-10&xf_fans=0&token=&t=1564386582.556855"];
        
        
        for (NSString*url in urlArr) {
           NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
           NSString *datestr = [NSString stringWithFormat:@"%.6f",time];
            NSString *url2 = url;
            if ([url hasSuffix:@"t=1564386582.556855"]) {
                url2 = [url stringByReplacingOccurrencesOfString:@"t=1564386582.556855" withString:datestr];
            }
            
            
            NSString* res = [self getOne:url2];
            NSLog(@"解密结果：%@",res);
            if ([res hasPrefix:@"ss://"]) {
                
                self.sslstr = res;
                
//                UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
//                pasteboard.string = res;
                
            }
        }
        

    }
    return self;
}

- (NSString*)getOne:(NSString*)urlstr {
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    __block NSString *result = @"";
    
    NSURL *URL = [NSURL URLWithString:urlstr];
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:URL];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    
    
    NSURLSessionDataTask*task = [session dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *string = @"";

        if (data && data.length > 0) {
           string = [[NSString alloc] initWithData:data encoding:4];
        }
        
        NSLog(@"%@",string);
        result = string;
        dispatch_semaphore_signal(semaphore);

    }];
    [task resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    result = [self javaDecrypt128AESIM:result];
    return result;
    
}

- (NSString *)javaDecrypt128AESIM:(NSString *)content{
    
    if (!content || content.length == 0) {
        return @"";
    }
    
    NSData *input = [[NSData alloc]initWithBase64EncodedString:content options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    NSUInteger dataLength = input.length;

    
    NSData *keyData = [@"awdtif20190619ti" dataUsingEncoding:NSUTF8StringEncoding];
    size_t decryptSize = dataLength + kCCBlockSizeAES128;
    void *decryptedBytes = malloc(decryptSize);
    size_t actualOutSize = 0;
    
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyData.bytes,
                                          kCCKeySizeAES128,
                                          [@"awdtif20190619ti" UTF8String],
                                          input.bytes,
                                          dataLength,
                                          decryptedBytes,
                                          decryptSize,
                                          &actualOutSize);
    if (cryptStatus == kCCSuccess) {
        NSString *result = [[NSString alloc] initWithData:[NSData dataWithBytesNoCopy:decryptedBytes length:actualOutSize] encoding:NSUTF8StringEncoding];
        if ([[result className] containsString:@"__NSCFConstantString"] || result == nil) {
            return content;
        }else{
            return result;
        }
    }
    free(decryptedBytes);
    return content;
}

@end
