//
//  ViewController.m
//  DX501SDK
//
//  Copyright © CAR MATE MFG.CO.,LTD. All Rights Reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    DX501ReceiveManager *dx501RecieveManager;
    
    DataSetType dataSetType;
    __weak IBOutlet UIView *baseFrameView;
}

typedef enum {
    rpmViewTag = 111,
    speedViewTag = 222,
    throttlePositionViewTag = 333,
    restartButtonTag = 444,
    progressLabelTag = 555
}viewTagNo;

@end




@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // DX501ReceiveManagerのインスタンス生成
    dx501RecieveManager = [DX501ReceiveManager sharedManager];
    // デリゲートをセット
    dx501RecieveManager.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // データ取得モードはデフォルト
    dataSetType = DataSet_Default;
    // DX501と接続
    [dx501RecieveManager connectToDX501:dataSetType];
    /*
     データ取得モード
     DataSet_Default,                           // デフォルト　速度 3Hz, 回転数 3Hz, スロットル開度 3Hz、その他 1Hz
     DataSet_Speed9,                            // 速度 9Hz、その他 1Hz
     DataSet_RPM9,                              // 回転数 9Hz、その他 1Hz
     DataSet_ThrottlePosition9,                 // スロットル開度 9Hz、その他 1Hz
     DataSet_Speed5_RPM5,                       // 速度 5Hz, 回転数 5Hz、その他 1Hz
     DataSet_Speed5_ThrottlePosition5,          // 速度 5Hz, スロットル開度 5Hz、その他 1Hz
     DataSet_RPM5_ThrottlePosition5,            // 回転数 5Hz, スロットル開度 5Hz、その他 1Hz
     */
    
    // 値を表示するViewを作成
    [self createSampleView];
    // ボタンのUIを更新
    [self updateRestartButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View
// 走行情報をいくつか表示するためのViewを用意
- (void)createSampleView {
    UIView *backGroundView = [baseFrameView viewWithTag:226987];
    if (backGroundView != nil) {
        // viewDidAppearでViewを作成しているため何度も作成しないように！
        return;
    }
    
    backGroundView = [[UIView alloc] initWithFrame:baseFrameView.bounds];
    backGroundView.backgroundColor = [UIColor lightGrayColor];
    [baseFrameView addSubview:backGroundView];
    backGroundView.tag = 226987;
    
    float buttomButtonHeight = 44.f;
    float baseViewHeight = (CGRectGetHeight(baseFrameView.bounds) - buttomButtonHeight)/3;
    UIView *topBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(baseFrameView.bounds), baseViewHeight)];
    topBaseView.backgroundColor = [UIColor colorWithRed:0.4f green:0.4f blue:0.4f alpha:1.0f];
    [baseFrameView addSubview:topBaseView];
    
    UIView *midBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, baseViewHeight, CGRectGetWidth(baseFrameView.bounds), baseViewHeight)];
    midBaseView.backgroundColor = [UIColor colorWithRed:0.35f green:0.35f blue:0.35f alpha:1.0f];
    [baseFrameView addSubview:midBaseView];
    
    UIView *bottomBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, baseViewHeight * 2, CGRectGetWidth(baseFrameView.bounds), baseViewHeight)];
    bottomBaseView.backgroundColor = [UIColor colorWithRed:0.3f green:0.3f blue:0.3f alpha:1.0f];
    [baseFrameView addSubview:bottomBaseView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                  CGRectGetHeight(baseFrameView.bounds) - buttomButtonHeight,
                                                                  CGRectGetWidth(baseFrameView.bounds),
                                                                  buttomButtonHeight)];
    [button addTarget:self action:@selector(restartButtonTouchUp) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"- - -" forState:UIControlStateNormal];
    button.tag = restartButtonTag;
    [baseFrameView addSubview:button];
    [self disableRestartButton];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, CGRectGetWidth(baseFrameView.bounds), 30.f)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"- - -";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:0.f green:0.6f blue:1.0f alpha:1.0f];
    label.minimumScaleFactor = 0.1f;
    label.adjustsFontSizeToFitWidth = YES;
    label.tag = progressLabelTag;
    [baseFrameView addSubview:label];
    
    [self setSampleViewContent:topBaseView TitleStr:@"回転数（rpm）" ValueStr:@"--" MinStr:@"0" MaxStr:@"10000" ID:rpmViewTag];
    [self setSampleViewContent:midBaseView TitleStr:@"速度（km/h）" ValueStr:@"--" MinStr:@"0" MaxStr:@"180" ID:speedViewTag];
    [self setSampleViewContent:bottomBaseView TitleStr:@"スロットル開度（%）" ValueStr:@"--" MinStr:@"0" MaxStr:@"100" ID:throttlePositionViewTag];
}

- (void)setSampleViewContent:(UIView *)baseView TitleStr:(NSString *)titleStr ValueStr:(NSString *)valueStr MinStr:(NSString *)minStr MaxStr:(NSString *)maxStr ID:(NSInteger)idNum{
    float base_w = CGRectGetWidth(baseView.bounds);
    float base_h = CGRectGetHeight(baseView.bounds);
    
    baseView.tag = idNum;
    
    float unit_h = base_h / 6;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(base_w * 0.1, unit_h, base_w * 0.5, unit_h)];
    titleLabel.text = titleStr;
    titleLabel.textColor = [UIColor whiteColor];
    [baseView addSubview:titleLabel];
    
    UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(base_w * 0.1, unit_h * 2, base_w * 0.5, unit_h * 2)];
    valueLabel.text = valueStr;
    valueLabel.textColor = [UIColor whiteColor];
    valueLabel.font = [UIFont boldSystemFontOfSize:50.f];
    [baseView addSubview:valueLabel];
    valueLabel.tag = idNum + 1;
    
    UIView *valueGraph = [[UILabel alloc] initWithFrame:CGRectMake(base_w * 0.1, unit_h * 4, base_w * 0.8, unit_h)];
    valueGraph.backgroundColor = [UIColor colorWithRed:0.0f green:0.6f blue:1.0f alpha:1.0f];
    [baseView addSubview:valueGraph];
    valueGraph.tag = idNum + 2;
    
    UILabel *minLabel = [[UILabel alloc] initWithFrame:CGRectMake(base_w * 0.1, unit_h * 5, base_w * 0.2, unit_h)];
    minLabel.text = minStr;
    minLabel.textColor = [UIColor whiteColor];
    [baseView addSubview:minLabel];
    minLabel.tag = idNum + 3;
    
    UILabel *maxLabel = [[UILabel alloc] initWithFrame:CGRectMake(base_w * 0.7, unit_h * 5, base_w * 0.2, unit_h)];
    maxLabel.text = maxStr;
    maxLabel.textColor = [UIColor whiteColor];
    maxLabel.textAlignment = NSTextAlignmentRight;
    [baseView addSubview:maxLabel];
    maxLabel.tag = idNum + 4;
}

- (void)updateSampleValueLabel:(NSString *)str ViewTag:(viewTagNo)viewTag{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *baseView = [self->baseFrameView viewWithTag:viewTag];
        UILabel *label = [baseView viewWithTag:viewTag + 1];
        label.text = str;
        
        UILabel *maxLabel = [baseView viewWithTag:viewTag + 4];
        float value = [str floatValue];
        float value_max = [maxLabel.text floatValue];
        float graph_w = (CGRectGetWidth(baseView.bounds) * 0.8) * (value / value_max);
        
        UIView *valueGraph = [baseView viewWithTag:viewTag + 2];
        valueGraph.frame = CGRectMake(valueGraph.frame.origin.x, valueGraph.frame.origin.y, graph_w, valueGraph.frame.size.height);
    });
}

- (void)enableRestartButton {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIButton *rButton = [self->baseFrameView viewWithTag:restartButtonTag];
        rButton.backgroundColor = [UIColor colorWithRed:0.0f green:0.4f blue:0.8f alpha:1.0f];
        [rButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        rButton.enabled = YES;
    });
}

- (void)disableRestartButton {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIButton *rButton = [self->baseFrameView viewWithTag:restartButtonTag];
        rButton.backgroundColor = [UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f];
        [rButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        rButton.enabled = NO;
    });
}

- (void)updateRestartButton {
    
    NSString *str = @"";
    
    switch (dataSetType) {
        case DataSet_Default:
            str = @"デフォルト";
            break;
        case DataSet_Speed9:
            str = @"速度 9Hz";
            break;
        case DataSet_RPM9:
            str = @"回転数 9Hz";
            break;
        case DataSet_ThrottlePosition9:
            str = @"スロットル開度 9Hz";
            break;
        case DataSet_Speed5_RPM5:
            str = @"速度 5Hz, 回転数 5Hz";
            break;
        case DataSet_Speed5_ThrottlePosition5:
            str = @"速度 5Hz, スロットル開度 5Hz";
            break;
        case DataSet_RPM5_ThrottlePosition5:
            str = @"回転数 5Hz, スロットル開度 5Hz";
            break;
        default:
            str = @"デフォルト";
            break;
    }
    
    UIButton *rButton = [baseFrameView viewWithTag:restartButtonTag];
    [rButton setTitle:str forState:UIControlStateNormal];
}

- (void)updateProgressLabel:(NSString *)str {
    dispatch_async(dispatch_get_main_queue(), ^{
        UILabel *pLabel = [self->baseFrameView viewWithTag:progressLabelTag];
        pLabel.text = str;
    });
}

- (void)showErrorAlert:(NSString *)title Message:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

#pragma mark - button action
- (void)restartButtonTouchUp {
    [dx501RecieveManager disconnectFromDX501];
    
    switch (dataSetType) {
        case DataSet_Default:
            dataSetType = DataSet_Speed9;
            break;
        case DataSet_Speed9:
            dataSetType = DataSet_RPM9;
            break;
        case DataSet_RPM9:
            dataSetType = DataSet_ThrottlePosition9;
            break;
        case DataSet_ThrottlePosition9:
            dataSetType = DataSet_Speed5_RPM5;
            break;
        case DataSet_Speed5_RPM5:
            dataSetType = DataSet_Speed5_ThrottlePosition5;
            break;
        case DataSet_Speed5_ThrottlePosition5:
            dataSetType = DataSet_RPM5_ThrottlePosition5;
            break;
        case DataSet_RPM5_ThrottlePosition5:
            dataSetType = DataSet_Default;
            break;
        default:
            dataSetType = DataSet_Speed9;
            break;
    }
    
    [self updateRestartButton];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self->dx501RecieveManager connectToDX501:self->dataSetType];
    });
}

#pragma mark - DX501ReceiveDelegate
// BLEスキャン開始
- (void)bleScanStart {
    NSLog(@"%s", __func__);
    [self updateProgressLabel:@"BLEスキャン開始"];
}

// 接続した時に呼ばれる
- (void)didConnectToDX501 {
    NSLog(@"%s", __func__);
    [self updateProgressLabel:@"DX501と接続しました"];
}

// データ受信開始
- (void)startBroadcastData {
    NSLog(@"%s", __func__);
    [self updateProgressLabel:@"データ受信開始"];
    [self enableRestartButton];
}

// 切断した時に呼ばれる
- (void)didDisConnectToDX501 {
    NSLog(@"%s", __func__);
    [self updateProgressLabel:@"DX501との通信を切断しました"];
    [self disableRestartButton];
}

// エラーメッセージ
- (void)errorMessage:(NSString *)errorMsg {
    NSLog(@"%@", errorMsg);
    [self showErrorAlert:@"エラー" Message:errorMsg];
}


// MARK:積算データ（今回の走行開始から累積した値）
// 燃料消費量[ml]
- (void)didUpdateCumulationFuel:(unsigned long)cumulationFuel {
    NSLog(@"燃料消費量 %lu [ml]", cumulationFuel);
}

// 走行距離[m] 今回の走行開始から累積した走行距離
- (void)didUpdateTravelDistance:(unsigned long)travelDistance {
    NSLog(@"走行距離 %lu [m]", travelDistance);
}

// アイドリング時間[s]
- (void)didUpdateIdlingTime:(unsigned long)idlingTime {
    NSLog(@"アイドリング時間 %lu [s]", idlingTime);
}

// 平均速度[km/h]
- (void)didUpdateAverageSpeed:(unsigned long)averageSpeed {
    NSLog(@"平均速度[km/h] %lu", averageSpeed);
}

// 燃料カット走行距離[m]
- (void)didUpdateCutFuelMileage:(unsigned long)cutFuelMileage {
    NSLog(@"燃料カット走行距離[m] %lu", cutFuelMileage);
}

// エコスタート回数
- (void)didUpdateEcoStartCount:(unsigned long)ecoStartCount {
    NSLog(@"エコスタート回数 %lu", ecoStartCount);
}

// 発進停止回数
- (void)didUpdateStartStopCount:(unsigned long)startStopCount {
    NSLog(@"発進停止回数 %lu", startStopCount);
}

// アイドリングストップ時間[s]
- (void)didUpdateIdlingStopTime:(unsigned long)idlingStopTime {
    NSLog(@"アイドリングストップ時間[s] %lu", idlingStopTime);
}

// エコドライブ時間[s]
- (void)didUpdateEcoDriveTime:(unsigned long)ecoDriveTime {
    NSLog(@"エコドライブ時間[s] %lu", ecoDriveTime);
}

// 最高速度[km/h]
- (void)didUpdateMaximumSpeed:(unsigned long)maximumSpeed {
    NSLog(@"最高速度[km/h] %lu", maximumSpeed);
}

// 最高回転数[rpm]
- (void)didUpdateMaximumEngineRotation:(unsigned long)maximumEngineRotation {
    NSLog(@"最高回転数[rpm] %lu", maximumEngineRotation);
}

// 走行時間[s]
- (void)didUpdateDrivingTime:(unsigned long)drivingTime {
    NSLog(@"走行時間[s] %lu", drivingTime);
}


// MARK:瞬間データ（リアルタイムの値）
// 瞬間燃費[m/μℓ]
- (void)didUpdateFuelEfficiency:(double)fuelEfficiency {
    NSLog(@"瞬間燃費 %f [m/μℓ]", fuelEfficiency);
}

// 速度[km/h]
- (void)didUpdateSpeed:(double)speed {
    NSLog(@"速度 %f [km/h]", speed);
    [self updateSampleValueLabel:[NSString stringWithFormat:@"%.0f", speed] ViewTag:speedViewTag];
}

// 回転数[rpm]
- (void)didUpdateRpm:(double)rpm {
    NSLog(@"回転数 %f [rpm]", rpm);
    [self updateSampleValueLabel:[NSString stringWithFormat:@"%.0f", rpm] ViewTag:rpmViewTag];
}

// スロットルポジション[0~100 %]
- (void)didUpdateThrottlePosition:(double)throttlePosition {
    NSLog(@"スロットルポジション %f", throttlePosition);
    [self updateSampleValueLabel:[NSString stringWithFormat:@"%.0f", throttlePosition] ViewTag:throttlePositionViewTag];
}

// 水温[摂氏]
- (void)didUpdateWaterTemperature:(double)WaterTemperature {
    NSLog(@"水温[摂氏] %f", WaterTemperature);
}

// MARK:累積データ（DX501をOBDコネクタに接続してから累積した値）
// 累積走行距離[m]
- (void)didUpdateLifetimeTravelDistance:(unsigned long)lifetimeTravelDistance {
    NSLog(@"累積走行距離 %lu [m]", lifetimeTravelDistance);
}

// 累積燃料消費量[ml]
- (void)didUpdateLifetimeCumulationFuel:(unsigned long)lifetimeCumulationFuel {
    NSLog(@"累積燃料消費量 %lu [ml]", lifetimeCumulationFuel);
}

@end
