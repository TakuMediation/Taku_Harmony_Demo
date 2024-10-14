import { ATSDK, ATInitConfiguration } from 'anythink_sdk';
import { router } from '@kit.ArkUI';
import { PlacementIdBean } from '../viewmodel/PlacementIdBean';
import { ToastUtil } from '../utils/ToastUtil';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State bt_init: string = '初始化SDK';
  readonly APP_ID = "a6704d2dda04f7";
  readonly APP_KEY = "4f7b9ac17decb9babec83aac078742c7";
  private isInitSdkSucceed = false;

  build() {
    Column() {
      Button(this.bt_init)
        .height(36)
        .onClick(() => {
          let configuration: ATInitConfiguration = {
            appId: this.APP_ID,
            appKey: this.APP_KEY,
            networkLogDebug: true
          }
          // console.debug("init sdk start " + AGENT_EVENT_TYPE.INIT_CALLED.valueOf());
          ATSDK.init(getContext().getApplicationContext(), configuration)
          ATSDK.start().then((result) => {
            this.message = 'init result: ' + result;
            this.bt_init = 'init success';
            this.isInitSdkSucceed = true;
          })
          // testDynImport();
        })

      // Button('Huawei')
      //   .height(36)
      //   .onClick(() => {
      //     if (!this.isInitSdkSucceed) {
      //       ToastUtil.show('Please init sdk first.')
      //       return
      //     }
      //     const placementIdBean = new PlacementIdBean();
      //     placementIdBean.networkName = 'Huawei'
      //     placementIdBean.interstitialPlacementId = 'huawei_id';
      //     placementIdBean.rewardPlacementId = 'huawei_id';
      //     placementIdBean.splashPlacementId = 'huawei_id';
      //     placementIdBean.nativeExpressPlacementId = 'huawei_id';
      //
      //     router.pushUrl({
      //       url: "pages/FullscreenAdPage",
      //       params: { placementIdBean: placementIdBean }
      //     })
      //   }).margin({ top: 15 })

      Button('KuaiShou')
        .height(36)
        .onClick(() => {
          if (!this.isInitSdkSucceed) {
            ToastUtil.show('Please init sdk first.')
            return
          }
          const placementIdBean = new PlacementIdBean();
          placementIdBean.networkName = 'KuaiShou'
          placementIdBean.interstitialPlacementId = 'b6704d33540b5b';
          placementIdBean.rewardPlacementId = 'b6704d32537317';
          placementIdBean.splashPlacementId = 'b6704d30c80e33';
          placementIdBean.nativeExpressPlacementId = 'b6704d3456fe53';
          placementIdBean.nativeSelfRenderPlacementId = 'b6704d2fa4b27c';

          router.pushUrl({
            url: "pages/FullscreenAdPage",
            params: { placementIdBean: placementIdBean }
          })
        }).margin({ top: 15 })
    }
    .justifyContent(FlexAlign.Center)
    .height('100%')
    .width('100%')
  }
}

