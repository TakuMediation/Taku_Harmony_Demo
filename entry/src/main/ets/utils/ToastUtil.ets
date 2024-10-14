import { promptAction } from '@kit.ArkUI'

export class ToastUtil {
  static toastArray: Array<promptAction.ShowToastOptions> = new Array();
  static toastShowing: boolean = false;

  static show(msg: string, duration = 2000) {
    ToastUtil.toastArray.push({ message: msg, duration: duration });
    ToastUtil.scheduleToast();
  }

  static scheduleToast() {
    if (ToastUtil.toastShowing) {
      return;
    }
    if (ToastUtil.toastArray.length > 0) {
      ToastUtil.toastShowing = true;
      const toast = ToastUtil.toastArray.shift()
      promptAction.showToast(toast);
      setTimeout(() => {
        ToastUtil.toastShowing = false
        ToastUtil.scheduleToast();
      }, 100 + (toast?.duration || 0));
    }
  }
}