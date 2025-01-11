import { DataItem } from '../viewmodel/DataItem';
import { common } from '@kit.AbilityKit';
import {
  ATAdChoiceType,
  ATAdInteractionType,
  ATMaterialType,
  ATNativeAdMaterial,
  BuildATNativeAdVideoView,
  NativeAd
} from 'anythink_sdk';
import { ATArrayList, ATNativePrepareInfo } from 'anythink_sdk';
import { util } from '@kit.ArkTS';

@Component
export struct NativeAdItemComponent {
  private itemInfo: DataItem = new DataItem();
  private nativeAd?: NativeAd;
  private nativeAdMaterial?: ATNativeAdMaterial;
  private rootComponentId: string = util.generateRandomUUID();
  private clickIds = new ATArrayList<string>();
  private creativeIds = new ATArrayList<string>();
  private closeClickHandler?:(context: object, event: ClickEvent) => void;

  aboutToReuse(params: Record<string, object>): void {
    console.log("NativeAd" + "about to reuse:" + JSON.stringify(params));
  }

  aboutToRecycle(): void {
    console.log("NativeAd" + "about to recycle");
  }

  aboutToAppear(): void {
    this.nativeAd = this.itemInfo.nativeAd;
    this.nativeAdMaterial = this.itemInfo.nativeAd?.getAdMaterial();
    this.closeClickHandler = this.nativeAdMaterial?.getCloseClickHandler();
  }

  build() {
    Column() {
      Column() {
        Row() {
          if (this.nativeAdMaterial?.getAdIconUrl()) {
            Image(this.nativeAdMaterial?.getAdIconUrl())
              .height(32)
              .width(32)
              .borderRadius(5)
              .margin({ right: 5 })
              .onClick((e: ClickEvent) => {
                // 点击转化
                this.nativeAdMaterial?.getClickHandler()(getContext(this) as common.UIAbilityContext, e)
              })
              .id(this.clickIds.addAdId(util.generateRandomUUID())) //设置组件Id，需要全局保证唯一性，涉及计费
          }
          Column() {
            // 广告标题
            Text(this.nativeAdMaterial?.getAdTitle())
              .width('85%')
              .fontSize(16)
              .fontColor("#000000")
              .maxLines(1)
              .textAlign(TextAlign.Start)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .onClick((e: ClickEvent) => {
                // 点击转化
                this.nativeAdMaterial?.getClickHandler()(getContext(this) as common.UIAbilityContext, e)
              })
              .id(this.creativeIds.addAdId(util.generateRandomUUID()))
            // 广告描述
            Text(this.nativeAdMaterial?.getAdDesc())
              .width('85%')
              .fontSize(16)
              .fontColor("#333333")
              .maxLines(1)
              .textAlign(TextAlign.Start)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .onClick((e: ClickEvent) => {
                // 点击转化
                this.nativeAdMaterial?.getClickHandler()(getContext(this) as common.UIAbilityContext, e);
              })
              .id(this.clickIds.addAdId(util.generateRandomUUID()))
          }
          .margin({ left: 15, right: 15 })
          .align(Alignment.Start)

          //dislike 按钮
          if (this.closeClickHandler) {
            Column() {
              Image($r("app.media.anythink_dislike"))
                .onClick((e: ClickEvent) => {
                  if (this.closeClickHandler) {
                    this.closeClickHandler(this, e);
                  }
                })
                .height(16)
                .width(16)
                .margin({ right: 15 })
            }.align(Alignment.TopEnd)
          }
        }.margin({ bottom: 10 })

        if (this.nativeAdMaterial?.getAdMaterialType() == ATMaterialType.IMAGE ||
          this.nativeAdMaterial?.getAdMaterialType() == ATMaterialType.UNKNOWN) {
          // 展示图片
          if (this.nativeAdMaterial?.getImageList().length > 0) {
            Image(this.nativeAdMaterial?.getImageList()[0].imageUrl)
              .width("100%")
              .objectFit(ImageFit.Contain)
              .aspectRatio(1.78)
              .onClick((e) => {
                // 点击转化
                this.nativeAdMaterial?.getClickHandler()(getContext(this) as common.UIAbilityContext, e)
              })
              .id(this.clickIds.addAdId(util.generateRandomUUID()))
          }
        } else {
          // 展示视频
          Column() {
            if (this.nativeAd) {
              BuildATNativeAdVideoView(this.nativeAd);
            }
          }
          .aspectRatio(1.78)
          .width("100%")
        }
        Row() {
          // 广告图标
          Row() {
            Image(this.nativeAdMaterial?.getAdChoiceUrl(ATAdChoiceType.NORMAL))
              .width('10vp')
              .height('10vp')
              .id(this.clickIds.addAdId(util.generateRandomUUID()))

            Text(this.nativeAdMaterial?.getAdFrom())
              .margin({ left: '2vp' })
              .fontSize('10fp')
              .fontColor("#FFFFFF")
              .id(this.clickIds.addAdId(util.generateRandomUUID()))
          }
          .height(14)
          .padding({ left: '2vp', right: '2vp' })
          .alignItems(VerticalAlign.Center)
          .backgroundColor("#25000000")
          .borderRadius('2vp')

          // 号召按钮
          Text(this.nativeAdMaterial?.getAdCallToActionText())
            .margin({ left: 15 })
            .padding(2)
            .borderRadius(2)
            .maxLines(1)
            .fontSize(14)
            .fontColor("#FFFFFF")
            .backgroundColor("#FE3666")
            .onClick((e: ClickEvent) => {
              // 点击转化
              this.nativeAdMaterial?.getClickHandler()(getContext(this) as common.UIAbilityContext, e)
            })
            .id(this.creativeIds.addAdId(util.generateRandomUUID()))
        }
        .width("100%")
        .margin({ bottom: 10, top: 10 })
      }
      .width("100%")
      .padding(15)
      .alignItems(HorizontalAlign.Start)
    }.width("100%")
    // 添加可见区域监听，SDK内部处理曝光逻辑
    .onVisibleAreaChange(this.nativeAdMaterial?.getVisibleAreaRatios(), this.nativeAdMaterial?.getVisibleAreaChangeListener())
    .id(this.rootComponentId)
    .onAppear(() => {
      const prepareInfo = new ATNativePrepareInfo();
      prepareInfo.clickViewIds = this.clickIds; //设置组件Id，需要全局保证唯一性，涉及计费
      prepareInfo.creativeViewIds = this.creativeIds; //设置组件Id，需要全局保证唯一性，涉及计费
      this.nativeAd?.prepare(this.rootComponentId, this.getUIContext(), prepareInfo);
    })
  }
}