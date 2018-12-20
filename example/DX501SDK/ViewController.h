//
//  ViewController.h
//  DX501SDK
//
//  Copyright © CAR MATE MFG.CO.,LTD. All Rights Reserved.
//

#import <UIKit/UIKit.h>

// DX501SDKのDX501ReceiveManager.hを読み込む
#import <DX501SDK/DX501ReceiveManager.h>


// DX501ReceiveDelegateをセットする
@interface ViewController : UIViewController <DX501ReceiveDelegate>


@end
