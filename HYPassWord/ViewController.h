//
//  ViewController.h
//  HYPassWord
//
//  Created by Young on 2018/2/5.
//  Copyright © 2018年 Young. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreImage/CoreImage.h>
#import "cropview.h"
@interface ViewController : NSViewController<CropViewDelegate>
{
    int count;
    NSString * strfile;
    NSImage * image;
//    IBOutlet NSImageView *m_cropview;
}
@property(strong,nonatomic)IBOutlet NSImageView *m_cropview;

//@property(strong,nonatomic)cropview *mm_cropview;

@property(strong,nonatomic)AVCaptureSession *session;
@property(strong,nonatomic)AVCaptureDeviceInput *captureInput;
@property(strong,nonatomic)AVCaptureStillImageOutput *ImageOutPut;//单张静态影像的截取
@property(strong,nonatomic)AVCaptureVideoDataOutput *VideoOutPut;
@property(strong,nonatomic)AVCaptureVideoPreviewLayer * captureLayer;//视频预览图层
@property(strong,nonatomic)IBOutlet NSButton * captureBtn;
 //拍照按钮
 @property(strong,nonatomic)IBOutlet NSButton * openCaptureBtn;//打开摄像头按钮
-(IBAction)openCapture:(id)sender;
-(IBAction)takecapture:(id)sender;// 根据设备输出获得链接
-(IBAction)closeCapture:(id)sender;
-(int)mysystem:(char*)cmdstring temp:(char*)tmpfile;
-(int)mysystem1;
@end

