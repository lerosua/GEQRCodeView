//
//  GEQRViewController.m
//  Game5253
//
//  Created by lerosua on 14-6-12.
//  Copyright (c) 2014年 duowan. All rights reserved.
//

#import "GEQRViewController.h"
#import "XHScanningView.h"
#import "XHCaptureHelper.h"
#import "ZBarSDK.h"


@import AVFoundation;

#define CURRENT_SYS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define is4Inch()               ([[UIScreen mainScreen] bounds].size.height == 568)
#define isNoLessThanIOS7        ([[[UIDevice currentDevice] systemVersion] floatValue] >=7.0 ? YES : NO)
#define ScreenHeight            [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth             [[UIScreen mainScreen] bounds].size.width
#define GEStatusBarOffet        ([[[UIDevice currentDevice] systemVersion] floatValue] >=7.0 ? 20 : 0)

@interface GEQRViewController ()<AVCaptureMetadataOutputObjectsDelegate,ZBarReaderViewDelegate,UIAlertViewDelegate>
@property (nonatomic,strong) AVCaptureSession *captureSession;
@property (nonatomic,strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property (nonatomic,strong) XHScanningView *scanningView;
@property (nonatomic,strong) UIView *preview;
@property (nonatomic,strong) UIView *userview;
@property (nonatomic,strong) XHCaptureHelper *captureHelper;
@property (nonatomic,assign) BOOL isReading;
@property (nonatomic,strong) UIActivityIndicatorView *activityView;

@property (nonatomic,strong) ZBarReaderView *zbarReaderView;
@property (nonatomic,assign) BOOL isInit;
@end

@implementation GEQRViewController

- (XHCaptureHelper *)captureHelper {
    if (!_captureHelper) {
        _captureHelper = [[XHCaptureHelper alloc] init];
        __weak __typeof__(self) weakSelf = self;
        [_captureHelper setDidOutputSampleBufferHandle:^(NSString *urlString) {
            // 这里可以做子线程的QRCode识别
            [weakSelf.delegate qrReaderViewController:weakSelf didFinishPickingInformation:urlString ];

        }];
    }
    return _captureHelper;
}
- (UIView *)preview {
    if (!_preview) {
        _preview = [[UIView alloc] initWithFrame:self.view.bounds];
    }
    return _preview;
}

- (UIView *)userview
{
    if(!_userview){
        _userview = [[UIView alloc] initWithFrame:self.view.bounds];
    }
    return _userview;
}

- (UIActivityIndicatorView *)activityView
{
    if(!_activityView){
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityView.center = CGPointMake(self.view.center.x, self.view.center.y-60+GEStatusBarOffet);
        [self.userview addSubview:_activityView];
    }
    return _activityView;
}

- (XHScanningView *)scanningView {
    if (!_scanningView) {
        _scanningView = [[XHScanningView alloc] initWithFrame:CGRectMake(0, (CURRENT_SYS_VERSION >= 7.0 ? 64 : 0), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - (CURRENT_SYS_VERSION >= 7.0 ? 64 : 0))];
    }
    return _scanningView;
}
- (ZBarReaderView *) zbarReaderView
{
    if(!_zbarReaderView){
        _zbarReaderView = [ZBarReaderView new];
        _zbarReaderView.frame = self.view.bounds;
        _zbarReaderView.readerDelegate = self;
        _zbarReaderView.allowsPinchZoom = NO;
        [self.preview addSubview:_zbarReaderView];
    }
    return _zbarReaderView;
}

#pragma mark -
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.preview];
    [self.view addSubview:self.scanningView];
    [self.view addSubview:self.userview];
    [self setupNarBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if(isNoLessThanIOS7){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{

                    if ([self isCameraAuthorized]) {
                        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                            [self startAppleQRReader];
                        }else{
                            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"相机不可用。" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                            alertView.delegate = self;
                            [alertView show];
                        }
                    }
                });
            }else{

                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请在iPhone的\"设置-隐私-相机\"选项中,允许Game5253访问您的相机。" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                    alertView.delegate = self;
                    [alertView show];
                });


            }
        }];
    }else{
        [self startZBarQRReader];
    }
    

    
}

- (BOOL) shouldAutorotate
{
    return NO;
}

#pragma mark -
static const NSInteger kZBarLabelFontSize = 20;
- (void) setupNarBar
{
    CGFloat offetY = GEStatusBarOffet;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(80, offetY + 4, 160, 40)];
    label.text = @"扫一扫";
    label.font = [UIFont systemFontOfSize:kZBarLabelFontSize];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, offetY, 50, 50)];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_topbar_back_white"] forState:UIControlStateNormal];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn_topbar_back_hover"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(qrReaderViewDimiss:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44+offetY)];
    topBar.backgroundColor = [UIColor grayColor];
    [topBar addSubview:backButton];
    [topBar addSubview:label];
    
    [self.userview addSubview:topBar];
}
#pragma mark -

- (BOOL)startReading {
    _isReading = YES;
    NSError *error;
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    // Set the input device on the capture session.
    [_captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    // Create a new serial dispatch queue.
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    
    //    if (self.qrcodeFlag)
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    //    else
    //        [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode, nil]];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:self.view.layer.bounds];
    [self.view.layer addSublayer:_videoPreviewLayer];
    
    [self.view bringSubviewToFront:self.scanningView];
    
    [_captureSession startRunning];
    
    return YES;
}


-(void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;
    [_videoPreviewLayer removeFromSuperlayer];

}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects
      fromConnection:(AVCaptureConnection *)connection
{
    if (!_isReading) return;
    
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        
        NSString *urlString = [metadataObj stringValue];
        NSLog(@"get url %@", urlString);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self stopReading];
                [self.delegate qrReaderViewController:self didFinishPickingInformation:urlString ];
            
        });

    }
}

- (void) qrReaderViewDimiss:(id)sender
{
    [self stopReading];
    [self.delegate qrReaderDismiss:self];
}

#pragma mark - 
- (void) startAppleQRReader
{
    if(!_isInit){
        _isInit = YES;
        [self.activityView startAnimating];
        __weak __typeof__(self) weakSelf = self;
        [self.captureHelper showCaptureOnView:self.preview  complete:^{
            [weakSelf.activityView stopAnimating];
            [weakSelf.scanningView scanning];
        }];
    }
}
- (void) startZBarQRReader
{
    if(!_isInit){
        _isInit = YES;
        [self.activityView startAnimating];
        [self.zbarReaderView start];
    }
}

- (void) readerViewDidStart: (ZBarReaderView*) readerView
{
    [self.activityView stopAnimating];
    [self.scanningView scanning];
}
- (void) readerView: (ZBarReaderView*) readerView
     didReadSymbols: (ZBarSymbolSet*) symbols
          fromImage: (UIImage*) image
{
    const zbar_symbol_t *symbol = zbar_symbol_set_first_symbol(symbols.zbarSymbolSet);
    NSString *symbolStr = [NSString stringWithUTF8String: zbar_symbol_get_data(symbol)];
    
    
    if (zbar_symbol_get_type(symbol) == ZBAR_QRCODE) {  // 是否QR二维码
        [self.zbarReaderView stop];
        NSString *urlString = symbolStr;
        [self.delegate qrReaderViewController:self didFinishPickingInformation:urlString ];
    }
}


- (BOOL) isCameraAuthorized
{
    if(isNoLessThanIOS7){
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if(authStatus == AVAuthorizationStatusAuthorized){
            return YES;
        }else if (authStatus == AVAuthorizationStatusDenied){
            return NO;
        }else
            return YES;
    }else{
        return YES;
    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        [self dismissViewControllerAnimated:YES completion:nil];
}
@end
