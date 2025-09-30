@Entry
@Component
export struct NoticePage {
  private notices: string[] = [
    '1. 请妥善保管您的账号密码',
    '2. 登录有效期为20天，过期需重新登录',
    '3. 如发现异常登录，请及时修改密码',
    '4. 个人信息请定期更新',
    '5. 如有问题请联系客服'
  ];

  build() {
    NavDestination() {
      Column() {
        Column() {
          ForEach(this.notices, (notice: string) => {
            Row() {
              Text(notice)
                .fontSize(16)
                .fontColor('#333333')
                .layoutWeight(1)
            }
            .width('100%')
            .padding(15)
            .backgroundColor('#FFFFFF')
            .borderRadius(8)
            .margin({ bottom: 10 })
          })
        }
        .width('100%')
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F5F5F5')
      .padding(20)
    }
    .title('常见问题')
  }
}