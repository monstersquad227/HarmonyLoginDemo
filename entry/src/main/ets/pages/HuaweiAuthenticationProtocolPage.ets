import { webview } from "@kit.ArkWeb";

@Component
export struct HuaweiAuthenticationProtocolPage {
    controller: webview.WebviewController = new webview.WebviewController();

    build() {
        NavDestination() {
            Column() {
                Web({ src: 'https://privacy.consumer.huawei.com/legal/id/authentication-terms.htm?code=CN&language=zh-CN', controller: this.controller })
                    .width('100%')
                    .height('100%')
            }
            .width('100%')
            .height('100%')
            .backgroundColor('#F5F5F5')
        }
        .title('华为账号用户认证协议')
    }
}