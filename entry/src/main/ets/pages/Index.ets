import { LoginManager } from '../common/LoginManager';
import { HomePage } from './HomePage';
import { PlanPage } from './PlanPage';
import { PostListPage } from './PostListPage';
import { ProfilePage } from './ProfilePage';
import { RecordPage } from './RecordPage';

@Entry
@Component
struct Index {
    @State username: string = '';
    @State password: string = '';
    @State isLoggedIn: boolean = false;
    @State loginMessage: string = '';
    private loginManager: LoginManager = LoginManager.getInstance();

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

    handleLogin() {
        if (!this.username || !this.password) {
            this.loginMessage = '请输入用户名和密码';
            return;
        }

        const success = this.loginManager.login(this.username, this.password);
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
                Column() {
                    Text('HarmonyOS 登录Demo')
                        .fontSize(24)
                        .fontWeight(FontWeight.Bold)
                        .margin({ bottom: 30 })

                    Text('用户登录')
                        .fontSize(20)
                        .margin({ bottom: 20 })

                    TextInput({ placeholder: '请输入用户名' })
                        .width('80%')
                        .height(50)
                        .margin({ bottom: 15 })
                        .onChange((value: string) => {
                            this.username = value;
                        })

                    TextInput({ placeholder: '请输入密码' })
                        .width('80%')
                        .height(50)
                        .type(InputType.Password)
                        .margin({ bottom: 20 })
                        .onChange((value: string) => {
                            this.password = value;
                        })

                    Button('登录')
                        .width('80%')
                        .height(50)
                        .onClick(() => {
                            this.handleLogin();
                        })

                    if (this.loginMessage) {
                        Text(this.loginMessage)
                            .fontSize(16)
                            .fontColor(this.loginMessage.includes('成功') ? Color.Green : Color.Red)
                            .margin({ top: 15 })
                    }
                }
                .width('100%')
                .height('100%')
                .justifyContent(FlexAlign.Center)
                .padding(20)
            } else {
                // 已登录，显示主应用界面
                MainTabs()
            }
        }
        .width('100%')
        .height('100%')
        .backgroundColor('#F5F5F5')
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