//
//  ViewController.m
//  GetVPN
//
//  Created by zhang teng on 2019/7/29.
//  Copyright © 2019 zhang teng. All rights reserved.
//

#import "ViewController.h"
#import "ZTGetVPN.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    self.textVIew.textColor = [NSColor blackColor];
    self.textVIew.font = [NSFont systemFontOfSize:15];
}
- (IBAction)GetVPNbuttonAction:(NSButtonCell *)sender {
    
    ZTGetVPN *vpnModel = [ZTGetVPN new];
    
    if (vpnModel.sslstr.length > 0) {
        self.textVIew.string = vpnModel.sslstr;
        
        NSPasteboard*pasteboard = [NSPasteboard generalPasteboard];
        [pasteboard clearContents];  //必须清空，否则setString会失败。
        [pasteboard setString:vpnModel.sslstr forType:NSStringPboardType];
        
        
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"提示"];
        [alert setInformativeText:@"已复制到剪切板"];
        [alert addButtonWithTitle:@"确定"];
        [alert setAlertStyle:NSAlertStyleWarning];
        NSUInteger action = [alert runModal];
        //响应window的按钮事件
        if(action == NSAlertFirstButtonReturn) //1000
        {
            NSLog(@"OK");
        }
    }
    

    
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}
- (IBAction)closeBtnAction:(id)sender {
    
    exit(0);
    
}


@end
