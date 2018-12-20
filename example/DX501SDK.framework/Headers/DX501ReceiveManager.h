//
//  DX501ReceiveManager.h
//  DX501SDK
//
//  Copyright © CAR MATE MFG.CO.,LTD. All Rights Reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/**
 *  デリゲート　値の更新を取得する（速度、回転数、スロットル開度）
 */
@protocol DX501ReceiveDelegate <NSObject>

@required
// 接続した時に呼ばれる
- (void)didConnectToDX501;
// 切断した時に呼ばれる
- (void)didDisConnectToDX501;
// BLEスキャン開始
- (void)bleScanStart;
// データ受信開始
- (void)startBroadcastData;
// エラー通知
- (void)errorMessage:(NSString *)errorMsg;

@optional
/*------------------------------------*/
/* ブロードキャスト情報の受信              */
/*------------------------------------*/

// MARK:積算データ（今回の走行開始から累積した値）
// 走行距離[m] 今回の走行開始から累積した走行距離
- (void)didUpdateTravelDistance:(unsigned long)travelDistance;
// 燃料消費量[ml] 今回の走行開始から累積した燃料消費量
- (void)didUpdateCumulationFuel:(unsigned long)cumulationFuel;
// アイドリング時間[s]
- (void)didUpdateIdlingTime:(unsigned long)idlingTime;
// 平均速度[km/h]
- (void)didUpdateAverageSpeed:(unsigned long)averageSpeed;
// 燃料カット走行距離[m]
- (void)didUpdateCutFuelMileage:(unsigned long)cutFuelMileage;
// エコスタート回数
- (void)didUpdateEcoStartCount:(unsigned long)ecoStartCount;
// 発進停止回数
- (void)didUpdateStartStopCount:(unsigned long)startStopCount;
// アイドリングストップ時間[s]
- (void)didUpdateIdlingStopTime:(unsigned long)idlingStopTime;
// エコドライブ時間[s]
- (void)didUpdateEcoDriveTime:(unsigned long)ecoDriveTime;
// 最高速度[km/h]
- (void)didUpdateMaximumSpeed:(unsigned long)maximumSpeed;
// 最高回転数[rpm]
- (void)didUpdateMaximumEngineRotation:(unsigned long)maximumEngineRotation;
// 走行時間[s]
- (void)didUpdateDrivingTime:(unsigned long)drivingTime;

// MARK:瞬間データ（リアルタイムの値）
// 瞬間燃費[m/μℓ] 約１秒間の走行距離と燃料消費量から算出した燃費
- (void)didUpdateFuelEfficiency:(double)fuelEfficiency;
// 速度[km/h]
- (void)didUpdateSpeed:(double)speed;
// 回転数[rpm]
- (void)didUpdateRpm:(double)rpm;
// スロットルポジション[0~100 %]
- (void)didUpdateThrottlePosition:(double)throttlePosition;
// 水温[摂氏]
- (void)didUpdateWaterTemperature:(double)WaterTemperature;

// MARK:累積データ（DX501をOBDコネクタに接続してから累積した値）
// 累積走行距離[m] DX501をOBDコネクタに接続してから累積した走行距離
- (void)didUpdateLifetimeTravelDistance:(unsigned long)lifetimeTravelDistance;
// 累積燃料消費量[ml] DX501をOBDコネクタに接続してから累積した燃料消費量
- (void)didUpdateLifetimeCumulationFuel:(unsigned long)lifetimeCumulationFuel;
/*------------------------------------*/


@end





@interface DX501ReceiveManager : NSObject

/**
 *  DX501ReceiveDelegateオブジェクト
 */
@property (nonatomic, weak) id<DX501ReceiveDelegate> delegate;

/**
 *  DX501ReceiveManagerのインスタンスを返す
 *　シングルトン関数
 *
 *  @return DX501ReceiveManagerのインスタンス
 */
+ (DX501ReceiveManager *)sharedManager;

/**
 セットする項目のデータセットのタイプ
 */
typedef enum : NSUInteger {
    DataSet_Default,                           // デフォルト　速度 3Hz, 回転数 3Hz, スロットル開度 3Hz、その他 1Hz
    DataSet_Speed9,                            // 速度 9Hz、その他 1Hz
    DataSet_RPM9,                              // 回転数 9Hz、その他 1Hz
    DataSet_ThrottlePosition9,                 // スロットル開度 9Hz、その他 1Hz
    DataSet_Speed5_RPM5,                       // 速度 5Hz, 回転数 5Hz、その他 1Hz
    DataSet_Speed5_ThrottlePosition5,          // 速度 5Hz, スロットル開度 5Hz、その他 1Hz
    DataSet_RPM5_ThrottlePosition5,            // 回転数 5Hz, スロットル開度 5Hz、その他 1Hz
} DataSetType;
/**
 *  接続しデータの受信を開始する
 *
 *  @param dataSetType セットする項目のデータセットのタイプ
 */
- (void)connectToDX501:(DataSetType)dataSetType;

/**
 *  接続を切断する
 */
- (void)disconnectFromDX501;

@end
