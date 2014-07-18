//
//  GEQRCode.h
//  GEQRCodeView
//
//  Created by lerosua on 14-7-18.
//  Copyright (c) 2014年 lerosua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GEQRCode : NSObject

+ (UIImage *) generateQRCode:(NSString *) codeString withScale:(CGFloat) scale;

@end
