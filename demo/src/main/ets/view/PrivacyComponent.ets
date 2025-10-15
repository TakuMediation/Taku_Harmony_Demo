import { webview } from '@kit.ArkWeb';

@CustomDialog
export struct PrivacyComponent {
  // custom dialog
  controller: CustomDialogController = new CustomDialogController({
    builder: this
  });
  // set callback about agreement
  onAgree?: () => void;
  // local webView controller
  private webviewController: webview.WebviewController = new webview.WebviewController();
  // your privacy URL
  private privacyUrl: string = "https://www.takuad.com/privacy-policy";

  build() {
    Column() {
      // webView area
      Web({
        src: this.privacyUrl,
        controller: this.webviewController,
      })
        .width('100%')
        .height('100%')
        .cacheMode(CacheMode.Default)// 默认缓存模式
        .zoomAccess(true)
        .imageAccess(true)
        .javaScriptAccess(true)// enable JavaScript
        .domStorageAccess(true)//enable storage access
        .databaseAccess(true)// enable database access
        .mixedMode(MixedMode.All)//  HTTP、HTTPS
        .onlineImageAccess(true)// enable image access
        .backgroundColor('#FFFFFF')
        .onPageBegin((event) => {
          console.log('onPageBegin: ' + event?.url);
        })
        .onPageEnd((event) => {
          console.log('onPageEnd: ' + event?.url);
        })
        .onErrorReceive((event) => {
          console.error('onErrorReceive: ' + event?.error);
        })

      // button area
      Row() {
        Button('不同意', { type: ButtonType.Normal, stateEffect: true })
          .width(120)
          .height(40)
          .fontSize(16)
          .borderRadius(8)
          .fontColor('#F47732')
          .backgroundColor('#FFFFFF')
          .borderColor('#F47732')
          .onClick(() => {
            this.controller.close()
          })

        Blank().layoutWeight(1)

        Button('同意', { type: ButtonType.Normal, stateEffect: true })
          .width(120)
          .height(40)
          .fontSize(16)
          .borderRadius(8)
          .fontColor('#F47732')
          .backgroundColor('#FFFFFF')
          .borderColor('#F47732')
          .onClick(() => {
            if (this.onAgree) {
              this.onAgree();
            }
            this.controller.close();
          })
      }
      .width('100%')
      .padding(16)
    }
    .width('90%')
    .height('77%')
    .borderRadius(16)
    .backgroundColor('#FFFFFF')
    .shadow({
      radius: 24,
      color: '#1A000000',
      offsetX: 0,
      offsetY: 8
    })
  }
}