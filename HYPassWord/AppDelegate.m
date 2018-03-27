//
//  AppDelegate.m
//  HYPassWord
//
//  Created by Young on 2018/2/5.
//  Copyright © 2018年 Young. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
//    m_viewcontroller = [[ViewController alloc]init];
//    [m_viewcontroller viewDidLoad];
    NSLog(@"222");

}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}
#pragma menu action

//-(void)attachview:(ViewController *)view
//{
//    m_viewcontroller = view;
//}

-(IBAction)openDocument:(id)sender
{
    NSLog(@"opencamera");
    [m_viewcontroller openCapture:nil];
}

-(IBAction)takepic:(id)sender
{
    NSLog(@"takepic");
    [m_viewcontroller takecapture:nil];// 根据设备输出获得链接
}

-(IBAction)closeDocument:(id)sender
{
    NSLog(@"closecamera");
    @try {
        [m_viewcontroller closeCapture:nil];

    } @catch (NSException *exception) {
        
    } @finally {
        
    }
    
}

@end
