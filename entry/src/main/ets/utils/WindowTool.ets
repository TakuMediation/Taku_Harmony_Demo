import { window } from '@kit.ArkUI';
import { bundleManager, common } from '@kit.AbilityKit';

export interface Rect {
  left: number;
  right: number;
  bottom: number;
  top: number;
}

// window 工具类
class WindowTool {
  setShowFullscreenMode(context: Context, fullscreenMode: boolean) {
    window.getLastWindow(context).then((lastWindow: window.Window) => {
      lastWindow.setWindowLayoutFullScreen(fullscreenMode);
    });
  }

  setOrientation(context: Context, orientation: window.Orientation) {
    window.getLastWindow(context).then((lastWindow: window.Window) => {
      lastWindow.setPreferredOrientation(orientation);
    });
  }

  getAvoidArea(context: Context): Promise<Rect> {
    return new Promise((resolve, reject) => {
      window.getLastWindow(context).then((lastWindow: window.Window) => {
        let navigationArea = lastWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
        let systemArea = lastWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
        let cutoutArea = lastWindow.getWindowAvoidArea(window.AvoidAreaType.TYPE_CUTOUT);
        let property = lastWindow.getWindowProperties();
        const isFullscreen = property.isLayoutFullScreen;
        let avoidArea: Rect = {
          left: px2vp(cutoutArea.leftRect.width),
          right: px2vp(cutoutArea.rightRect.width),
          top: isFullscreen ? px2vp(systemArea.topRect.height) : 0,
          bottom: isFullscreen ? px2vp(navigationArea.topRect.height) : 0
        }
        resolve(avoidArea);
      });
    });
  }

  isOrientationPortrait(context: common.UIAbilityContext): boolean {
    return context.abilityInfo.orientation === bundleManager.DisplayOrientation.PORTRAIT ?? false;
  }
}

let windowTool = new WindowTool();

export default windowTool;