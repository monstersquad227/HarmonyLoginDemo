import { PersonalInfoPage, PersonalInfoParam } from './PersonalInfoPage';
import { NoticePage } from './NoticePage';
import { FeedbackPage } from './FeedbackPage';
import { router } from '@kit.ArkUI';
import { authentication } from '@kit.AccountKit';
import { util } from '@kit.ArkTS';
import { notificationManager } from '@kit.NotificationKit';
import { common } from '@kit.AbilityKit';
import { loginManager } from '../manager/LoginManager';

@Entry
@Component
export struct ProfilePage {
    @State avatar: string | undefined = '';
    @State nickname: string | undefined = '';
    @State openID: string | undefined = '';
    @State email: string | undefined = '';
    @StorageLink('NOTIFICATION') isNotificationEnabled: boolean = false;
    private navPathStack: NavPathStack = new NavPathStack();

    async aboutToAppear() {
        await this.loadUserInfo();
    }

    loadUserInfo() {
        const authRequest = new authentication.HuaweiIDProvider().createAuthorizationWithHuaweiIDRequest();
        authRequest.scopes = ['profile', 'email', 'openid'];
        authRequest.forceAuthorization = true;
        authRequest.state = util.generateRandomUUID();

        const controller =
            new authentication.AuthenticationController(this.getUIContext().getHostContext());
        controller.executeRequest(authRequest).then((data) => {
            const authorizationWithHuaweiIDResponse =
                data as authentication.AuthorizationWithHuaweiIDResponse;
            const state = authorizationWithHuaweiIDResponse?.state;
            if (state && authRequest.state !== state) {
                console.error('Failed to authorize. The state is different, response state:', state);
                return;
            }
            const authorizationWithHuaweiIDCredential = authorizationWithHuaweiIDResponse?.data;
            this.avatar = authorizationWithHuaweiIDCredential?.avatarUri;
            this.nickname = authorizationWithHuaweiIDCredential?.nickName;
            this.openID = authorizationWithHuaweiIDCredential?.openID;
            this.email = authorizationWithHuaweiIDCredential?.email;
        })
    }

    onPageShow(): void {
        console.log('pageShow')
    }

    // 请求通知权限
    async requestNotificationPermission() {
        try {
            const context = getContext(this) as common.UIAbilityContext;
            await notificationManager.requestEnableNotification(context);

            // 权限请求后由 MainTabs 的 onAppear 来检查并更新 AppStorage
            AlertDialog.show({
                message: '通知权限已开启,您将收到按时吃药的提醒',
                buttons: [{ value: '知道了', action: () => {} }]
            });
        } catch (err) {
            console.error('notification 请求通知权限失败:' + JSON.stringify(err));
            // 用户拒绝了权限请求,引导去系统设置
            this.openSystemSettings();
        }
    }

    // 跳转到系统设置
    openSystemSettings() {
        AlertDialog.show({
            title: '通知权限未开启',
            message: '为了接收服药提醒,请前往设置打开通知权限',
            primaryButton: {
                value: '前往设置',
                action: () => {
                    try {
                        const context = getContext(this) as common.UIAbilityContext;
                        notificationManager.openNotificationSettings(context);
                        // 用户从设置返回后，再次切换到该 Tab 时会自动检查权限
                    } catch (err) {
                        console.error('notification 打开设置失败:' + JSON.stringify(err));
                    }
                }
            },
            secondaryButton: {
                value: '取消',
                action: () => {
                    // 用户取消后恢复 Toggle 状态
                    this.isNotificationEnabled = AppStorage.get('NOTIFICATION') || false;
                }
            }
        });
    }

    handleLogout() {
        loginManager.logout();
        router.replaceUrl({ url: 'pages/Index' })
    }

    build() {
        Navigation(this.navPathStack) {
            Column() {
                // 用户信息卡片
                Column() {
                    // 头像
                    Image(this.avatar ? this.avatar : $r('app.media.userAvatar'))
                        .width(80)
                        .height(80)
                        .borderRadius(40)
                        .margin({ bottom: 16 })
                        .border({ width: 3, color: '#E6F3FF' })

                    // 用户名
                    Text(this.nickname? this.nickname : '用户8271034905')
                        .fontSize(20)
                        .fontWeight(FontWeight.Bold)
                        .fontColor('#111111')
                        .margin({ bottom: 8 })
                }
                .width('92%')
                .margin({ left: '4%', right: '4%', top: 12, bottom: 16 })
                .padding({ top: 30, bottom: 30 })
                .backgroundColor($r('sys.color.comp_background_list_card'))
                .borderRadius(12)
                .shadow({ radius: 8, color: '#12000000', offsetX: 0, offsetY: 2 })

                // 设置列表
                Column() {
                    this.SettingItem('个人信息', () => {
                        this.navPathStack.pushPath({ name: 'PersonalInfoPage', param: {
                            avatar: this.avatar,
                            nickname: this.nickname,
                            email: this.email
                        } as PersonalInfoParam });
                    })

                    Divider()
                        .color('#F0F0F0')
                        .margin({ left: 52 })

                    this.SettingItem('常见问题', () => {
                        this.navPathStack.pushPath({ name: 'NoticePage' });
                    })

                    Divider()
                        .color('#F0F0F0')
                        .margin({ left: 52 })

                    this.SettingItem('功能反馈', () => {
                        this.navPathStack.pushPath({ name: 'FeedbackPage' });
                    })
                }
                .width('92%')
                .margin({ left: '4%', right: '4%', bottom: 16 })
                .backgroundColor($r('sys.color.comp_background_list_card'))
                .borderRadius(12)
                .shadow({ radius: 8, color: '#12000000', offsetX: 0, offsetY: 2 })

                // 退出登录按钮
                Button('退出登录')
                    .width('92%')
                    .height(48)
                    .margin({ left: '4%', right: '4%', top: 20 })
                    .fontSize(16)
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#FF3B30')
                    .backgroundColor($r('sys.color.comp_background_list_card'))
                    .border({ width: 1, color: '#FF3B30', radius: 24 })
                    .onClick(() => {
                        AlertDialog.show({
                            message: '确定要退出登录吗？',
                            buttons: [
                                {
                                    value: '取消',
                                    action: () => {}
                                },
                                {
                                    value: '退出',
                                    action: () => {
                                        this.handleLogout();
                                    }
                                }
                            ]
                        });
                    })
            }
            .width('100%')
            .height('100%')
            .backgroundColor('#F7F8FA')
        }
        .navDestination(this.navDestinationBuilder)
    }

    @Builder
    navDestinationBuilder(name: string, param: Object) {
        if (name === 'PersonalInfoPage') {
            PersonalInfoPage(param)
        } else if (name === 'NoticePage') {
            NoticePage()
        } else if (name === 'FeedbackPage') {
            FeedbackPage()
        }
    }

    @Builder
    SettingItem(title: string, onClick: () => void) {
        Row() {
            Row()
                .width(32)
                .height(32)
                .backgroundColor('#E6F3FF')
                .borderRadius(8)
                .margin({ right: 12 })

            Text(title)
                .fontSize(16)
                .fontColor('#333333')
                .layoutWeight(1)

            Image($r('sys.symbol.chevron_right'))
                .width(20)
                .height(20)
                .fillColor('#CCCCCC')
        }
        .width('100%')
        .height(56)
        .padding({ left: 16, right: 16 })
        .onClick(onClick)
    }
}