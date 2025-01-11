import {
  ATSDK,
  ATInitConfiguration,
  ATCustomGroupConfig,
  AT_CUSTOM_RULE_KEY,
  AT_PERSONALIZED_AD,
  ATDeviceInfo
} from 'anythink_sdk';
import { router } from '@kit.ArkUI';
import { PlacementIdBean } from '../viewmodel/PlacementIdBean';
import { ToastUtil } from '../utils/ToastUtil';
import { abilityAccessCtrl, common } from '@kit.AbilityKit';
import HiAdLog from 'anythink_network_huawei/src/main/ets/anythink/network/hw/HiAdLog';
import { BusinessError } from '@kit.BasicServicesKit';
import { CustomButton } from '../view/custom-button';

const TAG = "Anythink Ad Demo";

@Entry
@Component
struct Index {
  readonly APP_ID = "a6704d2dda04f7";
  readonly APP_KEY = "4f7b9ac17decb9babec83aac078742c7";
  private isInitSdkSucceed = false;

  aboutToAppear(): void {
    this.requestOAIDTrackingConsentPermissions(getContext());
  }

  build() {
    Column() {
      CustomButton({
        mText: "初始化SDK",
        mHeight: 55,
        mOnClick: (event) => {
          if (this.isInitSdkSucceed) {
            ToastUtil.show("已初始化成功");
            return;
          }
          const customRuleMap: Record<string, Object> = {};
          customRuleMap[AT_CUSTOM_RULE_KEY.AGE] = "18";
          customRuleMap[AT_CUSTOM_RULE_KEY.GENDER] = "male";
          customRuleMap[AT_CUSTOM_RULE_KEY.CHANNEL] = "harmony";
          //自定义规则
          customRuleMap["type"] = "normal_wf";

          const customGroupConfig: ATCustomGroupConfig = {
            //广告位设置自定义规则，仅对当前Placement有效
            // placementCustomMap: { "b6704d32537317": customRuleMap },
            //应用设置自定义规则，对全部广告位有效
            // appCustomMap: customRuleMap
          }
          let configuration: ATInitConfiguration = {
            appId: this.APP_ID,
            appKey: this.APP_KEY,
            networkLogDebug: true,
            customGroupConfig: customGroupConfig,
            personalizedAdStatus: AT_PERSONALIZED_AD.ALLOW,
            // privacyConfig: {
            //   disableDeviceInfos: [ATDeviceInfo.MAC,ATDeviceInfo.ODID]
            // }
          }
          // console.debug("init sdk start " + AGENT_EVENT_TYPE.INIT_CALLED.valueOf());
          ATSDK.init(getContext().getApplicationContext(), configuration)
          ATSDK.start().then((result) => {
            this.isInitSdkSucceed = true;
            ToastUtil.show("初始化成功");
          })
        }
      })
      CustomButton({
        mText: "开始展示广告",
        mHeight: 55,
        mOnClick: () => {
          if (!this.isInitSdkSucceed) {
            ToastUtil.show('Please init sdk first.')
            return
          }
          router.pushUrl({
            url: "pages/NetworksAdPage",
          })
        }
      }).margin({ top: 50 })
    }
    .justifyContent(FlexAlign.Center)
    .height('100%')
    .width('100%')
  }

  private requestOAIDTrackingConsentPermissions(context: common.Context): void {
    // 进入页面时触发动态授权弹框，向用户请求授权广告跟踪权限
    const atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    try {
      atManager.requestPermissionsFromUser(context, ["ohos.permission.APP_TRACKING_CONSENT"]).then((data) => {
        if (data.authResults[0] == 0) {
          HiAdLog.i(TAG, 'succeeded in requesting permission');
        } else {
          HiAdLog.i(TAG, 'user rejected');
        }
      }).catch((err: BusinessError) => {
        HiAdLog.e(TAG, `request permission failed, error: ${err.code} ${err.message}`);
      })
    } catch (err) {
      HiAdLog.e(TAG, `catch err->${err.code}, ${err.message}`);
    }
  }
}

