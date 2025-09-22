import { LoginManager } from '../common/LoginManager';

@Component
export struct ProfilePage {
  @State userInfo: any = null;
  @State remainingDays: number = 0;
  private loginManager: LoginManager = LoginManager.getInstance();

  async aboutToAppear() {
    await this.loadUserInfo();
  }

  async loadUserInfo() {
    this.userInfo = await this.loginManager.getUserInfo();
    this.remainingDays = await this.loginManager.getRemainingDays();
  }

  async handleLogout() {
    await this.loginManager.logout();
    // 重新加载应用
    getContext(this).terminateSelf();
  }

  build() {
    Navigation() {
      Column() {
        // 用户信息区域
        Column() {
          // 头像
          Image($r('sys.symbol.person_circle'))
            .width(80)
            .height(80)
            .fillColor('#007DFF')
            .margin({ bottom: 15 })

          // 用户名
          Text(this.userInfo?.username || '用户')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 5 })

          // 登录时间
          Text(`登录时间: ${this.userInfo ? new Date(this.userInfo.loginTime).toLocaleDateString() : ''}`)
            .fontSize(14)
            .fontColor('#666666')
            .margin({ bottom: 5 })

          // 剩余天数
          Text(`剩余有效期: ${this.remainingDays} 天`)
            .fontSize(14)
            .fontColor(this.remainingDays > 5 ? '#00AA00' : '#FF6600')
        }
        .width('100%')
        .padding(20)
        .backgroundColor('#FFFFFF')
        .borderRadius(12)
        .margin({ bottom: 20 })

        // 设置列表
        Column() {
          this.SettingItem('修改个人信息', () => {
            // 跳转到个人信息页面
          })

          Divider()
            .color('#F0F0F0')
            .margin({ left: 50 })

          this.SettingItem('注意事项', () => {
            // 跳转到注意事项页面
          })

          Divider()
            .color('#F0F0F0')
            .margin({ left: 50 })

          this.SettingItem('退出登录', () => {
            this.handleLogout();
          }, true)
        }
        .width('100%')
        .backgroundColor('#FFFFFF')
        .borderRadius(12)
      }
      .width('100%')
      .height('100%')
      .padding(20)
      .backgroundColor('#F5F5F5')
    }
    .title('我的')
    .titleMode(NavigationTitleMode.Mini)
  }

  @Builder
  SettingItem(title: string, onClick: () => void, isLogout: boolean = false) {
    Row() {
      Text(title)
        .fontSize(16)
        .fontColor(isLogout ? '#FF4444' : '#333333')
        .layoutWeight(1)

      Image($r('sys.symbol.chevron_right'))
        .width(16)
        .height(16)
        .fillColor('#CCCCCC')
    }
    .width('100%')
    .height(50)
    .padding({ left: 20, right: 20 })
    .onClick(onClick)
  }
}