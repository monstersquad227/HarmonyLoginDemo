@Entry
@Component
export struct PersonalInfoPage {
  @State username: string = '';
  @State email: string = '';

  aboutToAppear() {
    // 这里可以加载用户信息
    this.username = '示例用户';
    this.email = 'user@example.com';
  }

  build() {
    NavDestination() {
      Column() {
        Text('修改个人信息')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .margin({ bottom: 30 })

        Column() {
          Text('用户名')
            .fontSize(16)
            .alignSelf(ItemAlign.Start)
            .margin({ bottom: 8 })

          TextInput({ text: this.username })
            .width('100%')
            .height(50)
            .margin({ bottom: 20 })
            .onChange((value: string) => {
              this.username = value;
            })

          Text('邮箱')
            .fontSize(16)
            .alignSelf(ItemAlign.Start)
            .margin({ bottom: 8 })

          TextInput({ text: this.email })
            .width('100%')
            .height(50)
            .margin({ bottom: 30 })
            .onChange((value: string) => {
              this.email = value;
            })

          Button('保存修改')
            .width('100%')
            .height(50)
            .onClick(() => {
              // 保存逻辑
              console.log('保存用户信息');
            })
        }
        .width('100%')
        .padding(20)
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F5F5F5')
      .padding(20)
    }
    .title('修改个人信息')
    .onBackPressed(() => {
      // 返回上一页的逻辑
      return false; // 返回false表示使用默认的返回行为
    })
  }
}