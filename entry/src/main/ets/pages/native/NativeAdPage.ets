import { ATAdError, ATAdInfo, ATNativeAd, NativeAd, BuildATNativeAdExpressView, formatAdError } from 'anythink_sdk'
import { TitleComponent } from '../../view/TitleComponent';
import { DataItem } from '../../viewmodel/DataItem';
import { NativeAdItemComponent } from '../../view/NativeAdItemComponent';
import { logMsg } from '../../utils/PrinLogUtil';
import { router } from '@kit.ArkUI';
import { IsAdReadyButton } from '../FullscreenAdPage';
import { ToastUtil } from '../../utils/ToastUtil';

/**
 * Description:自渲染测试页面
 * Created by Quin on 2024/9/24
 **/
@Entry
@Component
struct NativeAdPage {
  // readonly NATIVE_PLACE_ID = "b66f534154c669";
  // readonly NATIVE_EXPRESS_PLACE_ID = "b66f530199d839";

  private readonly tag = 'NativeAdPage';
  private item?: DataItem;
  private placementId: string = '';
  private atNativeAd?: ATNativeAd;
  @State hasAd: boolean = false;
  @State nativeAdType: string = "";
  // @State adMsg: string = "";

  aboutToAppear(): void {
    let record = router.getParams() as Record<string, string>;
    this.placementId = record['placementId'];
  }

  build() {
    Column() {
      TitleComponent({ title: "测试原生广告" })
      Row() {
        Button("Load Ad")
          .height(36)// .width('624px')
          .margin({ top: '2%' })
          .type(ButtonType.Capsule)
          .onClick(() => {
            this.requestAd();
          })
        IsAdReadyButton({
          isAdReadyFunc: () => {
            const isAdReady = this.atNativeAd?.isAdReady();
            this.printLog("ad ready status: " + isAdReady)
          }
        }).height(36)
          .margin({ top: '2%', left: '2%' })
      }

      Row() {
        Button("Show Ad")
          .height(36)// .width('624px')
          .margin({ top: '2%' })
          .type(ButtonType.Capsule)
          .onClick(() => {
            this.showAd();
          })
        Button("Remove Ad")
          .height(36)// .width('624px')
          .margin({ top: '2%', left: '2%' })
          .type(ButtonType.Capsule)
          .onClick(() => {
            this.hasAd = false;
          })
      }

      Text(`渲染方式：${this.nativeAdType}`)
        .fontSize("18fp")
        .fontColor($r('sys.color.black'))
        .textAlign(TextAlign.Start)
        .margin({ left: 20, top: 20 })
      // Text(`日志打印：${this.adMsg}`)
      //   .fontSize("15fp")// .fontColor($r('sys.color.gray_01'))
      //   .textAlign(TextAlign.Start)
      //   .margin({ left: 20, top: 20 })
      Divider()
        .margin({ top: 20, bottom: 20 })
      if (this.hasAd && this.item?.nativeAd) {
        Column() {
          if (this.item?.nativeAd?.isNativeExpress()) {
            //模板渲染
            BuildATNativeAdExpressView(this.item.nativeAd);
          } else {
            //自渲染
            NativeAdItemComponent({ itemInfo: this.item })
          }
        }.width('100%')
      }
    }
    .height("100%")
  }

  private requestAd() {
    this.hasAd = false;
    const that = this;
    const atNativeAd = new ATNativeAd(this.placementId);
    this.atNativeAd = atNativeAd;
    atNativeAd.setAdListener({
      onAdLoaded: (): void => {
        this.printLog("onAdLoaded() >>> ");
        this.showAd();
      },
      onAdLoadFailed: (adError: ATAdError): void => {
        this.printLog("onAdLoadFailed() >>> ", undefined, adError);
      },
      onAdOtherStatus: (adInfo?: ATAdInfo | undefined): void => {
        this.printLog("onAdOtherStatus() >>> ", adInfo);
      }
    });
    atNativeAd.loadAd({
      context: getContext()
    });
  }

  private showAd() {
    if (!this.atNativeAd) {
      this.printLog("ad is not ready.")
      return;
    }
    const nativeAd = this.atNativeAd.getNativeAd();
    if (!nativeAd) {
      this.printLog("ad is not ready.")
      return;
    }
    nativeAd?.setNativeAdEventListener({
      onAdShow: (adInfo: ATAdInfo): void => {
        this.printLog("onAdShow() >>> ", adInfo);
      },
      onAdClose: (adInfo: ATAdInfo): void => {
        this.printLog("onAdClose() >>> ", adInfo);
      },
      onAdClick: (adInfo: ATAdInfo): void => {
        this.printLog("onAdClick() >>> ", adInfo);
      },
      onAdDislikeClick: (adInfo: ATAdInfo): void => {
        this.printLog("onAdDislikeClick() >>> ", adInfo);
      },
      onAdVideoResume: (adInfo: ATAdInfo): void => {
        this.printLog("onAdVideoResume() >>> ", adInfo);
      },
      onAdVideoPause: (adInfo: ATAdInfo): void => {
        this.printLog("onAdVideoPause() >>> ", adInfo);
      },
      onAdVideoPlayStart: (adInfo: ATAdInfo): void => {
        this.printLog("onAdVideoPlayStart() >>> ", adInfo);
      },
      onAdVideoPlayEnd: (adInfo: ATAdInfo): void => {
        this.printLog("onAdVideoPlayEnd() >>> ", adInfo);
      },
      onAdVideoPlayFailed: (adError: ATAdError, adInfo?: ATAdInfo | undefined): void => {
        this.printLog("onAdVideoPlayFailed() >>> ", adInfo, adError);
      }
    })

    if (nativeAd?.isNativeExpress()) {
      this.nativeAdType = "模板";
    } else {
      this.nativeAdType = "自渲染";
    }
    let dataItem = new DataItem();
    dataItem.nativeAd = nativeAd;
    this.item = dataItem;
    this.hasAd = true;
  }

  private printLog(msg: string, adInfo?: ATAdInfo, adError?: ATAdError) {
    let adMsg = '';
    if (adError) {
      adMsg = msg + adError.toString();
    } else {
      adMsg = msg;
    }
    ToastUtil.show(adMsg);
    logMsg(adMsg, adInfo, adError);
  }
}

