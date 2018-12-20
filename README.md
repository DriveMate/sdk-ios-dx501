DriveMate d-OBD SDK for iOS (sdk-ios-dx501)
==========================

**This is an SDK for iOS app to connect with DriveMate d-OBD (DX501) OBD2 adapter.
The DX501 can receive driving information from OBD2 connector of the car.**

***DriveMate d-OBD (DX501) is for use / sold only in Japan due to radio law.**

概要
---------------
-   本SDKと[DriveMate d-OBD](http://www.drivemate.jp/product/drivemate-dobd-dx501/)(別売)を使用することで車速やエンジン回転数、スロットルポジションなど19種類の走行データを車両から取得し、ご自身のiOSアプリで利用することができます
-   本SDKは、個人・法人、商用・非商用を問わず自由にお使いいただけます

使用可能な車種
------------
- [適合表](http://www.drivemate.jp/c/support/matching/DX501_matching.pdf)に記載の適合可能車種でお使いいただけます
- 上記適合表に掲載されていない車種・適合表では「取付不可」となっている車種でも、本SDKを通すことでデータを取得できる場合があります
- ディーゼル車・輸入車、および2015年以降のトヨタのハイブリッド車については多くの車種でDriveMate d-OBDが正常に動作しないこと（エンジン停止から起動の際に省電力モードから復帰しない・正常な数値が取得できない等）を確認しております。予めご了承ください。

※適合表に未掲載、あるいは「取付不可」となっている車種でDriveMate d-OBDをご使用いただく際の不具合等については当社では責任を負いません。お客様の責任でのご購入、およびSDKのご使用をお願いいたします。

取得できる情報
------------
- 回転数[rpm]
- 速度[km/h]
- 瞬間燃費[m/μℓ]
- 水温[℃]
- スロットルポジション
- 累積走行距離[m]
- 累積燃料消費量[ml]
- 燃料カット走行距離[m]
- エコドライブ時間[s]
- 走行距離[m]
- 最高速度[km/h]
- 平均速度[km/h]
- 最高回転数[rpm]
- アイドリングストップ時間[s]
- アイドリング時間[s]
- エコスタート回数
- 発進停止回数
- 燃料消費量[ml]
- 走行時間[s]

データ取得モード
------------
**データ取得モードによって、取得できるデータ項目と1秒間に取得できるデータの数が変わります**

ご使用になる用途に応じて、最適なデータ取得モードを選択してください。

### データの順序[秒]
|  | pid | DataSet_Default | DataSet_Speed9 | DataSet_RPM9 | DataSet_ThrottlePosition9 | DataSet_Speed5_RPM5 | DataSet_Speed5_ThrottlePosition5 | DataSet_RPM5_ThrottlePosition5 |
|----|------|-----------------------------|-----------------------------|-----------------------------|-----------------------------|-----------------------------|----------------------------------|--------------------------------|
| 1 | 固定 | 燃料カット走行距離 | 燃料カット走行距離 | 燃料カット走行距離 | 燃料カット走行距離 | 燃料カット走行距離 | 燃料カット走行距離 | 燃料カット走行距離 |
| 2 | 固定 | エコドライブ時間 | エコドライブ時間 | エコドライブ時間 | エコドライブ時間 | エコドライブ時間 | エコドライブ時間 | エコドライブ時間 |
| 3 | 自由 | スロットルポジション | 速度 | 回転数 | スロットルポジション | 速度 | スロットルポジション | スロットルポジション |
| 4 | 固定 | 回転数 | 回転数 | 回転数 | 回転数 | 回転数 | 回転数 | 回転数 |
| 5 | 固定 | 速度 | 速度 | 速度 | 速度 | 速度 | 速度 | 速度 |
| 6 | 固定 | 走行距離 | 走行距離 | 走行距離 | 走行距離 | 走行距離 | 走行距離 | 走行距離 |
| 7 | 自由 | 水温 | 速度 | 回転数 | スロットルポジション | 回転数 | 速度 | 回転数 |
| 8 | 固定 | 最高速度 | 最高速度 | 最高速度 | 最高速度 | 最高速度 | 最高速度 | 最高速度 |
| 9 | 固定 | 平均速度 | 平均速度 | 平均速度 | 平均速度 | 平均速度 | 平均速度 | 平均速度 |
| 10 | 固定 | 最高回転数 | 最高回転数 | 最高回転数 | 最高回転数 | 最高回転数 | 最高回転数 | 最高回転数 |
| 11 | 自由 | スロットルポジション | 速度 | 回転数 | スロットルポジション | 速度 | スロットルポジション | スロットルポジション |
| 12 | 固定 | アイドリングストップ時間 | アイドリングストップ時間 | アイドリングストップ時間 | アイドリングストップ時間 | アイドリングストップ時間 | アイドリングストップ時間 | アイドリングストップ時間 |
| 13 | 固定 | アイドリング時間 | アイドリング時間 | アイドリング時間 | アイドリング時間 | アイドリング時間 | アイドリング時間 | アイドリング時間 |
| 14 | 固定 | エコスタート回数 | エコスタート回数 | エコスタート回数 | エコスタート回数 | エコスタート回数 | エコスタート回数 | エコスタート回数 |
| 15 | 自由 | 回転数 | 速度 | 回転数 | スロットルポジション | 回転数 | 速度 | 回転数 |
| 16 | 固定 | 発進停止回数 | 発進停止回数 | 発進停止回数 | 発進停止回数 | 発進停止回数 | 発進停止回数 | 発進停止回数 |
| 17 | 自由 | 速度 | 速度 | 回転数 | スロットルポジション | 速度 | スロットルポジション | スロットルポジション |
| 18 | 自由 | スロットルポジション | スロットルポジション | スロットルポジション | 水温 | 水温 | 水温 | 水温 |
| 19 | 自由 | 回転数 | 速度 | 回転数 | スロットルポジション | スロットルポジション | スロットルポジション | スロットルポジション |
| 20 | 固定 | 瞬間燃費 | 瞬間燃費 | 瞬間燃費 | 瞬間燃費 | 瞬間燃費 | 瞬間燃費 | 瞬間燃費 |
| 21 | 固定 | 燃料消費量 | 燃料消費量 | 燃料消費量 | 燃料消費量 | 燃料消費量 | 燃料消費量 | 燃料消費量 |
| 22 | 自由 | 速度 | 速度 | 回転数 | スロットルポジション | 回転数 | 速度 | 回転数 |
| 23 | 自由 | スロットルポジション | 水温 | 水温 | スロットルポジション | 速度 | スロットルポジション | スロットルポジション |
| 24 | 固定 | 走行時間 | 走行時間 | 走行時間 | 走行時間 | 走行時間 | 走行時間 | 走行時間 |
| 25 | 固定 | 累積走行距離 | 累積走行距離 | 累積走行距離 | 累積走行距離 | 累積走行距離 | 累積走行距離 | 累積走行距離 |
| 26 | 自由 | 回転数 | 速度 | 回転数 | スロットルポジション | 回転数 | 速度 | 回転数 |
| 27 | 固定 | 累積燃料消費量 | 累積燃料消費量 | 累積燃料消費量 | 累積燃料消費量 | 累積燃料消費量 | 累積燃料消費量 | 累積燃料消費量 |

### データの個数[秒]
|  | 種別 | データ項目 | DataSet_Default | DataSet_Speed9 | DataSet_RPM9 | DataSet_ThrottlePosition9 | DataSet_Speed5_RPM5 | DataSet_Speed5_ThrottlePosition5 | DataSet_RPM5_ThrottlePosition5 |
|----|------|-----------------------------|-----------------|----------------|--------------|---------------------------|---------------------|----------------------------------|--------------------------------|
| 1 | 瞬間 | 回転数[rpm] | 4 | 1 | 9 | 1 | 5 | 1 | 5 |
| 2 | 瞬間 | 速度[km/h] | 3 | 9 | 1 | 1 | 5 | 5 | 1 |
| 3 | 瞬間 | 瞬間燃費[m/μℓ] | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
| 4 | 瞬間 | 水温[℃] | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
| 5 | 瞬間 | スロットルポジション | 4 | 1 | 1 | 9 | 1 | 5 | 5 |
| 6 | 累積 | 累積走行距離[m] | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
| 7 | 累積 | 累積燃料消費量[ml] | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
| 8 | 積算 | 燃料カット走行距離[m] | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
| 9 | 積算 | エコドライブ時間[s] | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
| 10 | 積算 | 走行距離[m] | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
| 11 | 積算 | 最高速度[km/h] | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
| 12 | 積算 | 平均速度[km/h] | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
| 13 | 積算 | 最高回転数[rpm] | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
| 14 | 積算 | アイドリングストップ時間[s] | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
| 15 | 積算 | アイドリング時間[s] | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
| 16 | 積算 | エコスタート回数 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
| 17 | 積算 | 発進停止回数 | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
| 18 | 積算 | 燃料消費量[ml] | 1 | 1 | 1 | 1 | 1 | 1 | 1 |
| 19 | 積算 | 走行時間[s] | 1 | 1 | 1 | 1 | 1 | 1 | 1 |

※車種によっては取得できない項目や、数値が正常に取得できない場合があります。

活用事例
------------
- **[RAZO OnboardCam](https://itunes.apple.com/jp/app/id1278792932/)** - 動画にGPSや端末のセンサー、OBDⅡから取得した車輌情報を表示できるアプリ

[![](https://img.youtube.com/vi/yVWhqCmknAQ/0.jpg)](https://www.youtube.com/watch?v=yVWhqCmknAQ)

使用方法
------------
1.	SDKをダウンロードし、機能を組み込んだアプリを作成していただきます
2.	DriveMate d-OBDの取扱説明書に従い、取付とペアリングの作業を行います
3.	作成していただいたアプリを起動し、データの取得ができることをご確認ください

注意事項と免責事項
------------
- 本SDKは無償でご利用いただけますが、当社はSDKを使用した結果についての一切の責任を負いません。また、当社ではいかなる技術的サポートも提供いたしません。
- 本SDKをご利用いただく際に必要かつ適切な機器や開発環境、通信手段等は、お客様ご自身の責任と費用でご用意いただく必要があります。
- DriveMate d-OBDは電波法に基づく小電力データ通信システムの無線設備として認証を受けています。従って、本製品を使用する際、無線局の免許は必要ありません。また、本製品を分解・改造することは法律で禁止されています。
- 法律や公序良俗に反する用途・目的で本SDKを利用することを禁止いたします。
- 本SDKのエラーやバグ、論理的誤り、不具合、その他の瑕疵がないこと、信頼性、完全性、正確性、有効性について一切保証しておりませんが、万が一SDKに起因する不具合などを発見した際は[こちら](mailto:software@carmate.co.jp)にお問い合わせいただけますと幸いです。
- DriveMate d-OBD(DX501)を大量に購入する場合や協業のご依頼等は[こちら](mailto:software@carmate.co.jp)にお願いいたします。
