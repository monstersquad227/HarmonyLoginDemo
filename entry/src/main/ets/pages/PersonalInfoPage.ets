import { LoginManager } from "../common/LoginManager";
import { router } from "@kit.ArkUI";
import { notificationManager } from '@kit.NotificationKit';
import { bundleManager } from '@kit.AbilityKit';
import { common } from '@kit.AbilityKit';

@Entry
@Component
export struct PersonalInfoPage {

    private loginManager: LoginManager = LoginManager.getInstance();
    @State isNotificationEnabled: boolean = false;

    async aboutToAppear() {
        await this.checkNotificationEnabled();
    }

    // 检查通知权限状态
    async checkNotificationEnabled() {
        try {
            const context = getContext(this) as common.UIAbilityContext;
            const bundleInfo = await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT);
            const isEnabled = await notificationManager.isNotificationEnabled();
            this.isNotificationEnabled = isEnabled;
        } catch (err) {
            console.error('检查通知权限失败:', err);
            this.isNotificationEnabled = false;
        }
    }

    // 请求通知权限
    async requestNotificationPermission() {
        try {
            await notificationManager.requestEnableNotification();
            // 重新检查权限状态
            await this.checkNotificationEnabled();

            if (this.isNotificationEnabled) {
                AlertDialog.show({
                    message: '通知权限已开启，您将收到按时吃药的提醒'
                });
            }
        } catch (err) {
            console.error('请求通知权限失败:', err);
            AlertDialog.show({
                message: '开启通知权限失败，请在系统设置中手动开启'
            });
        }
    }

    // 跳转到系统设置
    openSystemSettings() {
        AlertDialog.show({
            message: '请在系统设置中开启通知权限',
            buttons: [
                {
                    value: '取消',
                    action: () => {}
                },
                {
                    value: '去设置',
                    action: () => {
                        // 这里可以尝试打开系统设置（具体实现可能需要根据设备调整）
                        console.log('跳转到系统设置');
                    }
                }
            ]
        });
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
                }
                .width('92%')
                .margin({ left: '4%', right: '4%', top: 12 })
                .backgroundColor($r('sys.color.comp_background_list_card'))
                .borderRadius(12)
                .shadow({ radius: 8, color: '#12000000', offsetX: 0, offsetY: 2 })

                // 通知权限卡片
                Column() {
                    Row() {
                        Column({ space: 4 }) {
                            Text('通知提醒')
                                .fontSize(16)
                                .fontColor('#333333')
                                .alignSelf(ItemAlign.Start)

                            Text('开启后可接收吃药提醒')
                                .fontSize(13)
                                .fontColor('#999999')
                                .alignSelf(ItemAlign.Start)
                        }
                        .alignItems(HorizontalAlign.Start)
                        .layoutWeight(1)

                        Toggle({ type: ToggleType.Switch, isOn: this.isNotificationEnabled })
                            .selectedColor('#007DFF')
                            .onChange(async (isOn: boolean) => {
                                if (isOn && !this.isNotificationEnabled) {
                                    // 用户想要开启通知
                                    await this.requestNotificationPermission();
                                } else if (!isOn && this.isNotificationEnabled) {
                                    // 用户想要关闭通知
                                    this.openSystemSettings();
                                }
                            })
                    }
                    .width('100%')
                    .height(70)
                    .padding({ left: 16, right: 16 })
                }
                .width('92%')
                .margin({ left: '4%', right: '4%', top: 16 })
                .backgroundColor('#FFFFFF')
                .borderRadius(12)
                .shadow({ radius: 8, color: '#12000000', offsetX: 0, offsetY: 2 })
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