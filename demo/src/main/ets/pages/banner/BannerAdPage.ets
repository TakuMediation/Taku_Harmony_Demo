/**
 * Description:
 * Created by Quin on 2024/12/24
 **/
import { router } from '@kit.ArkUI';
import { ATAdError, ATAdInfo, ATBannerAd, BannerAd, BuildATBannerAdView, formatAdError } from 'anythink_sdk';
import { logMsg } from '../../utils/PrinLogUtil';
import { ToastUtil } from '../../utils/ToastUtil';
import { TitleComponent } from '../../view/TitleComponent';

@Entry
@Component
struct BannerAdPage {
  @State hasAd: boolean = false;
  @State adMsg: string = "";
  private placementId: string = '';
  private atBannerAd?: ATBannerAd;
  private bannerAd?: BannerAd;

  aboutToAppear(): void {
    let record = router.getParams() as Record<string, string>;
    this.placementId = record['placementId'];
  }

  build() {
    Column() {
      TitleComponent({ title: "测试横幅广告" })
      Button("Load Ad")
        .height(36)// .width('624px')
        .margin({ top: '2%' })
        .type(ButtonType.Capsule)
        .onClick(() => {
          this.requestAd();
        })
      Button("Show Ad")
        .height(36)// .width('624px')
        .margin({ top: '2%' })
        .type(ButtonType.Capsule)
        .onClick(() => {
          this.hasAd = false;
          this.showAd();
        })
      Text(`日志打印：${this.adMsg}`)
        .fontSize("15fp")// .fontColor($r('sys.color.gray_01'))
        .textAlign(TextAlign.Start)
        .margin({ left: 20, top: 20 })
      Divider()
        .margin({ top: 20, bottom: 20 })
      if (this.hasAd && this.bannerAd) {
        BuildATBannerAdView(this.bannerAd, {
          onAdShow: (adInfo: ATAdInfo): void => {
            this.printLog("onAdShow() >>> ", adInfo);
          },
          onAdClick: (adInfo: ATAdInfo): void => {
            this.printLog("onAdClick() >>> ", adInfo);
          },
          onAdClose: (adInfo: ATAdInfo): void => {
            this.printLog("onAdClose() >>> ", adInfo);
            this.hasAd = false;
          },
          onAdAutoRefreshed: (adInfo: ATAdInfo): void => {
            this.printLog("onBannerAutoRefreshed() >>> ", adInfo);
          },
          onAdAutoRefreshFailed: (adError: ATAdError): void => {
            this.printLog("onBannerAutoRefreshFailed() >>> ", undefined, adError);
          }
        })
      }
    }
  }

  requestAd() {
    const atBannerAd = new ATBannerAd(this.placementId);
    this.atBannerAd = atBannerAd;
    atBannerAd.setAdListener({
      onAdLoaded: (): void => {
        this.printLog("onAdLoaded() >>> ");
      },
      onAdLoadFailed: (adError: ATAdError): void => {
        this.printLog("onAdLoadFailed() >>> ", undefined, adError);
      }
    });
    atBannerAd.loadAd({
      context: getContext(),
      uiContext: this.getUIContext()
    })
  }

  showAd() {
    if (!this.atBannerAd) {
      this.printLog("ad is not ready.")
      return;
    }
    const bannerAd = this.atBannerAd.getBannerAd();
    if (!bannerAd) {
      this.printLog("ad is not ready.")
      return;
    }
    this.bannerAd = bannerAd;
    this.hasAd = true;
  }

  private printLog(msg: string, adInfo?: ATAdInfo, adError?: ATAdError) {
    let adMsg = "";
    if (adError) {
      adMsg = `${msg}${formatAdError(adError)}`;
    } else {
      adMsg = msg;
    }
    this.adMsg = adMsg;
    ToastUtil.show(adMsg);
    logMsg(msg, adInfo, adError);
  }
}