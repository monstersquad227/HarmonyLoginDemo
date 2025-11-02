import { RecordResponse, RecordResponseContents } from "../api/RecordApiService"
import { recordManager } from "../manager/RecordManager"
import { emitter } from "@kit.BasicServicesKit"
import { promptAction } from "@kit.ArkUI";

@Entry
@Component
export struct RecordPage {
    @State recordData: RecordResponse[] = [];
    @State isRefreshing: boolean = false
    // 定义事件 ID（与 MainTabs 中一致）
    private readonly SWITCH_TAB_EVENT_ID = 1001;
    private readonly REFRESH_RECORD_EVENT_ID = 2003;

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
        emitter.on({ eventId: this.REFRESH_RECORD_EVENT_ID }, async () => {
            console.info('RecordPage received refresh event from tab switch');
            await this.loadData();
        });
        await this.loadData();
    }

    async aboutToDisappear() {
        emitter.off(this.REFRESH_RECORD_EVENT_ID);
    }

    async loadData() {
        try {
            this.recordData = await recordManager.getRecordList()
        } catch (error) {
            console.error('Failed to load plan data:', error);
            this.recordData = [];
        }
    }

    // 刷新数据
    async refreshData() {
        if (this.isRefreshing) return;

        this.isRefreshing = true;
        try {
            await this.loadData();
            // promptAction.showToast({
            //     message: '刷新成功',
            //     duration: 1500
            // });
        } catch (error) {
            console.error('Refresh failed:', error);
            // promptAction.showToast({
            //     message: '刷新失败，请重试',
            //     duration: 2000
            // });
        } finally {
            this.isRefreshing = false;
        }
    }

    // 切换到首页 Tab 并传递日期
    switchToHomeTab(dateStr: string) {
        try {
            const dateOnly = dateStr.split(' ')[0];

            // 发送事件
            emitter.emit({ eventId: this.SWITCH_TAB_EVENT_ID }, {
                data: {
                    targetDate: dateOnly
                }
            });

            console.info('Emitted switch tab event with date:', dateOnly);
        } catch (error) {
            console.error('Switch tab error:', error);
        }
    }

    build() {
        Column() {
            if (this.recordData.length > 0) {
                Refresh({ refreshing: this.isRefreshing }) {
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
                                    .backgroundColor($r('sys.color.comp_background_list_card'))
                                    .borderRadius({ topLeft: 12, topRight: 12 })
                                    .onClick(() => {
                                        this.switchToHomeTab(group.actual_time)
                                    })

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
                                            .backgroundColor($r('sys.color.comp_background_list_card'))

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
                                        .backgroundColor($r('sys.color.comp_background_list_card'))
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
                    .scrollable(ScrollDirection.Vertical)
                }
                .layoutWeight(1)
                .onRefreshing(async () => {
                    await this.refreshData();
                })
            } else {
                Refresh({ refreshing: this.isRefreshing }) {
                    Column() {
                        Text('暂无打卡记录')
                            .fontSize(16)
                            .fontColor('#999999')
                    }
                    .margin({ top: 40 })
                    .justifyContent(FlexAlign.Center)
                }
                .layoutWeight(1)
                .onRefreshing(async () => {
                    await this.refreshData();
                })
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
        // const hour = String(date.getHours()).padStart(2, '0');
        // const minute = String(date.getMinutes()).padStart(2, '0');

        return `${year}年${month}月${day}日`;
    }
}