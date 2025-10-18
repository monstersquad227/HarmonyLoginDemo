import { LoginManager } from '../common/LoginManager';
import { HomePage } from './HomePage';
import { PlanPage } from './PlanPage';
import { PostListPage } from './PostListPage';
import { ProfilePage } from './ProfilePage';
import { RecordPage } from './RecordPage';
import { loginComponentManager, LoginWithHuaweiIDButton } from '@kit.AccountKit';
import { promptAction } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { UserAgreementPage } from './UserAgreementPage';
import { PrivacyPolicyPage } from './PrivacyPolicyPage';
import { HuaweiAuthenticationProtocolPage } from './HuaweiAuthenticationProtocolPage';

@Entry
@Component
struct Index {
    @State username: string = '';
    @State password: string = '';
    @State isLoggedIn: boolean = false;
    @State loginMessage: string = '';
    private navPathStack: NavPathStack = new NavPathStack();
    private loginManager: LoginManager = LoginManager.getInstance();
    // 新增：华为账号一键登录按钮控制器
    controller: loginComponentManager.LoginWithHuaweiIDButtonController =
        new loginComponentManager.LoginWithHuaweiIDButtonController()
            .setAgreementStatus(loginComponentManager.AgreementStatus.NOT_ACCEPTED)
            .onClickLoginWithHuaweiIDButton(async (error, res) => {
                if (error) {
                    promptAction.showToast({ message: '请先阅读并同意隐私协议' })
                    hilog.error(0x0000, '一键登陆失败', error.message)
                } else {
                    this.loginManager.login('', '', res.authorizationCode)
                }
            })
    privacyText: loginComponentManager.PrivacyText[] = [{
        text: '已阅读并同意',
        type: loginComponentManager.TextType.PLAIN_TEXT
    }, {
        text: '《用户服务协议》',
        tag: '用户服务协议',
        type: loginComponentManager.TextType.RICH_TEXT
    }, {
        text: '《隐私协议》',
        tag: '隐私协议',
        type: loginComponentManager.TextType.RICH_TEXT
    }, {
        text: '和',
        type: loginComponentManager.TextType.PLAIN_TEXT
    }, {
        text: '《华为账号用户认证协议》',
        tag: '华为账号用户认证协议',
        type: loginComponentManager.TextType.RICH_TEXT
    }];

    aboutToAppear() {
        // 初始化LoginManager
        this.loginManager.init();

        // 检查登录状态
        this.checkLoginStatus();
    }

    checkLoginStatus() {
        const isLoggedIn = this.loginManager.isLoggedIn();
        this.isLoggedIn = isLoggedIn;
    }

    handleLogin(authorizationCode: string) {
        if (!this.username || !this.password) {
            this.loginMessage = '请输入用户名和密码';
            return;
        }

        const success = this.loginManager.login(this.username, this.password, authorizationCode);
        if (success) {
            this.loginMessage = '登录成功！';
            this.checkLoginStatus();
        } else {
            this.loginMessage = '登录失败，请检查用户名和密码';
        }
    }

    build() {
        Column() {
            if (!this.isLoggedIn) {
                // 登录界面
                Navigation(this.navPathStack) {
                    Column() {
                        Blank()
                            .layoutWeight(1)

                        Image($r('app.media.logo'))
                            .borderRadius(24)
                            .height(80)
                            .width(80)
                            .margin({ bottom: 20 })

                        Text('按时吃药')
                            .fontSize(28)
                            .fontWeight(FontWeight.Bold)
                            .margin({ bottom: 12 })

                        Text('助您养成按时吃药的好习惯')
                            .fontSize(16)
                            .fontColor('#666666')
                            .margin({ bottom: 40 })

                        // TextInput({ placeholder: '请输入用户名' })
                        //     .width('80%')
                        //     .height(50)
                        //     .margin({ bottom: 15 })
                        //     .onChange((value: string) => {
                        //         this.username = value;
                        //     })
                        //
                        // TextInput({ placeholder: '请输入密码' })
                        //     .width('80%')
                        //     .height(50)
                        //     .type(InputType.Password)
                        //     .margin({ bottom: 20 })
                        //     .onChange((value: string) => {
                        //         this.password = value;
                        //     })

                        LoginWithHuaweiIDButton({
                            params: {
                                style: loginComponentManager.Style.BUTTON_RED,
                                extraStyle: {
                                    buttonStyle: new loginComponentManager.ButtonStyle().loadingStyle({
                                        show: true
                                    })
                                },
                                borderRadius: 24,
                                loginType: loginComponentManager.LoginType.QUICK_LOGIN,
                                supportDarkMode: true,
                                verifyPhoneNumber: true
                            },
                            controller: this.controller
                        })
                            .width('85%')
                            .height(48)
                            .borderRadius(24)
                        // Button('登录')
                        //     .width('85%')
                        //     .height(48)
                        //     .fontSize(17)
                        //     .borderRadius(24)
                        //     .onClick(() => {
                        //         this.handleLogin('authorizationCode');
                        //     })

                        if (this.loginMessage) {
                            Text(this.loginMessage)
                                .fontSize(16)
                                .fontColor(this.loginMessage.includes('成功') ? Color.Green : Color.Red)
                                .margin({ top: 15 })
                        }

                        Row() {
                            Checkbox({ name: 'privacyCheckbox', group: 'privacyCheckboxGroup' })
                                .width(20)
                                .height(20)
                                .focusable(true)
                                .focusOnTouch(true)
                                .margin({ right: 8 })
                                .flexShrink(0)
                                .onChange((value: boolean) => {
                                    if (value) {
                                        this.controller.setAgreementStatus(loginComponentManager.AgreementStatus.ACCEPTED)
                                    } else {
                                        this.controller.setAgreementStatus(loginComponentManager.AgreementStatus.NOT_ACCEPTED)
                                    }
                                })

                            Text() {
                                ForEach(this.privacyText, (item: loginComponentManager.PrivacyText) => {
                                    if (item?.type === loginComponentManager.TextType.PLAIN_TEXT && item?.text) {
                                        Span(item?.text)
                                            .fontColor($r('sys.color.ohos_id_color_text_secondary'))
                                            .fontFamily($r('sys.string.ohos_id_text_font_family_regular'))
                                            .fontWeight(FontWeight.Regular)
                                            .fontSize($r('sys.float.ohos_id_text_size_body3'))
                                    } else if (item?.type === loginComponentManager.TextType.RICH_TEXT && item?.text) {
                                        Span(item?.text)
                                            .fontColor($r('sys.color.ohos_id_color_text_primary_activated'))
                                            .fontFamily($r('sys.string.ohos_id_text_font_family_medium'))
                                            .fontWeight(FontWeight.Medium)
                                            .fontSize($r('sys.float.ohos_id_text_size_body3'))
                                            .focusable(true)
                                            .focusOnTouch(true)
                                            .onClick(() => {
                                                if (item.tag === '华为账号用户认证协议') {
                                                    this.navPathStack.pushPath({
                                                        name: 'HuaweiAuthenticationProtocolPage'
                                                    })
                                                } else if (item.tag === '隐私协议') {
                                                    this.navPathStack.pushPath({ name: 'PrivacyPolicyPage' })
                                                } else {
                                                    this.navPathStack.pushPath({ name: 'UserAgreementPage' })
                                                }
                                            })
                                    }
                                })
                            }
                            .layoutWeight(1)
                        }
                        .width('85%')
                        .alignItems(VerticalAlign.Top)
                        .margin({ top: 40 })

                        Blank()
                            .layoutWeight(1.5)
                    }
                    .width('100%')
                    .height('100%')
                    .padding({ left: 24, right: 24 })
                    // .justifyContent(FlexAlign.Center)
                    // .padding(20)
                }
                .navDestination(this.navDestinationBuilder)
            } else {
                // 已登录，显示主应用界面
                MainTabs()
            }
        }
        .width('100%')
        .height('100%')
        .backgroundColor('#F5F5F5')
    }

    @Builder
    navDestinationBuilder(name: string, param: Object) {
        if (name === 'UserAgreementPage') {
            UserAgreementPage()
        } else if (name === 'PrivacyPolicyPage') {
            PrivacyPolicyPage()
        } else if (name === 'HuaweiAuthenticationProtocolPage') {
            HuaweiAuthenticationProtocolPage()
        }
    }
}

@Component
struct MainTabs {
    @State currentTabIndex: number = 0;

    build() {
        Tabs({ barPosition: BarPosition.End }) {
            TabContent() {
                HomePage()
            }
            .tabBar(this.TabBuilder('首页', 0, $r("app.media.home")))

            TabContent() {
                PlanPage()
            }
            .tabBar(this.TabBuilder('方案', 1, $r("app.media.plan")))

            TabContent() {
                RecordPage()
            }
            .tabBar(this.TabBuilder('记录', 2, $r("app.media.record")))

            TabContent() {
                ProfilePage()
            }
            .tabBar(this.TabBuilder('我的', 3, $r("app.media.me")))
        }
        .onChange((index: number) => {
            this.currentTabIndex = index;
        })
        .barBackgroundColor($r('sys.color.comp_background_list_card'))
        .barMode(BarMode.Fixed)
    }

    @Builder
    TabBuilder(title: string, index: number, icon: Resource) {
        Column() {
            Image(icon)
                .width(24)
                .height(24)
                .fillColor(this.currentTabIndex === index ? '#007DFF' : '#8A8A8A')

            Text(title)
                .fontSize(12)
                .fontColor(this.currentTabIndex === index ? '#007DFF' : '#8A8A8A')
                .margin({ top: 4 })
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
    }
}