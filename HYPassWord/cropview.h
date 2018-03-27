//
//  cropview.h
//  HYPassWord
//
//  Created by Young on 2018/2/28.
//  Copyright © 2018年 Young. All rights reserved.
//

#import <Cocoa/Cocoa.h>
@protocol CropViewDelegate <NSObject>
@end
@interface cropview : NSImageView
@property NSPoint cropmidpoint;
@property NSRect cropRect;//裁剪矩形 用于显示裁剪区域
@property (retain)id <CropViewDelegate>delegate;

@end
