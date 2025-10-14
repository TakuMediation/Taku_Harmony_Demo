import { preferences } from '@kit.ArkData';
import dataPreferences from '@ohos.data.preferences';
import { Context } from '@kit.AbilityKit';

export class SharedPreferences {
  private static defaultPreferenceName: string = "SP_DEMO_PREFERENCES";
  private static preferences: preferences.Preferences;

  private constructor() {
  }

  /**
   * Get preferences value in the sync state
   * @param key
   * @param defValue
   * @returns
   */
  static getSync(context: Context, key: string, defValue: preferences.ValueType,
    preferenceName: string = SharedPreferences.defaultPreferenceName): preferences.ValueType {
    let preferences = SharedPreferences.getPreferencesSync(context, preferenceName); //获取实例
    try {
      return preferences.getSync(key, defValue);
    } catch (e) {
      return defValue
    }
  }

  /**
   * Store the preferences value in the async state
   * @param key
   * @param value
   */
  static async put(context: Context, key: string, value: preferences.ValueType,
    preferenceName: string = SharedPreferences.defaultPreferenceName) {
    let preferences = await SharedPreferences.getPreferences(context, preferenceName); //获取实例
    await preferences.put(key, value);
    await preferences.flush();
  }

  private static async getPreferences(context: Context,
    preferenceName: string = SharedPreferences.defaultPreferenceName): Promise<preferences.Preferences> {
    if (preferenceName !== SharedPreferences.defaultPreferenceName) {
      return await dataPreferences.getPreferences(context, preferenceName);
    } else if (!SharedPreferences.preferences) {
      SharedPreferences.preferences = await dataPreferences.getPreferences(context, preferenceName);
    }
    return SharedPreferences.preferences;
  }

  private static getPreferencesSync(context: Context,
    preferenceName: string = SharedPreferences.defaultPreferenceName): preferences.Preferences {
    if (preferenceName !== SharedPreferences.defaultPreferenceName) {
      return dataPreferences.getPreferencesSync(context, { name: preferenceName });
    } else if (!SharedPreferences.preferences) {
      SharedPreferences.preferences = dataPreferences.getPreferencesSync(context, { name: preferenceName });
    }
    return SharedPreferences.preferences;
  }
}