import {
  ATSDK,
  ATInitConfiguration,
  ATCustomGroupConfig,
  AT_CUSTOM_RULE_KEY,
  AT_PERSONALIZED_AD
} from 'anythink_sdk';
import { router } from '@kit.ArkUI';
import { ToastUtil } from '../utils/ToastUtil';
import { abilityAccessCtrl, common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { CustomButton } from '../view/custom-button';
import hilog from '@ohos.hilog';
import { SharedPreferences } from '../utils/SPUtil';
import { PrivacyComponent } from '../view/PrivacyComponent';

const TAG = "Anythink Ad Demo";

@Entry
@Component
struct Index {
  // sdk params
  readonly APP_ID = "a6704d2dda04f7";
  readonly APP_KEY = "4f7b9ac17decb9babec83aac078742c7";
  // personalized advertising service toggle
  @State personalizedAdEnabled: boolean =
    SharedPreferences.getSync(getContext(this), 'personalizedAdEnabled', false) as boolean;
  @State personalizedText: string = this.personalizedAdEnabled ? '当前状态：开始' : '当前状态：关闭';
  // anything sdk state
  private isInitSdkSucceed = false;
  // privacy dialog
  private dialogController: CustomDialogController | null = null;

  //demo view
  build() {
    Column() {
      CustomButton({
        mText: "初始化SDK",
        mHeight: 55,
        mOnClick: () => {
          if (this.isInitSdkSucceed) {
            ToastUtil.show("已初始化成功");
            return;
          }
          this.showPrivacyDialog()
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
      Row() {
        Column() {
          Text('个性化广告服务').fontSize(20).fontWeight(FontWeight.Bold).align(Alignment.Start)
          Text(this.personalizedText)
            .fontSize(16)
            .margin({ top: 8 })
            .fontColor(Color.Gray)
            .align(Alignment.Start)
        }
        .layoutWeight(1)

        Checkbox().select(this.personalizedAdEnabled)
          .onChange((check: boolean) => {
            this.personalizedAdEnabled = check
            SharedPreferences.put(getContext(this), 'personalizedAdEnabled', check)
            check ? this.personalizedText = '当前状态：开启' : this.personalizedText = '当前状态：关闭'
          })
          .width(32)
          .height(32)
      }
      .margin(50)
    }
    .justifyContent(FlexAlign.Center)
    .height('100%')
    .width('100%')
  }

  // Show privacy policy dialog, you can decide whether to display the dialog every time or not according to your actual needs
  // 显示隐私政策对话框，可根据实际需求自行决定是否每次显示对话框，第二次直接requestOAIDTrackingConsentPermissions
  private showPrivacyDialog() {
    this.dialogController = new CustomDialogController({
      builder: PrivacyComponent({
        onAgree: () => {
          console.log('用户同意了隐私政策');
          this.requestOAIDTrackingConsentPermissions(getContext());
        }
      }),
      autoCancel: false,
      customStyle: true
    });
    this.dialogController.open();
  }

  //request oaid permissions
  private requestOAIDTrackingConsentPermissions(context: common.Context): void {
    const atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    try {
      atManager.requestPermissionsFromUser(context, ["ohos.permission.APP_TRACKING_CONSENT"]).then((data) => {
        if (data.authResults[0] == 0) {
          hilog.info(0, TAG, 'succeeded in requesting permission');
        } else {
          hilog.info(0, TAG, 'user rejected');
        }
        this.initAndStartATSDK();//you need init and start the sdk after request
      }).catch((err: BusinessError) => {
        hilog.error(0, TAG, `request permission failed, error: ${err.code} ${err.message}`);
        this.initAndStartATSDK();//init if sys raises the request err
      })
    } catch (err) {
      hilog.error(0, TAG, `catch err->${err.code}, ${err.message}`);
      this.initAndStartATSDK();//init if manager raises the api err
    }
  }

  //init and start the sdk after privacy and oaid business
  private initAndStartATSDK() {
    if (this.isInitSdkSucceed) {
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
      personalizedAdStatus: this.personalizedAdEnabled ? AT_PERSONALIZED_AD.ALLOW : AT_PERSONALIZED_AD.LIMIT,//Recommended to set AT_PERSONALIZED_AD.ALLOW
      // privacyConfig: {
      //   disableDeviceInfos: [ATDeviceInfo.MAC,ATDeviceInfo.ODID]
      // }
    }
    // console.debug("init sdk start " + AGENT_EVENT_TYPE.INIT_CALLED.valueOf());
    ATSDK.init(getContext().getApplicationContext(), configuration);
    ATSDK.start().then((result) => {
      this.isInitSdkSucceed = true;
      ToastUtil.show("初始化成功");
    });
  }
}

