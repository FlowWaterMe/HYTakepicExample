//
//  AppDelegate.h
//  HYPassWord
//
//  Created by Young on 2018/2/5.
//  Copyright © 2018年 Young. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>
#import "ViewController.h"
extern ViewController * m_viewcontroller;

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
//   ViewController * m_viewcontroller;
}
//   ViewController * m_viewcontroller;

-(void)attachview:(ViewController *)view;

@end

