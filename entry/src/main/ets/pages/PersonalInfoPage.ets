import { VibrationUtil } from "../common/VibrationUtil";

export interface PersonalInfoParam {
    avatar: string;
    nickname: string;
    email: string;
}

@Component
export struct PersonalInfoPage {
    @State avatar: string = '';
    @State nickname: string = '';
    @State email: string = '';
    @State isNotificationEnabled: boolean = false;

    onInit(params?: PersonalInfoParam) {
        if (params) {
            this.avatar = params.avatar;
            this.nickname = params.nickname;
            this.email = params.email;
        }
    }

    // 隐私手机号处理
    anonymousPhone(phone: string): string {
        return phone.replace(/(\d{3})\d{4}(\d{4})/, '$1****$2')
    }

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
                            Image(this.avatar ? this.avatar : $r('app.media.userAvatar'))
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
                            Text(this.nickname ? this.nickname : 'admin')
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
                            Text(this.anonymousPhone(AppStorage.get('login_phone') || '15056332824'))
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

                    // 邮箱
                    Row() {
                        Text('邮箱')
                            .fontSize(16)
                            .fontColor('#333333')
                            .layoutWeight(1)

                        Row() {
                            Text(this.email)
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
                }
                .width('92%')
                .margin({ left: '4%', right: '4%', top: 12 })
                .backgroundColor($r('sys.color.comp_background_list_card'))
                .borderRadius(12)
                .shadow({ radius: 8, color: '#12000000', offsetX: 0, offsetY: 2 })
            }
            .width('100%')
            .height('100%')
            .backgroundColor('#F7F8FA')
        }
        .title('个人信息')
        .onBackPressed(() => {
            // 触发震动反馈
            VibrationUtil.light();
            return false;
        })
    }
}