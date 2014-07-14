//
//  GEQRViewController.m
//  GEQRCodeView
//
//  Created by lerosua on 14-7-14.
//  Copyright (c) 2014年 lerosua. All rights reserved.
//

#import "GEQRDemoViewController.h"
#import "GEQRViewController.h"

@interface GEQRDemoViewController ()<QRReaderDelegate>

- (IBAction)openQRView:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@end

@implementation GEQRDemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)openQRView:(id)sender {
    GEQRViewController *viewController = [[GEQRViewController alloc] init];
    viewController.delegate = self;
    [self presentViewController:viewController animated:YES completion:nil];
}

#pragma mark - qrReader delegate
- (void) qrReaderViewController:(UIViewController *)view didFinishPickingInformation:(NSString *)info
{
    [view dismissViewControllerAnimated:YES completion:^{
        
        self.resultLabel.text = info;

    }];
}
- (void) qrReaderDismiss:(UIViewController *)view
{
    [view dismissViewControllerAnimated:YES completion:nil];
}
@end
