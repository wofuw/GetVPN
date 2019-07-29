//
//  ViewController.m
//  test090
//
//  Created by zhang teng on 2019/7/29.
//  Copyright © 2019 zhang teng. All rights reserved.
//

#import "ViewController.h"
#include <CommonCrypto/CommonCrypto.h>

#import <YYKit.h>
#import "ZTGetVPN.h"

@interface ViewController ()

@property ( nonatomic) IBOutlet UILabel *label;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
//    [self test];
    
    ZTGetVPN*vpn =  [ZTGetVPN new];
    
    self.label.text = vpn.sslstr;

}

- (void)test {
    NSString *value = @"p55JzUDTGO/RdhL5hyIXwv07FCdf99XS7Rw+kaGnKpvH6z2PygOMcxoHduLqHb0N/yVJmjSH4aWd80Jt8q6Nd8427pPD8fHQiLDyOvxYrZhRkWZ9CZtgAUfS95AmtVxr";
    
    NSString *result222 = [self javaDecrypt128AESIM:value];
 
    NSLog(@"结果=%@",result222);
}
- (NSString *)javaDecrypt128AESIM:(NSString *)content{

    NSData *input = [[NSData alloc]initWithBase64EncodedString:content options:NSDataBase64DecodingIgnoreUnknownCharacters];

    NSUInteger dataLength = input.length;

    
//    NSData *input = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"adata"];
//    id bb = [[NSString alloc] initWithData:input encoding:16];
//
//    NSString *base64 = [input base64EncodedString];
//
//    NSLog(@"value=%@",bb);
//    NSUInteger dataLength = input.length;

    
//    NSData *input = [NSData dataWithHexString:content];
//    NSUInteger dataLength = input.length;

    
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
