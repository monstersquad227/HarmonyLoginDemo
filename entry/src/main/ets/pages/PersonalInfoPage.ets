@Entry
@Component
export struct PersonalInfoPage {

  build() {
    NavDestination() {
      Column() {
        this.SettingItem('头像', 'O', {topLeft: 10, topRight: 10, bottomLeft: 0, bottomRight: 0})
        this.SettingItem('昵称', 'admin', {topLeft: 0, topRight: 0, bottomLeft: 0, bottomRight: 0})
        this.SettingItem('手机号', '15056332824', {topLeft: 0, topRight: 0, bottomLeft: 10, bottomRight: 10})

        Blank().layoutWeight(1)

        Button('退出登录')
          .width('100%')
          .borderRadius(10)
          .backgroundColor('rgba(255, 0, 0, 0.15)')
          .fontColor('rgba(255, 0, 0, 0.9)')
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F5F5F5')
      .padding(20)
    }
    .title('个人信息')
    .onBackPressed(() => {
      // 返回上一页的逻辑
      return false; // 返回false表示使用默认的返回行为
    })
  }

  @Builder
  SettingItem(title: string, value: string, radius: BorderRadiuses) {
    Row() {
      Text(title).fontSize(16).alignSelf(ItemAlign.Start).margin({ bottom: 8 })
      Text(value).fontSize(16).alignSelf(ItemAlign.Start).margin({ bottom: 8 })
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
    .borderRadius(radius)
    .padding(20)
    .backgroundColor('#ffffffff')
  }
}