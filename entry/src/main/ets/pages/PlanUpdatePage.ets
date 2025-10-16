@Component
export struct PlanUpdatePage {
    @State medicineName: string = '板蓝根';

    build() {
        NavDestination() {
            Scroll() {
                Column() {
                    List({ space: 14 }) {
                        this.buildMedicineNameCard()
                    }
                }
                .width('100%')
                .height('100%')
                .backgroundColor('#F7F8FA')
            }
            .height('100%')
        }
        .title('修改用药方案')
    }

    @Builder
    buildMedicineNameCard() {
        ListItem() {
            Row() {
                Column({ space: 20 }) {
                    Text('药品名')
                        .fontWeight(FontWeight.Bold)
                        .fontSize(16)
                    TextInput({
                        placeholder: '请输入药品名',
                        text: this.medicineName
                    })
                        .width('100%')
                        .border({ width: 1, color: '#e5e7eb', radius: 8 })
                        .padding(10)
                        .onChange((value: string) => {
                            this.medicineName = value;
                        })
                }
                .width('100%')
            }
            .width('100%')
            .padding(10)
        }
        .width('92%')
        .margin({ left: '4%', right: '4%' })
        .backgroundColor('#FFFFFF')
        .borderRadius(12)
        .shadow({ radius: 8, color: '#12000000', offsetX: 0, offsetY: 2 })
    }
}