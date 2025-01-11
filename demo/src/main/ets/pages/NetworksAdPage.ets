import { PlacementIdBean } from '../viewmodel/PlacementIdBean';
import { router } from '@kit.ArkUI';
import { TitleComponent } from '../view/TitleComponent';
import { CustomButton } from '../view/custom-button';

@Entry
@Component
struct NetworksAdPage {
  build() {
    Column() {
      TitleComponent({ title: `广告平台列表` })

      CustomButton({
        mText: "KuaiShou",
        mOnClick: () => {
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
        }
      }).margin({ top: 30 })

      CustomButton({
        mText: "CSJ",
        mOnClick: () => {
          const placementIdBean = new PlacementIdBean();
          placementIdBean.networkName = 'CSJ'
          placementIdBean.interstitialPlacementId = 'b6760f377bdb2b';
          placementIdBean.rewardPlacementId = 'b675addb71946f';
          placementIdBean.splashPlacementId = 'b675add632fd96';
          placementIdBean.nativeExpressPlacementId = 'b675adda1ecf4d';
          placementIdBean.nativeSelfRenderPlacementId = 'b675ae1539999f';
          placementIdBean.bannerPlacementId = 'b6772057a769c3';

          router.pushUrl({
            url: "pages/FullscreenAdPage",
            params: { placementIdBean: placementIdBean }
          })
        }
      })
      CustomButton({
        mText: "Huawei",
        mOnClick: () => {
          const placementIdBean = new PlacementIdBean();
          placementIdBean.networkName = 'Huawei'
          placementIdBean.interstitialPlacementId = 'b67073ddc81e41';
          placementIdBean.rewardPlacementId = 'b67073d53b0a44';
          placementIdBean.splashPlacementId = 'b67073dfd38c29';
          placementIdBean.nativeExpressPlacementId = 'b67073d84059f3';

          router.pushUrl({
            url: "pages/FullscreenAdPage",
            params: { placementIdBean: placementIdBean }
          })
        }
      })
      CustomButton({
        mText: "GDT",
        mOnClick: () => {
          const placementIdBean = new PlacementIdBean();
          placementIdBean.networkName = 'GDT'
          placementIdBean.rewardPlacementId = 'b677207424de34';

          router.pushUrl({
            url: "pages/FullscreenAdPage",
            params: { placementIdBean: placementIdBean }
          })
        }
      })
    }
    .height('100%')
    .width('100%')
  }
}