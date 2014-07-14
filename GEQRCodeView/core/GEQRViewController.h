//
//  GEQRViewController.h
//  Game5253
//
//  Created by lerosua on 14-6-12.
//  Copyright (c) 2014年 duowan. All rights reserved.
//

//#import "GEViewController.h"

@protocol QRReaderDelegate <NSObject>

- (void) qrReaderViewController:(UIViewController *)view didFinishPickingInformation:(NSString *)info;
- (void) qrReaderDismiss:(UIViewController *)view;
@end

@interface GEQRViewController : UIViewController

@property (nonatomic,weak) id<QRReaderDelegate> delegate;
@end
