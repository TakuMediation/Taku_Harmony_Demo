import { ATAdError, ATAdInfo, formatAdError } from "anythink_sdk";
import { hilog } from "@kit.PerformanceAnalysisKit";

/**
 * Description:
 * Created by Quin on 2024/9/27
 **/

export enum LOG_LEVEL {
  DEBUG,
  ERROR
}

export function logMsg(msg: string, adInfo?: ATAdInfo, adError?: ATAdError, level?: LOG_LEVEL) {
  let adErrorMsg = ''
  if (adError) {
    adErrorMsg = ", adError: " + formatAdError(adError)
  }
  let adInfoMsg = ''
  if (adInfo) {
    adInfoMsg = "adInfo: " + adInfo?.toString();
  }
  const fullMsg = `${msg} ${adInfoMsg} ${adErrorMsg}`;
  if (level == LOG_LEVEL.ERROR) {
    hilog.error(0, "anythink_demo", fullMsg, "");
  } else {
    hilog.debug(0, "anythink_demo", fullMsg, "");
  }
}