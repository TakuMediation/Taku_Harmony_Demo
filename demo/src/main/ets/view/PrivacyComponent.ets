import { webview } from '@kit.ArkWeb';
import { BusinessError } from '@kit.BasicServicesKit';
import { ToastUtil } from '../utils/ToastUtil';

@CustomDialog
export struct PrivacyComponent {
  controller: CustomDialogController = new CustomDialogController({
    builder: this
  });
  // 同意回调函数
  onAgree?: () => void;
  // WebView控制器
  private webviewController: webview.WebviewController = new webview.WebviewController();
  // 隐私政策URL
  private privacyUrl: string = "https://www.takuad.com/privacy-policy";

  // 显示对话框
  aboutToAppear() {
  }

  build() {
    Column() {
      // WebView内容区域
      Web({
        src: this.privacyUrl,
        controller: this.webviewController,
      })
        .width('100%')
        .height('100%')
        .cacheMode(CacheMode.Default)// 默认缓存模式
        .zoomAccess(true)
        .imageAccess(true)
        .javaScriptAccess(true)// 允许JavaScript
        .domStorageAccess(true)//开启文档对象模型存储接口
        .databaseAccess(true)// 是否开启数据库存储API权限
        .mixedMode(MixedMode.All)// 允许加载HTTP和HTTPS混合内容
        .onlineImageAccess(true)
        .backgroundColor('#FFFFFF')
        .onPageBegin((event) => {
          console.log('开始加载页面: ' + event?.url);
        })
        .onPageEnd((event) => {
          console.log('页面加载完成: ' + event?.url);
        })
        .onErrorReceive((event) => {
          console.error('页面加载错误: ' + event?.error);
        })

      // 按钮区域
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

  // 加载URL
  private loadUrl() {
    try {
      this.webviewController.loadUrl(this.privacyUrl);
    } catch (error) {
      //const err: BusinessError = error as BusinessError;
      //ToastUtil.show(`加载URL失败: ${err.code}, ${err.message}`)
    }
  }
}