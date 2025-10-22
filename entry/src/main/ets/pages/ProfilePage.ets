import { LoginManager, UserInfo } from '../manager/LoginManager';
import { PersonalInfoPage, PersonalInfoParam } from './PersonalInfoPage';
import { NoticePage } from './NoticePage';
import { FeedbackPage } from './FeedbackPage';
import { router } from '@kit.ArkUI';
import { authentication } from '@kit.AccountKit';
import { util } from '@kit.ArkTS';

@Entry
@Component
export struct ProfilePage {
    @State avatar: string | undefined = '';
    @State nickname: string | undefined = '';
    @State openID: string | undefined = '';
    @State email: string | undefined = '';
    // @State userInfo: UserInfo | null = null;
    // @State remainingDays: number = 0;
    private loginManager: LoginManager = LoginManager.getInstance();
    private navPathStack: NavPathStack = new NavPathStack();

    aboutToAppear() {
        this.loadUserInfo();
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
            // console.info('profileInfo email: ', authorizationWithHuaweiIDCredential?.email)
            // console.info('profileInfo idToken: ', authorizationWithHuaweiIDCredential?.idToken)
            // console.info('profileInfo unionID: ', authorizationWithHuaweiIDCredential?.unionID)
            // console.info('profileInfo extraInfo: ', authorizationWithHuaweiIDCredential?.extraInfo)
            // console.info('profileInfo openID: ', authorizationWithHuaweiIDCredential?.openID)
        })
    }

    handleLogout() {
        this.loginManager.logout();
        router.replaceUrl({ url: 'pages/Index' })
        // 重启应用
        // const context = getContext(this) as common.UIAbilityContext;
        // context.startAbility(Want.prototype);
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
                    // Text(this.userInfo?.username || '用户8271034905')
                    Text(this.nickname? this.nickname : '用户8271034905')
                        .fontSize(20)
                        .fontWeight(FontWeight.Bold)
                        .fontColor('#111111')
                        .margin({ bottom: 8 })

                    // 用户ID或其他信息（可选）
                    // Text(this.email ? this.email : 'ID: 8271034905')
                    //     .fontSize(14)
                    //     .fontColor('#999999')
                }
                .width('92%')
                .margin({ left: '4%', right: '4%', top: 12, bottom: 16 })
                .padding({ top: 30, bottom: 30 })
                .backgroundColor('#FFFFFF')
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
                .backgroundColor('#FFFFFF')
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
                    .backgroundColor('#FFFFFF')
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
            // 图标占位（可以根据不同项目添加不同图标）
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