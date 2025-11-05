@Component
export struct PrivacyPolicyPage {
    private privacyPolicyContent1: string = `生效日期：2025年6月9日
更新日期：2025年6月9日

我们非常重视您的隐私和个人信息安全。上海昔音信息技术有限公司开发并运营的【按时用药】APP，依据《中华人民共和国个人信息保护法》《网络安全法》等法律规定，制定本隐私政策以帮助您了解：`

    private privacyPolicyContent2: string = `在您使用本平台过程中，我们会收集与服务相关的以下个人信息：

1. 您主动提供的信息：
• 账号注册信息（手机号、昵称、头像等）；
• 添加的药品信息（名称、剂量、时间计划等）；
• 打卡记录、用药反馈；
• 意见建议、联系客服记录等。

2. 自动采集的信息：
• 设备信息（设备型号、操作系统、设备ID、网络信息、IP地址等）；
• 操作日志（访问时间、点击路径、异常日志）；
• 通知授权信息（如您授权使用提醒功能）。`

    private privacyPolicyContent3: string = `我们收集的信息将被用于以下目的：

1. 提供核心服务功能（如打卡提醒、数据同步）；
2. 账户管理与安全验证；
3. 产品优化与用户体验提升；
4. 法律法规规定的其他用途（如配合司法机关调查）；
5. 经过脱敏/匿名化处理后用于统计分析。

我们不会将您的个人信息用于任何未明示目的，更不会出售您的信息。`

    private privacyPolicyContent4: string = `我们承诺：

1. 不会向任何无关第三方共享、出售、出租您的个人信息；

2. 在以下情况可能共享信息：
• 获得您明确同意或授权；
• 为提供某项功能而使用必要的第三方服务（如短信/推送）；
• 法律法规或政府部门依法要求。

我们与第三方合作方签署了严格的数据保护协议，确保信息安全。`

    private privacyPolicyContent5: string = `1. 您的个人信息将存储在中国境内；
2. 除非法律要求或您主动删除，数据将保留至您主动注销账号或平台终止运营；
3. 我们采取技术与管理措施（加密存储、权限控制、安全审计等）确保信息不被泄露、丢失、篡改。`

    private privacyPolicyContent6: string = `您有权：

1. 访问、更正或删除您的个人信息；
2. 撤回授权（如通知权限）；
3. 注销账户，平台将清除相关信息（或依法保留）；
4. 拒绝个性化推荐。

可通过"设置 > 隐私管理"或联系客服执行上述操作。`

    private privacyPolicyContent7: string = `本平台不面向14岁以下未成年人。若您为未成年人，请在监护人指导下使用本平台服务。`

    private privacyPolicyContent8: string = `我们可能会根据业务或法律要求不时调整隐私政策，并通过APP内公告、弹窗或其他方式通知您。请您关注变更内容，继续使用即表示同意。`

    private privacyPolicyContent9: string = `如您对本政策或您的信息安全有任何疑问、建议或投诉，请通过以下方式联系我们：

公司名称：上海昔音信息技术有限公司
联系邮箱：15056332824@163.com
联系地址：中国（上海）自由贸易试验区临港新片区东征村133号
客服电话/微信号：15056332824（微信同号）`

    build() {
        NavDestination() {
            Scroll() {
                Column() {
                    // 主标题
                    Text('隐私政策')
                        .fontWeight(FontWeight.Bold)
                        .fontSize(22)
                        .fontColor('#111111')
                        .margin({ bottom: 24 })

                    // 前言
                    this.contentCard(this.privacyPolicyContent1, false)

                    // 一、我们收集的信息
                    this.sectionTitle('一、我们收集的信息')
                    this.contentCard(this.privacyPolicyContent2)

                    // 二、我们如何使用您的信息
                    this.sectionTitle('二、我们如何使用您的信息')
                    this.contentCard(this.privacyPolicyContent3)

                    // 三、信息共享、转让与公开
                    this.sectionTitle('三、信息共享、转让与公开')
                    this.contentCard(this.privacyPolicyContent4)

                    // 四、信息的保存与安全
                    this.sectionTitle('四、信息的保存与安全')
                    this.contentCard(this.privacyPolicyContent5)

                    // 五、您对个人信息的权利
                    this.sectionTitle('五、您对个人信息的权利')
                    this.contentCard(this.privacyPolicyContent6)

                    // 六、未成年人信息保护
                    this.sectionTitle('六、未成年人信息保护')
                    this.contentCard(this.privacyPolicyContent7)

                    // 七、政策变更
                    this.sectionTitle('七、政策变更')
                    this.contentCard(this.privacyPolicyContent8)

                    // 八、联系我们
                    this.sectionTitle('八、联系我们')
                    this.contentCard(this.privacyPolicyContent9)

                    // 底部版权信息
                    Text('© 2025 上海昔音信息技术有限公司')
                        .fontSize(12)
                        .fontColor('#999999')
                        .textAlign(TextAlign.Center)
                        .width('100%')
                        .margin({ top: 32, bottom: 24 })
                }
                .width('92%')
                .margin({ left: '4%', right: '4%' })
                .padding({ top: 20, bottom: 20 })
            }
            .width('100%')
            .height('100%')
            .backgroundColor('#F7F8FA')
        }
        .title('隐私政策')
    }

    @Builder
    sectionTitle(title: string) {
        Text(title)
            .fontWeight(FontWeight.Bold)
            .fontSize(17)
            .fontColor('#333333')
            .alignSelf(ItemAlign.Start)
            .margin({ top: 16, bottom: 12 })
    }

    @Builder
    contentCard(content: string, hasMargin: boolean = true) {
        Column() {
            Text(content)
                .fontSize(15)
                .fontColor('#666666')
                .lineHeight(26)
                .textAlign(TextAlign.Start)
                .width('100%')
        }
        .width('100%')
        .padding(16)
        .backgroundColor('#FFFFFF')
        .borderRadius(12)
        .shadow({ radius: 6, color: '#08000000', offsetX: 0, offsetY: 2 })
        .margin({ bottom: hasMargin ? 0 : 16 })
    }
}