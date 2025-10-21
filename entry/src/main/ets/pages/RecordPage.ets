import { RecordResponse, RecordResponseContents } from "../api/RecordApiService"
import { recordManager } from "../manager/RecordManager"

@Entry
@Component
export struct RecordPage {

  // 示例数据：接入真实数据时替换为你的数据源（recordListData[]）
    @State recordData: RecordResponse[] = []
    @State recordIterm: recordListData[] = [
        {
            actual_time: '2025-09-03 08:00:00',
            contents: [
                { id: 1, medicine_name: '人参', memo: '', status: 0, is_checked: 1 },
                { id: 2, medicine_name: '鹿茸', memo: '', status: 1, is_checked: 1 },
                { id: 3, medicine_name: '板蓝根', memo: '', status: 0, is_checked: 0 },
                { id: 4, medicine_name: '维生素C', memo: '', status: 0, is_checked: 0 },
                { id: 5, medicine_name: '阿莫西林', memo: '', status: 0, is_checked: 0 },
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
                { id: 6, medicine_name: '板蓝根', memo: '', status: 1, is_checked: 1 },
                { id: 6, medicine_name: '板蓝根', memo: '', status: 1, is_checked: 1 },
                { id: 6, medicine_name: '板蓝根', memo: '', status: 1, is_checked: 1 },
            ]
        }
    ]

    private translateStatusAndIsChecked(status: number, isChecked: number): string {
        if (isChecked === 1 && status === 0) {
            return '打卡正常'
        } else if (isChecked === 1 && status === 1) {
            return '时间异常'
        } else {
            return '未打卡'
        }
    }

    private translateStatusAndIsCheckedColor(status: number, isChecked: number): string {
        if (isChecked === 1 && status === 0) {
            return '#34C759' // 绿色 - 正常
        } else if (isChecked === 1 && status === 1) {
            return '#FF9500' // 橙色 - 异常
        } else {
            return '#FF3B30' // 红色 - 未打卡
        }
    }

    private translateStatusBgColor(status: number, isChecked: number): string {
        if (isChecked === 1 && status === 0) {
            return '#E8F8ED' // 浅绿背景
        } else if (isChecked === 1 && status === 1) {
            return '#FFF4E6' // 浅橙背景
        } else {
            return '#FFE8E6' // 浅红背景
        }
    }

    async aboutToAppear() {
        await this.loadData();
    }

    async loadData() {
        try {
            this.recordData = await recordManager.getRecordList()
        } catch (error) {
            console.error('Failed to load plan data:', error);
            this.recordData = [];
        }
    }

    build() {
        Column() {
            if (this.recordIterm.length > 0) {
                Scroll() {
                    Column({ space: 12 }) {
                        // 每个日期一组
                        ForEach(this.recordData, (group: RecordResponse) => {
                            Column() {
                                // 顶部日期行
                                Row() {
                                    Text(this.formatDate(group.actual_time))
                                        .fontSize(16)
                                        .fontWeight(FontWeight.Bold)
                                        .fontColor('#111111')

                                    Image($r('sys.symbol.chevron_right'))
                                        .width(20)
                                        .height(20)
                                        .fillColor('#999999')
                                }
                                .justifyContent(FlexAlign.SpaceBetween)
                                .width('100%')
                                .padding({ left: 16, right: 16, top: 14, bottom: 14 })
                                .backgroundColor('#FFFFFF')
                                .borderRadius({ topLeft: 12, topRight: 12 })

                                // 分隔线
                                Divider()
                                    .color('#F0F0F0')
                                    .strokeWidth(1)

                                // 内容条目行
                                ForEach(group.contents, (item: RecordResponseContents, idx: number) => {
                                    Column() {
                                        Row() {
                                            Text(item.medicine_name)
                                                .fontSize(15)
                                                .fontColor('#333333')
                                                .layoutWeight(1)

                                            Text(this.translateStatusAndIsChecked(item.status, item.is_checked))
                                                .fontSize(14)
                                                .fontColor(this.translateStatusAndIsCheckedColor(item.status, item.is_checked))
                                                .backgroundColor(this.translateStatusBgColor(item.status, item.is_checked))
                                                .padding({ left: 10, right: 10, top: 4, bottom: 4 })
                                                .borderRadius(4)
                                        }
                                        .width('100%')
                                        .padding({ left: 16, right: 16, top: 12, bottom: 12 })
                                        .backgroundColor('#FFFFFF')

                                        // 非最后一项添加分隔线
                                        if (idx < group.contents.length - 1) {
                                            Divider()
                                                .color('#F0F0F0')
                                                .strokeWidth(1)
                                                .margin({ left: 16, right: 16 })
                                        }
                                    }
                                })

                                // 底部圆角占位
                                Row()
                                    .width('100%')
                                    .height(0)
                                    .backgroundColor('#FFFFFF')
                                    .borderRadius({ bottomLeft: 12, bottomRight: 12 })
                            }
                            .width('92%')
                            .margin({ left: '4%', right: '4%' })
                            .shadow({ radius: 8, color: '#12000000', offsetX: 0, offsetY: 2 })
                        })
                    }
                    .width('100%')
                    .padding({ top: 12, bottom: 16 })
                }
                .layoutWeight(1)
                .scrollable(ScrollDirection.Vertical)
            } else {
                Column() {
                    Text('暂无打卡记录')
                        .fontSize(16)
                        .fontColor('#999999')
                }
                .layoutWeight(1)
                .justifyContent(FlexAlign.Center)
            }
        }
        .width('100%')
        .height('100%')
        .backgroundColor('#F7F8FA')
    }

    // 格式化日期显示
    private formatDate(dateStr: string): string {
        // 可以根据需要格式化，这里简单返回
        // 例如：'2025-09-03 08:00:00' -> '2025年09月03日 08:00'
        const date = new Date(dateStr.replace(/-/g, '/'));
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        const hour = String(date.getHours()).padStart(2, '0');
        const minute = String(date.getMinutes()).padStart(2, '0');

        return `${year}年${month}月${day}日 ${hour}:${minute}`;
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