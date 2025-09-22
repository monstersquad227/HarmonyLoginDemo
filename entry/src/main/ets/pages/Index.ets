import { LoginManager, UserInfo } from '../common/LoginManager';

@Entry
@Component
struct Index {
    @State username: string = '';
    @State password: string = '';
    @State isLoggedIn: boolean = false;
    @State userInfo: UserInfo | null = null;
    @State remainingDays: number = 0;
    @State loginMessage: string = '';
    private loginManager: LoginManager = LoginManager.getInstance();

    async aboutToAppear() {
        // 初始化LoginManager
        await this.loginManager.init(getContext(this));

        // 检查登录状态
        await this.checkLoginStatus();
    }

    async checkLoginStatus() {
        const isLoggedIn = await this.loginManager.isLoggedIn();
        this.isLoggedIn = isLoggedIn;

        if (isLoggedIn) {
            this.userInfo = await this.loginManager.getUserInfo();
            this.remainingDays = await this.loginManager.getRemainingDays();
            this.loginMessage = `欢迎回来，${this.userInfo?.username}！`;
        }
    }

    async handleLogin() {
        if (!this.username || !this.password) {
            this.loginMessage = '请输入用户名和密码';
            return;
        }

        const success = await this.loginManager.login(this.username, this.password);
        if (success) {
            this.loginMessage = '登录成功！';
            await this.checkLoginStatus();
        } else {
            this.loginMessage = '登录失败，请检查用户名和密码';
        }
    }

    async handleLogout() {
        await this.loginManager.logout();
        this.isLoggedIn = false;
        this.userInfo = null;
        this.remainingDays = 0;
        this.username = '';
        this.password = '';
        this.loginMessage = '已退出登录';
    }

    build() {
        Column() {
            Text('HarmonyOS 登录Demo')
                .fontSize(24)
                .fontWeight(FontWeight.Bold)
                .margin({ bottom: 30 })

            if (!this.isLoggedIn) {
                // 登录界面
                Column() {
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
                .padding(20)
            } else {
                // 已登录界面
                Column() {
                    Text('登录状态')
                        .fontSize(20)
                        .margin({ bottom: 20 })

                    Row() {
                        Text('用户名：')
                            .fontSize(16)
                        Text(this.userInfo?.username || '')
                            .fontSize(16)
                            .fontColor(Color.Blue)
                    }
                    .width('80%')
                    .justifyContent(FlexAlign.Start)
                    .margin({ bottom: 10 })

                    Row() {
                        Text('登录时间：')
                            .fontSize(16)
                        Text(this.userInfo ? new Date(this.userInfo.loginTime).toLocaleString() : '')
                            .fontSize(16)
                            .fontColor(Color.Gray)
                    }
                    .width('80%')
                    .justifyContent(FlexAlign.Start)
                    .margin({ bottom: 10 })

                    Row() {
                        Text('剩余有效期：')
                            .fontSize(16)
                        Text(`${this.remainingDays} 天`)
                            .fontSize(16)
                            .fontColor(this.remainingDays > 5 ? Color.Green : Color.Orange)
                    }
                    .width('80%')
                    .justifyContent(FlexAlign.Start)
                    .margin({ bottom: 20 })

                    Button('退出登录')
                        .width('80%')
                        .height(50)
                        .backgroundColor(Color.Red)
                        .onClick(() => {
                            this.handleLogout();
                        })

                    if (this.loginMessage) {
                        Text(this.loginMessage)
                            .fontSize(16)
                            .fontColor(Color.Green)
                            .margin({ top: 15 })
                    }
                }
                .width('100%')
                .padding(20)
            }
        }
        .width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .backgroundColor('#F5F5F5')
    }
}