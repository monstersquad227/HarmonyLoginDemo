@Entry
@Component
export struct RecordPage {
    build() {
        Column() {
            Column() {
                this.RecordItem('2025-09-03')
            }
        }
        .width('100%')
        .height('100%')
        .backgroundColor('#F5F5F5')
        .padding(20)
    }

    @Builder
    RecordItem(dateTitle: string) {
        Row() {
            Text(dateTitle)
            Text(">")
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width('100%')
        .borderRadius(10)
    }
}