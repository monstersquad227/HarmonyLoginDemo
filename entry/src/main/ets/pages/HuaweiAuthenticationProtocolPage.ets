import { webview } from "@kit.ArkWeb";

@Component
export struct HuaweiAuthenticationProtocolPage {
    controller: webview.WebviewController = new webview.WebviewController();
    @State isLoading: boolean = true;
    @State loadError: boolean = false;

    build() {
        NavDestination() {
            Column() {
                // 加载指示器
                if (this.isLoading && !this.loadError) {
                    Column() {
                        LoadingProgress()
                            .color('#007DFF')
                            .width(50)
                            .height(50)
                            .margin({ bottom: 16 })

                        Text('加载中...')
                            .fontSize(14)
                            .fontColor('#999999')
                    }
                    .width('100%')
                    .height('100%')
                    .justifyContent(FlexAlign.Center)
                    .backgroundColor('#F7F8FA')
                }

                // 加载错误提示
                if (this.loadError) {
                    Column() {
                        Text('⚠️')
                            .fontSize(48)
                            .margin({ bottom: 16 })

                        Text('页面加载失败')
                            .fontSize(16)
                            .fontColor('#333333')
                            .margin({ bottom: 8 })

                        Text('请检查网络连接后重试')
                            .fontSize(14)
                            .fontColor('#999999')
                            .margin({ bottom: 24 })

                        Button('重新加载')
                            .width(120)
                            .height(40)
                            .fontSize(15)
                            .backgroundColor('#007DFF')
                            .borderRadius(20)
                            .onClick(() => {
                                this.loadError = false;
                                this.isLoading = true;
                                this.controller.refresh();
                            })
                    }
                    .width('100%')
                    .height('100%')
                    .justifyContent(FlexAlign.Center)
                    .backgroundColor('#F7F8FA')
                }

                // WebView
                Web({
                    src: 'https://privacy.consumer.huawei.com/legal/id/authentication-terms.htm?code=CN&language=zh-CN',
                    controller: this.controller
                })
                    .width('100%')
                    .height('100%')
                    .visibility(this.isLoading || this.loadError ? Visibility.Hidden : Visibility.Visible)
                    .onPageBegin(() => {
                        this.isLoading = true;
                        this.loadError = false;
                    })
                    .onPageEnd(() => {
                        this.isLoading = false;
                    })
                    .onErrorReceive(() => {
                        this.isLoading = false;
                        this.loadError = true;
                    })
            }
            .width('100%')
            .height('100%')
            .backgroundColor('#F7F8FA')
        }
        .title('华为账号用户认证协议')
    }
}