/**
 * Description:
 * Created by Quin on 2024/10/9
 **/
import {
  ATAdError,
  ATAdInfo,
  ATAdStatus,
  ATInterstitialAd,
  ATRewardVideoAd,
  ATSplashAd,
  AT_LOCAL_EXTRA_KEY,
  BuildATSplashAdView,
  formatAdError
} from 'anythink_sdk';
import { display, router } from '@kit.ArkUI';
import { logMsg } from '../utils/PrinLogUtil';
import { PlacementIdBean } from '../viewmodel/PlacementIdBean';
import { TitleComponent } from '../view/TitleComponent';
import { common } from '@kit.AbilityKit';
import { ATKSConfig } from 'anythink_network_ks';
import { ToastUtil } from '../utils/ToastUtil';
import { DemoConstants } from '../entryability/DemoConstants';
import { ATTTConfig } from 'anythink_network_csj';

@Builder
function bottomViewBuilder() {
  Text('Logo View')
    .backgroundColor(Color.Yellow)
    .width('100%')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM]) // expand to bottom sys area
    .height('20%') // // height <= 20%

}
let myBuilder: WrappedBuilder<[]> = wrapBuilder(bottomViewBuilder) // CSJ / GDT / HW / KS

@Component
export struct IsAdReadyButton {
  isAdReadyFunc?: () => void;

  build() {
    Stack() {
      Button('Is Ad Ready')
        .height(36)
        .onClick(() => {
          if (this.isAdReadyFunc) {
            this.isAdReadyFunc()
          }
        })
    }
  }
}

@Component
export struct adShowButton {
  adShowFunc?: () => void;

  build() {
    Stack() {
      Button('Show')
        .height(36)
        .onClick(() => {
          if (this.adShowFunc) {
            this.adShowFunc()
          }
        })
    }
  }
}

@Entry
@Component
struct FullscreenAdPage {
  private uiAbilityContext: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
  // @State message: string = 'ad log';
  private readonly BT_INTER: string = 'Load Interstitial';
  private readonly BT_REWARD: string = 'Load Reward';
  private readonly BT_SPLASH: string = 'Load Splash';
  private readonly BT_NATIVE: string = 'Load Native';
  private readonly BT_BANNER: string = 'Load Banner';
  @State hasSplashAd: boolean = false;
  private splashShowLocalExtra: Record<string, Object> = {};
  private SPLASH_PLACE_ID: string = '';
  private REWARD_PLACE_ID: string = '';
  private INTERSTITIAL_PLACE_ID: string = '';
  private NATIVE_SELF_RENDER_PLACE_ID: string = '';
  private NATIVE_EXPRESS_PLACE_ID: string = '';
  private BANNER_PLACE_ID: string = '';
  private networkName: string = '';
  private interstitialAd?: ATInterstitialAd;
  private rewardAd?: ATRewardVideoAd;
  private splashAd?: ATSplashAd;

  aboutToAppear(): void {
    let record = router.getParams() as Record<string, Object>;
    const placementIdBean = record['placementIdBean'] as PlacementIdBean;
    this.networkName = placementIdBean.networkName;
    this.SPLASH_PLACE_ID = placementIdBean.splashPlacementId;
    this.REWARD_PLACE_ID = placementIdBean.rewardPlacementId;
    this.INTERSTITIAL_PLACE_ID = placementIdBean.interstitialPlacementId;
    this.NATIVE_SELF_RENDER_PLACE_ID = placementIdBean.nativeSelfRenderPlacementId;
    this.NATIVE_EXPRESS_PLACE_ID = placementIdBean.nativeExpressPlacementId;
    this.BANNER_PLACE_ID = placementIdBean.bannerPlacementId;
  }

  build() {
    Column() {
      if (this.hasSplashAd) {
        Stack() {
          BuildATSplashAdView(this.splashAd!, {
            windowStage: DemoConstants.windowStage,
            // since v6.3.40: optional builder for all ads, and 【should set localExtraMap.AD_HEIGHT for CSJ】
            bottomViewBuilder: myBuilder,
            localExtraMap: this.splashShowLocalExtra
          })
        }
        .width('100%')
        .height('100%')
      } else {
        TitleComponent({ title: `测试${this.networkName}广告` })
        Column() {
          if (this.INTERSTITIAL_PLACE_ID.length > 0) {
            Row() {
              Button(this.BT_INTER)
                .height(36)
                .onClick(() => {
                  this.requestInterstitialAd();
                })
              IsAdReadyButton({
                isAdReadyFunc: () => {
                  const isAdReady = this.interstitialAd?.isAdReady() ?? false;
                  this.printLog("interstitial ad ready status: " + isAdReady);
                }
              }).margin({ left: '2%' })
              adShowButton({
                adShowFunc: (): void => this.showInterstitialAd()
              }).margin({ left: '2%' })
            }
          }
          if (this.REWARD_PLACE_ID.length > 0) {
            Row() {
              Button(this.BT_REWARD)
                .height(36)
                .margin({ top: '2%' })
                .type(ButtonType.Capsule)
                .onClick(() => {
                  this.requestRewardAd();
                })
              IsAdReadyButton({
                isAdReadyFunc: () => {
                  const isAdReady = this.rewardAd?.isAdReady() ?? false;
                  this.printLog("reward ad ready status: " + isAdReady);
                }
              }).margin({ top: '2%', left: '2%' })
              adShowButton({
                adShowFunc: (): void => this.showRewardAd()
              }).margin({ top: '2%', left: '2%' })
            }
          }
          if (this.SPLASH_PLACE_ID.length > 0) {
            Row() {
              Button(this.BT_SPLASH)
                .height(36)
                .margin({ top: '2%' })
                .onClick(() => {
                  this.requestSplashAd();
                })
              IsAdReadyButton({
                isAdReadyFunc: () => {
                  const isAdReady = this.splashAd?.isAdReady() ?? false;
                  this.printLog("splash ad ready status: " + isAdReady);
                }
              }).margin({ top: '2%', left: '2%' })
              adShowButton({
                adShowFunc: (): void => this.showSplashAd()
              }).margin({ top: '2%', left: '2%' })
            }
          }
          if (this.NATIVE_EXPRESS_PLACE_ID.length > 0) {
            Button(this.BT_NATIVE + ' Express')
              .height(36)
              .margin({ top: '2%' })
              .onClick((event) => {
                router.pushUrl({
                  url: "pages/native/NativeAdPage",
                  params: { placementId: this.NATIVE_EXPRESS_PLACE_ID }
                })
              })
          }
          if (this.NATIVE_SELF_RENDER_PLACE_ID.length > 0) {
            Button(this.BT_NATIVE + ' SelfRender')
              .height(36)
              .margin({ top: '2%' })
              .onClick((e) => {
                router.pushUrl({
                  url: "pages/native/NativeAdPage",
                  params: { placementId: this.NATIVE_SELF_RENDER_PLACE_ID }
                })
              })
          }
          if (this.BANNER_PLACE_ID.length > 0) {
            Button(this.BT_BANNER)
              .height(36)
              .margin({ top: '2%' })
              .onClick((e) => {
                router.pushUrl({
                  url: "pages/banner/BannerAdPage",
                  params: { placementId: this.BANNER_PLACE_ID }
                })
              })
          }
        }
        .width('100%')
        .margin({ left: '8%', top: 20 })
        .alignItems(HorizontalAlign.Start)
      }
    }
    .width('100%')
    .height('100%')
  }

  requestSplashAd() {
    if (this.splashAd?.isAdReady()) {
      return;
    }
    this.splashAd = new ATSplashAd(this.SPLASH_PLACE_ID);
    this.splashAd.setAdListener({
      onAdLoaded: (isTimeout: boolean): void => {
        this.printLog("onAdLoaded() >>> isTimeout: " + isTimeout);
      },
      onAdShow: (adInfo: ATAdInfo): void => {
        this.printLog("onAdShow() >>> ", adInfo);
      },
      onAdClick: (adInfo: ATAdInfo): void => {
        this.printLog("onAdClick() >>> ", adInfo);
      },
      onAdClose: (adInfo: ATAdInfo): void => {
        this.hasSplashAd = false;
        this.printLog("onAdClose() >>> ", adInfo);
      },
      onAdLoadTimeout: (): void => {
        this.printLog("onAdLoadTimeout() >>> ");
      },
      onAdLoadFailed: (adError: ATAdError): void => {
        console.log(`==开屏广告加载错误: ${formatAdError(adError)}`);
        this.printLog(`onAdLoadFailed() >>>`, undefined, adError);
      },
      onAdOtherStatus: (adInfo?: ATAdInfo | undefined): void => {
        if (adInfo?.getAdStatusInfo()?.adStatus == ATAdStatus.SPLASH_SHOW_FAILED) {
          this.hasSplashAd = false;
          this.printLog("onAdOtherStatus() >>> SPLASH_SHOW_FAILED");
        } else {
          this.printLog("onAdOtherStatus() >>> ", adInfo);
        }
      }
    });
    const localExtraMap: Record<string, Object> = {};
    // optional, 【set ad height when you want to show CSJ bottomView】
    localExtraMap[AT_LOCAL_EXTRA_KEY.AD_HEIGHT] = px2vp(display.getDefaultDisplaySync().height) * 0.8
    this.splashAd.loadAd({
      context: getContext(),
      uiContext: this.getUIContext(), // since 6.0.20
      fetchAdTimeout: 5000,
      localExtraMap: localExtraMap,
    });
  }

  requestRewardAd() {
    let rewardAd = new ATRewardVideoAd(this.REWARD_PLACE_ID);
    this.rewardAd = rewardAd;
    rewardAd.setAdListener({
      onAdLoaded: (): void => {
        this.printLog("onAdLoaded() >>> ");
      },
      onAdShow: (adInfo: ATAdInfo): void => {
        this.printLog("onAdShow() >>> ", adInfo);
      },
      onAdClick: (adInfo: ATAdInfo): void => {
        this.printLog("onAdClick() >>> ", adInfo);
      },
      onAdClose: (adInfo: ATAdInfo): void => {
        this.printLog("onAdClose() >>> ", adInfo);
      },
      onAdReward: (adInfo: ATAdInfo): void => {
        this.printLog("onAdReward() >>> ", adInfo);
      },
      onAdLoadFailed: (adError: ATAdError): void => {
        this.printLog(`onAdLoadFailed() >>> `, undefined, adError);
      },
      onAdVideoPlayStart: (adInfo: ATAdInfo): void => {
        this.printLog("onAdVideoPlayStart() >>> ", adInfo);
      },
      onAdVideoPlayEnd: (adInfo: ATAdInfo): void => {
        this.printLog("onAdVideoPlayEnd() >>> ", adInfo);
      },
      onAdVideoPlayFailed: (adError: ATAdError, adInfo?: ATAdInfo | undefined): void => {
        this.printLog(`onAdVideoPlayFailed() >>> `, adInfo, adError);
      }
    });
    const localExtraMap: Record<string, Object> = {};
    localExtraMap[AT_LOCAL_EXTRA_KEY.USER_ID] = "your user id";
    localExtraMap[ATTTConfig.MEDIA_EXTRA_KEY] = '{"order_id":"123","level":1}'; // single json for cjs【USER_CUSTOM_DATA value】
    localExtraMap[AT_LOCAL_EXTRA_KEY.USER_CUSTOM_DATA] = 'my_extra_info'; // other adn 【USER_CUSTOM_DATA value】
    rewardAd.loadAd({
      context: getContext(),
      localExtraMap: localExtraMap
    });
  }

  private requestInterstitialAd() {
    let interstitialAd = new ATInterstitialAd(this.INTERSTITIAL_PLACE_ID);
    this.interstitialAd = interstitialAd;
    interstitialAd.setAdListener({
      onAdLoaded: (): void => {
        this.printLog("onAdLoaded() >>> ");
      },
      onAdShow: (adInfo: ATAdInfo): void => {
        this.printLog("onAdShow() >>> ", adInfo);
      },
      onAdClick: (adInfo: ATAdInfo): void => {
        this.printLog("onAdClick() >>> ", adInfo);
      },
      onAdClose: (adInfo: ATAdInfo): void => {
        this.printLog("onAdClose() >>> ", adInfo);
      },
      onAdLoadFailed: (adError: ATAdError): void => {
        this.printLog("onAdLoadFailed() >>> ", undefined, adError);
      },
      onAdVideoPlayStart: (adInfo: ATAdInfo): void => {
        this.printLog("onAdVideoPlayStart() >>> ", adInfo);
      },
      onAdVideoPlayEnd: (adInfo: ATAdInfo): void => {
        this.printLog("onAdVideoPlayEnd() >>> ", adInfo);
      },
      onAdVideoPlayFailed: (adError: ATAdError, adInfo?: ATAdInfo): void => {
        this.printLog(`onAdVideoPlayFailed() >>> `, adInfo, adError);
      }
    });
    const localExtraMap: Record<string, Object> = {};
    interstitialAd.loadAd({ context: getContext(), localExtraMap: localExtraMap });
  }

  private showInterstitialAd() {
    if (this.interstitialAd?.isAdReady()) {
      const localExtraMap: Record<string, Object> = {};
      localExtraMap[AT_LOCAL_EXTRA_KEY.SHOW_CUSTOM_EXT] = 'demo_inter_show_ext';
      this.interstitialAd.showAd(getContext(), {
        windowStage: DemoConstants.windowStage,
        localExtraMap: localExtraMap
      });
    } else {
      this.printLog("interstitial ad not ready");
    }
  }

  private showRewardAd() {
    if (this.rewardAd?.isAdReady()) {
      const localExtraMap: Record<string, Object> = {};
      localExtraMap[AT_LOCAL_EXTRA_KEY.SHOW_CUSTOM_EXT] = 'demo_reward_show_ext';
      this.rewardAd.showAd(getContext(), {
        windowStage: DemoConstants.windowStage,
        localExtraMap: localExtraMap
      });
    } else {
      this.printLog("reward ad not ready");
    }
  }

  private showSplashAd() {
    if (this.splashAd?.isAdReady()) {
      const localExtraMap: Record<string, Object> = {};
      localExtraMap[AT_LOCAL_EXTRA_KEY.SHOW_CUSTOM_EXT] = 'demo_splash_show_ext';
      this.splashShowLocalExtra = localExtraMap;
      this.hasSplashAd = true;
    } else {
      this.printLog("splash ad not ready");
    }
  }

  private printLog(msg: string, adInfo?: ATAdInfo, adError?: ATAdError) {
    let message = ''
    if (adError) {
      message = msg + formatAdError(adError);
    } else {
      message = msg;
    }
    ToastUtil.show(message);
    logMsg(message, adInfo, adError);
  }
}