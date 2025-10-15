import { LoginManager, UserInfo } from '../common/LoginManager';
import common from '@ohos.app.ability.common';
import { PersonalInfoPage } from './PersonalInfoPage';
import { NoticePage } from './NoticePage';
import { Want } from '@kit.AbilityKit';
import { FeedbackPage } from './FeedbackPage';

@Entry
@Component
export struct ProfilePage {
  @State userInfo: UserInfo | null = null;
  @State remainingDays: number = 0;
  private loginManager: LoginManager = LoginManager.getInstance();
  private navPathStack: NavPathStack = new NavPathStack();

  aboutToAppear() {
    this.loadUserInfo();
  }

  loadUserInfo() {
    this.userInfo = this.loginManager.getUserInfo();
    this.remainingDays = this.loginManager.getRemainingDays();
  }

  handleLogout() {
    this.loginManager.logout();
    // 重启应用
    const context = getContext(this) as common.UIAbilityContext;
    context.startAbility(Want.prototype);
  }

  build() {
    Navigation(this.navPathStack) {
      Column() {
        // 用户信息区域
        Column() {
          // 头像
          Image($r('app.media.userAvatar'))
            .width(80)
            .height(80)
            .margin({ bottom: 15 })

          // 用户名
          Text(this.userInfo?.username || '用户8271034905')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .margin({ bottom: 5 })
        }
        .width('100%')
        .padding(20)
        .backgroundColor('#FFFFFF')
        .borderRadius(12)
        .margin({ bottom: 20 })

        // 设置列表
        Column() {
          this.SettingItem('个人信息', () => {
            // 跳转到个人信息页面
            this.navPathStack.pushPath({ name: 'PersonalInfoPage' });
          })

          Divider()
            .color('#F0F0F0')
            .margin({ left: 50 })

          this.SettingItem('常见问题', () => {
            // 跳转到注意事项页面
            this.navPathStack.pushPath({ name: 'NoticePage' });
          })

          Divider()
            .color('#F0F0F0')
            .margin({ left: 50 })

          this.SettingItem('功能反馈', () => {
            // 跳转到功能反馈页面
            this.navPathStack.pushPath({ name: 'FeedbackPage' });
          })
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
    .navDestination(this.navDestinationBuilder)
  }

  @Builder
  navDestinationBuilder(name: string, param: Object) {
    if (name === 'PersonalInfoPage') {
      PersonalInfoPage()
    } else if (name === 'NoticePage') {
      NoticePage()
    } else if (name === 'FeedbackPage') {
      FeedbackPage()
    }
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