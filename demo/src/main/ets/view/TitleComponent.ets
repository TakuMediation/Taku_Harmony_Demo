import router from '@ohos.router';
import windowTool from '../utils/WindowTool';

@Component
export struct TitleComponent {
  title?: Resource | string;
  @State hasBack: boolean = true;
  @State topMargin: number = 0;

  aboutToAppear(): void {
    this.resetMargin();
  }

  resetMargin() {
    windowTool.getAvoidArea(getContext(this)).then(rect => {
      this.topMargin = rect.top;
    });
  }

  build() {
    Column() {
      Stack() {
        Text(this.title)
          .fontColor($r('app.color.title'))
          .fontSize($r('app.float.detail_title'))
          .textAlign(TextAlign.Center)
          .width('100%')
        if (this.hasBack) {
          Image($r("app.media.anythink_backreward"))
            .width($r('app.float.image_size'))
            .height($r('app.float.image_size'))
            .margin({
              left: $r('app.float.image_margin_left'),
              right: $r('app.float.image_margin_right')
            })
            .onClick(() => {
              router.back();
            })
        }
      }
      .width('100%')
      .height($r('app.float.title_height'))
      .alignContent(Alignment.Start)
      Divider()
        .height('1px')
    }
    .margin({top: this.topMargin})
    .onAreaChange(event => {
      this.resetMargin();
    })
  }
}