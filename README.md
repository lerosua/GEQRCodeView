GEQRCodeView
===============

GEQRCodeView是一个简单的二维码扫描ViewController。简单易用。在ios7下使用apple提供的SDK扫描二维码，快速。为了兼容ios6，又将zbar集成进来。根据版本不同切换不同的引擎。


## Podfile
[CocosPods](http://cocosPods.org) is the recommended method to install DWZShareKit, just add the following line to `Podfile`

```
pod 'GEQRCodeView'
```

## How to Use
在将要打开二维码扫描的ViewController里继承QRReaderDelegate协议，并实现以下方法

```objc
#pragma mark - qrReader delegate
- (void) qrReaderViewController:(UIViewController *)view didFinishPickingInformation:(NSString *)info
{
    [view dismissViewControllerAnimated:YES completion:^{
        
        //todo...
        
    }];
}
- (void) qrReaderDismiss:(UIViewController *)view
{
    [view dismissViewControllerAnimated:YES completion:nil];
}

```

打开二维码界面
```objc
    GEQRViewController *viewController = [[GEQRViewController alloc] init];
    viewController.delegate = self;
    [self presentViewController:viewController animated:YES completion:nil];
```

## License

中文: GERQCodeView 是在MIT协议下使用的，可以在LICENSE文件里面找到相关的使用协议信息。

English: GERQCodeView is available under the MIT license, see the LICENSE file for more information.
