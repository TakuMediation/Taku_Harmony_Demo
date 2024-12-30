/**
 * Description:
 * Created by Quin on 2024/10/9
 **/
export function getStringByResId(context: Context, resource: Resource): string {
  let resMgr = context.resourceManager;
  return resMgr.getStringSync(resource);
}