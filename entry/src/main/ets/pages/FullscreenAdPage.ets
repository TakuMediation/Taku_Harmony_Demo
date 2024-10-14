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

@Entry
@Component
struct FullscreenAdPage {
  private uiAbilityContext: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;

  @State message: string = 'ad log';
  @State bt_inter: string = '加载插屏';
  @State bt_reward: string = '加载激励';
  @State bt_splash: string = '加载开屏';
  @State bt_native: string = '加载原生';
  @State bt_banner: string = '加载横幅';
  @State hasSplashAd: boolean = false;
  private splashAd?: ATSplashAd;
  private SPLASH_PLACE_ID: string = '';
  private REWARD_PLACE_ID: string = '';
  private INTERSTITIAL_PLACE_ID: string = '';
  private NATIVE_SELF_RENDER_PLACE_ID: string = '';
  private NATIVE_EXPRESS_PLACE_ID: string = '';

  private networkName: string = '';

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
          BuildATSplashAdView(this.splashAd!);
        }.height('70%')
      } else {
        TitleComponent({ title: `测试${this.networkName}广告` })
      }
      Row() {
        Column() {
          Button(this.bt_inter)
            .id('button')
            .height(36)
            .margin({ top: '2%' })
            .onClick(() => {
              this.requestInterstitialAd();
            })
          Button(this.bt_reward)
            .height(36)// .width('624px')
            .margin({ top: '2%' })
            .type(ButtonType.Capsule)
            .onClick(() => {
              this.requestRewardAd();
            })
          Button(this.bt_splash)
            .id('button')
            .height(36)
            .margin({ top: '2%' })
            .onClick((event) => {
              this.requestSplashAd();
            })
          Button('原生模板广告')
            .id('button')
            .height(36)
            .margin({ top: '2%' })
            .onClick((event) => {
              router.pushUrl({
                url: "pages/native/NativeAdPage",
                params: { placementId: this.NATIVE_EXPRESS_PLACE_ID }
              })
            })
          Button('原生自渲染广告')
            .height(36)
            .margin({ top: '2%' })
            .onClick((e) => {
              router.pushUrl({
                url: "pages/native/NativeAdPage",
                params: { placementId: this.NATIVE_SELF_RENDER_PLACE_ID }
              })
            })
        }.width('60%')
        .height('100%')
        .justifyContent(FlexAlign.Center)

        Column() {
          Text(this.message)
            .fontSize(12)
            .fontWeight(FontWeight.Normal)
        }.width('40%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
      }
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
      onAdSkip: (adInfo: ATAdInfo): void => {
        this.hasSplashAd = false;
        this.printLog("onAdSkip() >>> ", adInfo);
      },
      onAdLoadFailed: (adError: ATAdError): void => {
        this.printLog(`onAdLoadFailed() >>>`, undefined, adError);
      },
      onAdOtherStatus: (adInfo?: ATAdInfo | undefined): void => {
        this.printLog("onAdOtherStatus() >>> ", adInfo);
      }
    });
    this.splashAd.loadAd({
      context: getContext(),
      fetchAdTimeout: 5000
    });
  }

  requestRewardAd() {
    let rewardAd = new ATRewardVideoAd(this.REWARD_PLACE_ID);
    rewardAd.setAdListener({
      onAdLoaded: (): void => {
        this.printLog("onAdLoaded() >>> ");
        this.bt_reward = "展示激励";
      },
      onAdShow: (adInfo: ATAdInfo): void => {
        this.printLog("onAdShow() >>> ", adInfo);
        this.bt_reward = "加载激励";
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
        this.bt_reward = "加载激励";
      },
      onAdOtherStatus: (adInfo?: ATAdInfo): void => {
        this.printLog("onAdOtherStatus() >>> ", adInfo);
      }
    });
    if (rewardAd.isAdReady()) {
      rewardAd.showAd();
      return;
    }
    rewardAd.loadAd({
      context: getContext()
    });
  }

  private requestInterstitialAd() {
    let interstitialAd = new ATInterstitialAd(this.INTERSTITIAL_PLACE_ID);
    interstitialAd.setAdListener({
      onAdLoaded: (): void => {
        this.printLog("onAdLoaded() >>> ");
        this.bt_inter = '展示插屏';
      },
      onAdShow: (adInfo: ATAdInfo): void => {
        this.printLog("onAdShow() >>> ", adInfo);
        this.bt_inter = '加载插屏';
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
        this.bt_inter = '加载插屏';
      },
      onAdOtherStatus: (adInfo?: ATAdInfo): void => {
        this.printLog("onAdOtherStatus() >>> ", adInfo);
      }
    })
    if (interstitialAd.isAdReady()) {
      interstitialAd.showAd(getContext());
      return;
    }
    interstitialAd.loadAd({ context: getContext() });
  }

  private printLog(msg: string, adInfo?: ATAdInfo, adError?: ATAdError) {
    if (adError) {
      this.message = msg + formatAdError(adError);
    } else {
      this.message = msg;
    }
    logMsg(msg, adInfo, adError);
  }
}