//
//  ViewController.m
//  HYPassWord
//
//  Created by Young on 2018/2/5.
//  Copyright © 2018年 Young. All rights reserved.
//

#import "ViewController.h"
//创建AVCaptureSession对象
//使用AVCaptureDevice的类方法获得要使用的设备
//利用输入设备AVCaptureDevice创建并初始化AVCaptureDeviceInput对象
//初始化输出数据管理对象，看具体输出什么数据决定使用哪个AVCaptureOutput子类
//将AVCaptureDeviceInput、AVCaptureOutput添加到媒体会话管理对象AVCaptureSession中
//创建视频预览图层AVCaptureVideoPreviewLayer并指定媒体会话，添加图层到显示容器中
//调用媒体会话AVCaptureSession的startRunning方法开始捕获，stopRunning方法停止捕捉
//将 捕获的音频或视频数据输出到指定文件
@implementation ViewController
ViewController * m_viewcontroller;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCapture];
    count = 0;
    self.openCaptureBtn.hidden = NO;
    self.captureBtn.hidden = YES;
    NSLog(@"1111");
    // Do any additional setup after loading the view.
//    AppDelegate * app = [[AppDelegate alloc]init];
    [self attachview:self];
    
    self.m_cropview = [[NSImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-80, self.view.frame.size.height/2+80, 300, 300)];
//    self->m_cropview.delegate = self;
    [self.view addSubview:self.m_cropview];
}

-(void)attachview:(ViewController *)view
{
    m_viewcontroller = view;
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

-(void)initCapture
{
    AVCaptureSession *session = [[AVCaptureSession alloc]init];
    self.session = session;
    if([session canSetSessionPreset:AVCaptureSessionPreset1280x720])
    {
        session.sessionPreset =  AVCaptureSessionPreset1280x720;
    }
    AVCaptureDevice *device = nil;
    NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for(AVCaptureDevice * camera in cameras){
//        if(camera.position == AVCaptureDevicePositionFront)
        {
            device = camera;
        }
    }
//    if(!device)
//    {
//        NSLog(@"取得前置摄像头错误");
//        return ;
//    }
    //3 创建
    NSError *error = nil;
    AVCaptureDeviceInput * captureInput = [[AVCaptureDeviceInput alloc]initWithDevice:device error:&error];
    if(error)
    {
        NSLog(@"创建输入数据对象错误");
        return;
    }
    self.captureInput = captureInput;
    //4 创建输出数据对像
    AVCaptureStillImageOutput * imageOutput = [[AVCaptureStillImageOutput alloc]init];
    NSDictionary * setting  = @{AVVideoCodecKey:AVVideoCodecJPEG};
    [imageOutput setOutputSettings:setting];
    self.ImageOutPut = imageOutput;
    if([session canAddInput:captureInput])
    {
        [session addInput:captureInput];
    }
    if([session canAddOutput:imageOutput])
    {
        [session addOutput:imageOutput];
    }
    //5 创建视频流数据对象
//    AVCaptureVideoDataOutput * videoOutPut = [[AVCaptureVideoDataOutput alloc]init];
//    videoOutPut.videoSettings = @{(NSString *)kCVPixelBufferPixelFormatTypeKey:@(kCVPixelFormatType_420YpCbCr8PlanarFullRange)};
//    dispatch_queue_t queue = dispatch_queue_create("LinXunFengSerialQueue", DISPATCH_QUEUE_SERIAL);
//    self.VideoOutPut = videoOutPut;
//    [videoOutPut setSampleBufferDelegate:self queue:queue];
//    
//    // 给会话添加输出对象
//    if([self.session canAddOutput:videoOutPut])
//    {
//        [self.session addOutput:videoOutPut];
//    }
    
    //6 创建视频预览涂层
    AVCaptureVideoPreviewLayer *videoLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:session];
    self.view.layer.masksToBounds = YES;
    videoLayer.frame = self.view.bounds;
    videoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    //插入图层在拍照按钮的下方
    [self.view.layer insertSublayer:videoLayer below:self.captureBtn.layer];
    self.captureLayer = videoLayer;
    

}

#pragma mark tap
-(IBAction)takecapture:(id)sender// 根据设备输出获得链接
{
//    [[self.ImageOutPut connectionWithMediaType:AVMediaTypeVideo]setEnabled:YES];
    AVCaptureConnection * connection = [self.ImageOutPut connectionWithMediaType:AVMediaTypeVideo];//
    //2通过链接获得设备输出的数据
    [self.ImageOutPut captureStillImageAsynchronouslyFromConnection:connection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer,NSError *error){
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        image = [[NSImage alloc]initWithDataIgnoringOrientation:imageData];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH-mm-ss-SSS"];
        NSString * timedate = [dateFormatter stringFromDate:[NSDate date]];
        strfile = [[NSString stringWithFormat:@"~/Documents/%@_%d.png",timedate,count]stringByExpandingTildeInPath];
        BOOL y = [imageData writeToFile:strfile atomically:YES];
            count = count + 1;
        NSLog(@"save iamge:%d",count);
       if(y)
       {
           self.captureLayer.hidden = YES;
           self.captureBtn.hidden = NO;
           self.openCaptureBtn.hidden = YES;

       }
//        [self.session stopRunning];
         }];
}
    

-(IBAction)openCapture:(id)sender
{
    self.captureLayer.hidden = NO;
    self.captureBtn.hidden = NO;
    self.openCaptureBtn.hidden = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        dispatch_async(dispatch_get_main_queue(), ^{
    [self.m_cropview setNeedsDisplay:NO];
    [self.session startRunning];
    });
}
#define CMD_STR_LEN 1024

-(IBAction)closeCapture:(id)sender
{
    if(self.session)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDate *start = [NSDate date];
            
//            [self stopRunning];
            [self.session stopRunning];

            NSLog(@"time took: %f", -[start timeIntervalSinceNow]);
            
            // *** Here is the key, make your segue on the main thread
            dispatch_async(dispatch_get_main_queue(), ^{
//                [self performSegueWithIdentifier:@"segueFromFoundQRCode" sender:self];
//                _labelTestName.text = _testName;
                self.openCaptureBtn.hidden = NO;
//                [self.m_cropview setImage:image];
//                self->m_cropview.image = @"/Users/gdlocal/Desktop/1.jpg";//image;
//                self.m_cropview.image = [NSImage imageNamed:@"/Users/gdlocal/Desktop/1.jpg"];
//                [self.m_cropview setCropRect:self.view.frame];
                NSImage * imagetemp = [[NSImage alloc]initWithContentsOfFile:strfile];
                
                self.m_cropview.image = [[NSImage alloc]initWithContentsOfFile:strfile];
                self.m_cropview.imageScaling = NSImageScaleAxesIndependently;
                self.m_cropview.wantsLayer = YES;
                self.m_cropview.layer.masksToBounds = YES;
                //                self.m_cropview.layer.cornerRadius = 80.f;
                //                self.m_cropview.layer.borderWidth = 3.0;
                self.m_cropview.layer.borderColor = [[NSColor redColor]CGColor];

                //
//                char * tmp = "/Users/gdlocal/Desktop/test.txt";
//                [self mysystem:"ping 127.0.0.1" temp:tmp];
//                int a = system("help");
//                NSLog(@"********%d",a);
//                [self mysystem1];
            });
            
        });

//        [self.session stopRunning];
    }
}

-(int)mysystem:(char*)cmdstring temp:(char*)tmpfile
{
    char cmd_string[CMD_STR_LEN];
//    tmpnam(tmpfile);
    mktemp(tmpfile);
    sprintf(cmd_string, "%s > %s", cmdstring, tmpfile);
    return system(cmd_string);
}
-(int)mysystem1
{
    FILE   *stream;
    FILE   *wstream;
    char   buf[1024];
    
    memset( buf, '\0', sizeof(buf) );//初始化buf,以免后面写如乱码到文件中
    stream = popen( "ls -l", "r" ); //将“ls －l”命令的输出 通过管道读取（“r”参数）到FILE* stream
    wstream = fopen( "/Users/gdlocal/Desktop/test_popen.txt", "w+"); //新建一个可写的文件
    
    fread( buf, sizeof(char), sizeof(buf), stream); //将刚刚FILE* stream的数据流读取到buf中
    fwrite( buf, 1, sizeof(buf), wstream );//将buf中的数据写到FILE    *wstream对应的流中，也是写到文件中
    
    pclose( stream );
    fclose( wstream );
    
    return 0;
}
@end



















