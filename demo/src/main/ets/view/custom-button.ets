/*
 * Copyright 2023. Huawei Technologies Co., Ltd. All rights reserved.

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
 */

@Component
export struct CustomButton {
  @State mText: string | Resource = '';
  mHeight: number = 40;
  mOnClick: (event?: ClickEvent) => void = (): void => {};

  build() {
    Column() {
      Button(this.mText)
        // .backgroundColor('#d3d4d6')
        .fontSize(20)
        // .fontColor('#000')
        .fontWeight(FontWeight.Normal)
        .align(Alignment.Center)
        .type(ButtonType.Capsule)
        .width('90%')
        .height(this.mHeight)
        .margin({ top: 10, bottom: 5 })
        .onClick(this.mOnClick);
    }
  }
}