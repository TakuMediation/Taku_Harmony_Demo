import { DataItem } from '../viewmodel/DataItem';
import { common } from '@kit.AbilityKit';
import { ATAdChoiceType, ATAdInteractionType, ATMaterialType, ATNativeAdMaterial,BuildATNativeAdVideoView } from 'anythink_sdk';

@Component
export struct NativeAdItemComponent {
  private itemInfo: DataItem = new DataItem();
  private nativeAdMaterial?: ATNativeAdMaterial;

  getPadding() {
    console.log("NativeAd" + "native ad item call get padding");
    return 0;
  }

  aboutToReuse(params: Record<string, object>): void {
    console.log("NativeAd" + "about to reuse:" + JSON.stringify(params));
  }

  aboutToRecycle(): void {
    console.log("NativeAd" + "about to recycle");
  }

  getAdMaterial(): ATNativeAdMaterial {
    return this.itemInfo.nativeAd?.getAdMaterial()!
  }

  aboutToAppear(): void {
    this.nativeAdMaterial = this.itemInfo.nativeAd?.getAdMaterial();
  }

  build() {
    Column() {
      Column() {
        // 广告描述
        Text(this.nativeAdMaterial?.getAdDesc())
          .fontSize("16fp")
          .fontColor("#333333")
          .margin({ bottom: 10 })
          .maxLines(2)
          .textAlign(TextAlign.Start)
          .padding(this.getPadding())
          .onClick((e: ClickEvent) => {
            // 点击转化
            this.nativeAdMaterial?.getClickHandler()(getContext(this) as common.UIAbilityContext, e);
          })
        if (this.nativeAdMaterial?.getAdMaterialType() == ATMaterialType.IMAGE ||
          this.nativeAdMaterial?.getAdMaterialType() == ATMaterialType.UNKNOWN) {
          // 展示图片
          if (this.nativeAdMaterial?.getImageList().length > 0) {
            Image(this.nativeAdMaterial?.getImageList()[0].imageUrl)
              .width("100%")
              .aspectRatio(1.78)
              .objectFit(ImageFit.Contain)
              .backgroundColor("#AAAAAA")
              .borderRadius(5)
              .onClick((e)=>{
                // 点击转化
                this.nativeAdMaterial?.getClickHandler()(getContext(this) as common.UIAbilityContext, e)
              })
          }
        } else {
          // 展示视频
          Column() {
            BuildATNativeAdVideoView(this.itemInfo.nativeAd!);
          }
          .width("100%")
          .aspectRatio(1.78)
          .borderRadius(5)
        }
        Row() {
          // 广告图标
          Row() {
            Image(this.nativeAdMaterial?.getAdChoiceUrl(ATAdChoiceType.NORMAL))
              .width('10vp')
              .height('10vp')
            Text(this.nativeAdMaterial?.getAdFrom())
              .margin({ left: '2vp' })
              .fontSize('10fp')
              .fontColor("#FFFFFF")
          }
          .height(14)
          .padding({ left: '2vp', right: '2vp' })
          .alignItems(VerticalAlign.Center)
          .backgroundColor("#25000000")
          .borderRadius('2vp')

          // 广告标题
          Text(`${this.nativeAdMaterial?.getAdTitle()}`)
            .fontSize("14fp")
            .fontColor("#666666")
            .maxLines(1)
            .flexGrow(1)
            .margin({ left: 10, right: 10 })
            .width(10)
            .onClick((e: ClickEvent) => {
              // 点击转化
              this.nativeAdMaterial?.getClickHandler()(getContext(this) as common.UIAbilityContext, e)
            })
          // 号召按钮
          Text(this.nativeAdMaterial?.getAdDesc())
            .padding(2)
            .borderRadius(2)
            .maxLines(1)
            .fontSize(12)
            .fontColor("#FFFFFF")
            .backgroundColor("#FE3666")
            .onClick((e: ClickEvent) => {
              // 点击转化
              this.nativeAdMaterial?.getClickHandler()(getContext(this) as common.UIAbilityContext, e)
            })
        }
        .width("100%")
        .margin({ bottom: 10, top: 10 })
      }
      .width("100%")
      .padding(16)
      .alignItems(HorizontalAlign.Start)

      Divider()
    }
    .width("100%")
    // 添加可见区域监听，SDK内部处理曝光逻辑
    .onVisibleAreaChange(this.nativeAdMaterial?.getVisibleAreaRatios(),
      this.nativeAdMaterial?.getVisibleAreaChangeListener())
  }
}