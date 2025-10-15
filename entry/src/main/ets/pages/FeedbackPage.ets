import { webview } from "@kit.ArkWeb";

@Entry
@Component
export struct FeedbackPage {
    controller: webview.WebviewController = new webview.WebviewController();

    build() {
        NavDestination() {
            Column() {
                Web({ src: 'https://fcl4m4bwfn.feishu.cn/share/base/form/shrcnBj0sHhbzrBzxhhWesk1P3d', controller: this.controller })
                    .width('100%')
                    .height('100%')
            }
            .width('100%')
            .height('100%')
            .backgroundColor('#F5F5F5')
        }
        .title('功能反馈')
    }
}