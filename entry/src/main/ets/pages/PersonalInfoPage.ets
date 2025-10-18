import { LoginManager } from "../common/LoginManager";

@Entry
@Component
export struct PersonalInfoPage {

    private loginManager: LoginManager = LoginManager.getInstance();

    build() {
        NavDestination() {
            Column() {
                // 个人信息卡片
                Column() {
                    // 头像项
                    Row() {
                        Text('头像')
                            .fontSize(16)
                            .fontColor('#333333')
                            .layoutWeight(1)

                        Row() {
                            Image($r('app.media.userAvatar'))
                                .width(50)
                                .height(50)
                                .borderRadius(25)
                                .margin({ right: 8 })

                            Image($r('sys.symbol.chevron_right'))
                                .width(20)
                                .height(20)
                                .fillColor('#CCCCCC')
                            }
                        }
                        .width('100%')
                        .height(70)
                        .padding({ left: 16, right: 16 })
                        .onClick(() => {
                          // TODO: 修改头像逻辑
                        })

                        Divider()
                            .color('#F0F0F0')
                            .margin({ left: 16 })

                        // 昵称项
                        Row() {
                            Text('昵称')
                                .fontSize(16)
                                .fontColor('#333333')
                                .layoutWeight(1)

                            Row() {
                                Text('admin')
                                    .fontSize(16)
                                    .fontColor('#999999')
                                    .margin({ right: 8 })

                                Image($r('sys.symbol.chevron_right'))
                                    .width(20)
                                    .height(20)
                                    .fillColor('#CCCCCC')
                            }
                        }
                        .width('100%')
                        .height(56)
                        .padding({ left: 16, right: 16 })
                        .onClick(() => {
                            // TODO: 修改昵称逻辑
                        })

                        Divider()
                            .color('#F0F0F0')
                            .margin({ left: 16 })

                        // 手机号项
                        Row() {
                            Text('手机号')
                                .fontSize(16)
                                .fontColor('#333333')
                                .layoutWeight(1)

                            Row() {
                                Text('150****2824')
                                    .fontSize(16)
                                    .fontColor('#999999')
                                    .margin({ right: 8 })

                                Image($r('sys.symbol.chevron_right'))
                                    .width(20)
                                    .height(20)
                                    .fillColor('#CCCCCC')
                            }
                        }
                        .width('100%')
                        .height(56)
                        .padding({ left: 16, right: 16 })
                        .onClick(() => {
                            // TODO: 修改手机号逻辑
                        })
                    }.width('92%')
                    .margin({ left: '4%', right: '4%', top: 12 })
                    .backgroundColor('#FFFFFF')
                    .borderRadius(12)
                    .shadow({ radius: 8, color: '#12000000', offsetX: 0, offsetY: 2 })

                    // Blank().layoutWeight(1)
            }
            .width('100%')
            .height('100%')
            .backgroundColor('#F7F8FA')
        }
        .title('个人信息')
        .onBackPressed(() => {
            return false;
        })
    }
}