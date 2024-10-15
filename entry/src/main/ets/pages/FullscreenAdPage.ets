/**
 * Description:
 * Created by Quin on 2024/10/9
 **/
import {
  ATAdError,
  ATAdInfo,
  ATInterstitialAd,
  ATRewardVideoAd,
  ATSplashAd,
  BuildATSplashAdView,
  formatAdError
} from 'anythink_sdk';
import { router } from '@kit.ArkUI';
import { logMsg } from '../utils/PrinLogUtil';
import { PlacementIdBean } from '../viewmodel/PlacementIdBean';
import { TitleComponent } from '../view/TitleComponent';
import { common } from '@kit.AbilityKit';
import { ATKSConfig } from 'anythink_network_ks';
import { ToastUtil } from '../utils/ToastUtil';

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

@Entry
@Component
struct FullscreenAdPage {
  private uiAbilityContext: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
  // @State message: string = 'ad log';
  @State bt_inter: string = 'Load Interstitial';
  @State bt_reward: string = 'Load Reward';
  @State bt_splash: string = 'Load Splash';
  @State bt_native: string = 'Load Native';
  @State bt_banner: string = 'Load Banner';
  @State hasSplashAd: boolean = false;
  private SPLASH_PLACE_ID: string = '';
  private REWARD_PLACE_ID: string = '';
  private INTERSTITIAL_PLACE_ID: string = '';
  private NATIVE_SELF_RENDER_PLACE_ID: string = '';
  private NATIVE_EXPRESS_PLACE_ID: string = '';
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
  }

  build() {
    Column() {
      if (this.hasSplashAd) {
        Stack() {
          BuildATSplashAdView(this.splashAd!)
        }.height('70%')
      } else {
        TitleComponent({ title: `测试${this.networkName}广告` })
      }
      Column() {
        Row() {
          Button(this.bt_inter)
            .id('button')
            .height(36)
            .onClick(() => {
              this.requestInterstitialAd();
            })
          IsAdReadyButton({
            isAdReadyFunc: () => {
              const isAdReady = this.interstitialAd?.isAdReady() ?? false;
              // this.message = "interstitial ad ready status: " + isAdReady;
              this.printLog("interstitial ad ready status: " + isAdReady);
            }
          }).height(36)
            .margin({ left: '2%' })
        }

        Row() {
          Button(this.bt_reward)
            .height(36)// .width('624px')
            .margin({ top: '2%' })
            .type(ButtonType.Capsule)
            .onClick(() => {
              this.requestRewardAd();
            })
          IsAdReadyButton({
            isAdReadyFunc: () => {
              const isAdReady = this.rewardAd?.isAdReady() ?? false;
              // this.message = "reward ad ready status: " + isAdReady;
              this.printLog("reward ad ready status: " + isAdReady);
            }
          }).height(36)
            .margin({ top: '2%', left: '2%' })
        }

        Row() {
          Button(this.bt_splash)
            .id('button')
            .height(36)
            .margin({ top: '2%' })
            .onClick((event) => {
              this.requestSplashAd();
            })
          IsAdReadyButton({
            isAdReadyFunc: () => {
              const isAdReady = this.rewardAd?.isAdReady() ?? false;
              // this.message = "splash ad ready status: " + isAdReady;
              this.printLog("splash ad ready status: " + isAdReady);
            }
          }).height(36)
            .margin({ top: '2%', left: '2%' })
        }

        Button('Load Native Express')
          .id('button')
          .height(36)
          .margin({ top: '2%' })
          .onClick((event) => {
            router.pushUrl({
              url: "pages/native/NativeAdPage",
              params: { placementId: this.NATIVE_EXPRESS_PLACE_ID }
            })
          })
        Button('Load Native SelfRender')
          .height(36)
          .margin({ top: '2%' })
          .onClick((e) => {
            router.pushUrl({
              url: "pages/native/NativeAdPage",
              params: { placementId: this.NATIVE_SELF_RENDER_PLACE_ID }
            })
          })
      }
      .width('100%')
      .height('100%')
      .margin({ left: '20%' })
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Center)
    }
  }

  requestSplashAd() {
    this.splashAd = new ATSplashAd(this.SPLASH_PLACE_ID);
    this.splashAd.setAdListener({
      onAdLoaded: (isTimeout: boolean): void => {
        this.printLog("onAdLoaded() >>> isTimeout: " + isTimeout);
        this.hasSplashAd = true;
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
        this.printLog(`onAdLoadFailed() >>>`, undefined, adError);
      },
      onAdOtherStatus: (adInfo?: ATAdInfo | undefined): void => {
        this.printLog("onAdOtherStatus() >>> ", adInfo);
      }
    });
    const localExtraMap: Record<string, Object> = {};
    localExtraMap[ATKSConfig.VIDEO_SOUND_ENABLE_KEY] = false; //设置静音
    localExtraMap[ATKSConfig.VIDEO_AUTO_PLAY_TYPE_KEY] = 3; //设置不自动播放

    this.splashAd.loadAd({
      context: getContext(),
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
        this.bt_reward = "Show Reward";
      },
      onAdShow: (adInfo: ATAdInfo): void => {
        this.printLog("onAdShow() >>> ", adInfo);
        this.bt_reward = "Load Reward";
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
        this.bt_reward = "Load Reward";
      }
    });
    if (rewardAd.isAdReady()) {
      rewardAd.showAd();
      return;
    }
    const localExtraMap: Record<string, Object> = {};
    localExtraMap[ATKSConfig.VIDEO_SOUND_ENABLE_KEY] = false; //设置静音
    localExtraMap[ATKSConfig.VIDEO_AUTO_PLAY_TYPE_KEY] = 3; //设置不自动播放

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
        this.bt_inter = 'Show Interstitial';
      },
      onAdShow: (adInfo: ATAdInfo): void => {
        this.printLog("onAdShow() >>> ", adInfo);
        this.bt_inter = 'Load Interstitial';
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
        this.bt_inter = 'Load Interstitial';
      }
    })
    if (interstitialAd.isAdReady()) {
      interstitialAd.showAd(getContext());
      return;
    }
    const localExtraMap: Record<string, Object> = {};
    localExtraMap[ATKSConfig.VIDEO_SOUND_ENABLE_KEY] = false; //设置静音
    localExtraMap[ATKSConfig.VIDEO_AUTO_PLAY_TYPE_KEY] = 3; //设置不自动播放
    interstitialAd.loadAd({ context: getContext(), localExtraMap: localExtraMap });
  }

  private printLog(msg: string, adInfo?: ATAdInfo, adError?: ATAdError) {
    let message = ''
    if (adError) {
      message = msg + formatAdError(adError);
    } else {
      message = msg;
    }
    ToastUtil.show(message);
    logMsg(msg, adInfo, adError);
  }
}