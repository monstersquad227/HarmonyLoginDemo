@Entry
@Component
export struct RecordPage {

  // 示例数据：接入真实数据时替换为你的数据源（recordListData[]）
  @State recordIterm: recordListData[] = [
    {
      actual_time: '2025-09-03 08:00:00',
      contents: [
        { id: 1, medicine_name: '人参', memo: '', status: 0, is_checked: 1 },
        { id: 2, medicine_name: '鹿茸', memo: '', status: 1, is_checked: 1 },
        { id: 3, medicine_name: '板蓝根', memo: '', status: 0, is_checked: 0 },
        { id: 4, medicine_name: '板蓝根', memo: '', status: 0, is_checked: 0 },
        { id: 5, medicine_name: '板蓝根', memo: '', status: 0, is_checked: 0 },
      ]
    },
    {
      actual_time: '2025-09-04 08:00:00',
      contents: [
        { id: 4, medicine_name: '人参', memo: '', status: 0, is_checked: 1 },
        { id: 5, medicine_name: '鹿茸', memo: '', status: 0, is_checked: 1 },
        { id: 6, medicine_name: '板蓝根', memo: '', status: 1, is_checked: 1 },
      ]
    },
    {
      actual_time: '2025-09-05 08:00:00',
      contents: [
        { id: 4, medicine_name: '人参', memo: '', status: 0, is_checked: 1 },
        { id: 5, medicine_name: '鹿茸', memo: '', status: 0, is_checked: 1 },
        { id: 6, medicine_name: '板蓝根', memo: '', status: 1, is_checked: 1 },
      ]
    },
    {
      actual_time: '2025-09-06 08:00:00',
      contents: [
        { id: 4, medicine_name: '人参', memo: '', status: 0, is_checked: 1 },
        { id: 5, medicine_name: '鹿茸', memo: '', status: 0, is_checked: 1 },
        { id: 6, medicine_name: '板蓝根', memo: '', status: 1, is_checked: 1 },
      ]
    },
    {
      actual_time: '2025-09-07 08:00:00',
      contents: [
        { id: 4, medicine_name: '人参', memo: '', status: 0, is_checked: 1 },
        { id: 5, medicine_name: '鹿茸', memo: '', status: 0, is_checked: 1 },
        { id: 6, medicine_name: '板蓝根', memo: '', status: 1, is_checked: 1 },
      ]
    }
  ]

  private translateStatusAndIsChecked(status: number, isChecked: number): string {
    if (isChecked === 1 && status === 0) {
      return '打卡正常'
    } else if (isChecked === 1 && status === 1) {
      return '打卡时间异常'
    } else {
      return '未打卡'
    }
  }
  private translateStatusAndIsCheckedColor(status: number, isChecked: number): string {
    if (isChecked === 1 && status === 0) {
      return '#0000FF'
    } else if (isChecked === 1 && status === 1) {
      return '#FFC107'
    } else {
      return '#FF0000'
    }
  }

  build() {
    Scroll() {
      Column() {
        // 每个日期一组：顶部日期行 + 内容行（中间直角、底部圆角）
        ForEach(this.recordIterm, (group: recordListData) => {
          Column() {
            // 顶部日期行（圆角顶部）
            this.RecordRow(
              group.actual_time,
              '>',
              { topLeft: 10, topRight: 10, bottomLeft: 0, bottomRight: 0 },
              true
            )

            // 内容条目行：左药名，右状态文案与颜色
            ForEach(group.contents, (item: recordListDataContents, idx: number) => {

              this.RecordRow(
                item.medicine_name,
                this.translateStatusAndIsChecked(item.status, item.is_checked),
                { topLeft: 0, topRight: 0, bottomLeft:  0, bottomRight:  0 },
                false,
                this.translateStatusAndIsCheckedColor(item.status, item.is_checked)
              )
            })
          }
          .width('100%')
          .margin({ bottom: 20 })
        })

      }
      .width('100%')
      .backgroundColor('#F5F5F5')
      .padding(20)
    }
    .height('100%')
    .scrollable(ScrollDirection.Vertical)
  }

  @Builder
  RecordRow(leftText: string, rightText: string, radius: BorderRadiuses, isHeader: boolean, rightColor?: string) {
    Row() {
      Text(leftText)
        .fontSize(isHeader ? 18 : 16)
        .fontWeight(isHeader ? FontWeight.Medium : FontWeight.Regular)
        .fontColor(isHeader ? '#000000' : '#888888')
        .alignSelf(ItemAlign.Start)
        .margin({ bottom: 8 })

      Text(rightText)
        .fontSize(isHeader ? 18 : 16)
        .fontColor(isHeader ? '#000000' : (rightColor ?? '#888888'))
        .alignSelf(ItemAlign.Start)
        .margin({ bottom: 8 })
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
    .borderRadius(radius)
    .padding(20)
    .backgroundColor('#ffffffff')
  }
}

export interface recordListData {
  actual_time: string,
  contents: recordListDataContents[]
}

export interface recordListDataContents {
  id: number,
  medicine_name: string,
  memo?: string,
  status: number,
  is_checked: number,
}
