//  pwner
//
//  Created by Summit on 10/1/20.
//  Copyright © 2020 Summit. All rights reserved.
//

#include <stdio.h>
#include "main.h"
#include <UIKit/UIKit.h>
#include "fishhook.h"
#include "BypassAntiDebugging.h"
#import "grant_full_disk_access.h"
#include <objc/runtime.h>

@implementation PatchEntry

+ (void)load {
    disable_pt_deny_attach();
    disable_sysctl_debugger_checking();
        
    #if TESTS_BYPASS
    test_aniti_debugger();
    #endif
}

__attribute__((constructor))
static void initializer(void) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIViewController* main =  UIApplication.sharedApplication.windows.firstObject.rootViewController;
        while (main.presentedViewController != NULL && ![main.presentedViewController isKindOfClass: [UIAlertController class]]) {
            main = main.presentedViewController;
        }
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Exploiting"
                                                                       message:@"This will take some time..." preferredStyle:UIAlertControllerStyleAlert];
        [main presentViewController:alert animated:YES completion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                grant_full_disk_access(^(NSError* _Nullable error){
                    if (error) {
                        NSLog(@"Error: %@", error);
                    } else {
                        NSLog(@"Success!");
                    }
                });
                [alert dismissViewControllerAnimated:YES completion:^{ }];
                UIAlertController* alert2 = [UIAlertController alertControllerWithTitle:@"Notice"
                                                                               message:@"SummitFilza is brought to you by the work of Summit. We are not responsable for anything bad happening to your device, to the extent of applicable law." preferredStyle:UIAlertControllerStyleAlert];
                [alert2 addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                    [alert2 dismissViewControllerAnimated:YES completion:^{ }];
                }]];
                [main presentViewController:alert2 animated:YES completion:nil];
            });
        }];
    });
    
}

@end
