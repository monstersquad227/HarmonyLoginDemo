import { PlanResponse } from "../api/PlanApiService";
import { planManager } from "../manager/PlanManager";
import { emitter } from "@kit.BasicServicesKit";
import { recordManager } from "../manager/RecordManager";
import { PutRecordRequest } from "../api/RecordApiService";
import { promptAction } from "@kit.ArkUI";
import { JSON } from "@kit.ArkTS";


@Entry
@Component
export struct HomePage {
    @State currentDate: Date = new Date();
    @State selectedDate: Date = new Date();
    @State planData: PlanResponse[] = [];
    @State isRefreshing: boolean = false;

    // 定义事件 ID（与 MainTabs 中一致）
    private readonly SWITCH_TAB_EVENT_ID = 1001;

    async aboutToAppear() {
        // 订阅切换事件，直接在 HomePage 接收
        emitter.on({ eventId: this.SWITCH_TAB_EVENT_ID }, async (data) => {
            if (data?.data) {
                const targetDate = data.data.targetDate as string;
                console.info('HomePage received target date:', targetDate);

                // 解析并设置日期
                const dateParts = targetDate.split('-');
                if (dateParts.length === 3) {
                    const date = new Date(
                        parseInt(dateParts[0]),
                        parseInt(dateParts[1]) - 1,
                        parseInt(dateParts[2])
                    );
                    this.currentDate = date;
                    this.selectedDate = new Date(date);

                    // 重新加载数据
                    await this.loadData();
                }
            }
        });
        // 初始加载
        this.selectedDate = new Date(this.currentDate);
        await this.loadData();
    }

    aboutToDisappear() {
        // 取消订阅
        emitter.off(this.SWITCH_TAB_EVENT_ID);
    }

    // 刷新数据
    async handleRefresh() {
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

    // 获取月份的天数
    getDaysInMonth(year: number, month: number): number {
        return new Date(year, month + 1, 0).getDate();
    }

    // 获取月份第一天是星期几
    getFirstDayOfMonth(year: number, month: number): number {
        return new Date(year, month, 1).getDay();
    }

    // 格式化日期时间为 YYYY-MM-DD HH:mm (使用selectedDate的日期 + 当前时间)
    formatDateTimeWithSelectedDate(): string {
        const year = this.selectedDate.getFullYear();
        const month = String(this.selectedDate.getMonth() + 1).padStart(2, '0');
        const day = String(this.selectedDate.getDate()).padStart(2, '0');

        const now = new Date();
        const hours = String(now.getHours()).padStart(2, '0');
        const minutes = String(now.getMinutes()).padStart(2, '0');

        return `${year}-${month}-${day} ${hours}:${minutes}`;
    }

    // 格式化日期显示
    formatDateHeader(): string {
        return this.formatDateForAPI(this.selectedDate);
    }

    // 格式化日期为 YYYY-MM-DD
    formatDateForAPI(date: Date): string {
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0');
        const day = String(date.getDate()).padStart(2, '0');
        return `${year}-${month}-${day}`;
    }

    // 上一天
    async previousDay() {
        const newDate = new Date(this.currentDate);
        newDate.setDate(newDate.getDate() - 1);
        this.currentDate = newDate;
        this.selectedDate = newDate;
        await this.loadData();
    }

    // 今天
    async goToToday() {
        const today = new Date();
        this.currentDate = today;
        this.selectedDate = new Date(today);
        await this.loadData();
    }

    // 下一天
    async nextDay() {
        const newDate = new Date(this.currentDate);
        newDate.setDate(newDate.getDate() + 1);
        this.currentDate = newDate;
        this.selectedDate = newDate;
        await this.loadData();
    }

    // 检查是否是今天
    isToday(day: number): boolean {
        const today = new Date();
        return this.currentDate.getFullYear() === today.getFullYear() &&
            this.currentDate.getMonth() === today.getMonth() &&
            day === today.getDate();
    }

    // 检查是否是选中的日期
    isSelectedDate(day: number): boolean {
        return this.currentDate.getFullYear() === this.selectedDate.getFullYear() &&
            this.currentDate.getMonth() === this.selectedDate.getMonth() &&
            day === this.selectedDate.getDate();
    }

    // 点击日期
    async onDateClick(day: number) {
        this.selectedDate = new Date(this.currentDate.getFullYear(), this.currentDate.getMonth(), day);
        await this.loadData();
    }

    async loadData() {
        try {
            // 使用格式化后的日期
            const formattedDate = this.formatDateForAPI(this.selectedDate);
            console.info('Loading plan data for date:', formattedDate);
            this.planData = await planManager.getPlanList(formattedDate);
            console.info('Plan data loaded:', this.planData.length);
        } catch (error) {
            console.error('Failed to load plan data:', error);
            this.planData = [];
        }
    }

    build() {
        Column() {
            // 日历头部
            Row() {
                Button() {
                    Image($r('app.media.leftArrow'))
                        .fillColor('#666666')
                        .height(25)
                        .width(25)
                }
                .width(40)
                .height(40)
                .backgroundColor('#F5F5F5')
                .borderRadius(20)
                .onClick(async () => {
                    await this.previousDay();
                })

                Text(this.formatDateHeader())
                    .fontSize(18)
                    .fontWeight(FontWeight.Medium)
                    .layoutWeight(1)
                    .textAlign(TextAlign.Center)

                Button('今日')
                    .backgroundColor('#F5F5F5')
                    .fontColor('#333333')
                    .borderRadius(20)
                    .onClick(async () => {
                        await this.goToToday()
                    })

                Button() {
                    Image($r('app.media.rightArrow'))
                        .fillColor('#666666')
                        .height(25)
                        .width(25)
                }
                .width(40)
                .height(40)
                .backgroundColor('#F5F5F5')
                .borderRadius(20)
                .onClick(async () => {
                    await this.nextDay();
                })
            }
            .width('100%')
            .padding({ left: 20, right: 20, top: 10, bottom: 10 })
            .justifyContent(FlexAlign.SpaceBetween)

            // 星期标题
            Row() {
                ForEach(['日', '一', '二', '三', '四', '五', '六'], (weekDay: string) => {
                    Text(weekDay)
                        .fontSize(14)
                        .fontColor('#999999')
                        .width('14.28%')
                        .textAlign(TextAlign.Center)
                })
            }
            .width('100%')
            .padding({ left: 20, right: 20, top: 10, bottom: 10 })

            // 日历网格
            Column() {
                ForEach(this.generateCalendarWeeks(), (week: number[]) => {
                    Row() {
                        ForEach(week, (day: number) => {
                            Text(day > 0 ? day.toString() : '')
                                .fontSize(16)
                                .width('14.28%')
                                .height(40)
                                .textAlign(TextAlign.Center)
                                .backgroundColor(day > 0 && this.isSelectedDate(day) ? '#007DFF' :
                                    day > 0 && this.isToday(day) ? '#E6F3FF' : 'transparent')
                                .fontColor(day > 0 && this.isSelectedDate(day) ? '#FFFFFF' :
                                    day > 0 && this.isToday(day) ? '#007DFF' : '#333333')
                                .borderRadius(8)
                                .fontWeight(day > 0 && (this.isSelectedDate(day) || this.isToday(day)) ? FontWeight.Bold : FontWeight.Normal)
                                .onClick(async () => {
                                    if (day > 0) {
                                        await this.onDateClick(day);
                                    }
                                })
                        })
                    }
                    .width('100%')
                })
            }
            .width('100%')
            .padding({ left: 20, right: 20, bottom: 10 })

            // 底部内容
            if (this.planData.length != 0) {
                Refresh({ refreshing: this.isRefreshing }) {
                    List({ space: '14.00vp' }) {
                        ForEach(this.planData, (item: PlanResponse) => {
                            ListItem() {
                                this.courseItem(item)
                            }
                            .width('92%')
                            .margin({ left: '4%', right: '4%' })
                            .backgroundColor($r('sys.color.comp_background_list_card'))
                            .borderRadius(12)
                            .shadow({ radius: 8, color: '#12000000', offsetX: 0, offsetY: 2 })
                        })
                    }
                    .margin({ top: '8.00vp', bottom: '16.00vp' })
                }
                .layoutWeight(1)
                .onRefreshing(async () => {
                    await this.handleRefresh();
                })
            } else {
                Refresh({ refreshing: this.isRefreshing }) {
                    Text('明日再来')
                        .fontSize(16)
                        .fontColor('#999999')
                        .margin({ top: 40 })
                }
                .onRefreshing(async () => {
                    await this.handleRefresh();
                })
            }
        }
        .width('100%')
        .height('100%')
        .backgroundColor($r('sys.color.comp_background_list_card'))
    }

    // 生成日历周数据
    generateCalendarWeeks(): number[][] {
        const year = this.currentDate.getFullYear();
        const month = this.currentDate.getMonth();
        const daysInMonth = this.getDaysInMonth(year, month);
        const firstDay = this.getFirstDayOfMonth(year, month);

        const weeks: number[][] = [];
        let currentWeek: number[] = [];

        // 填充第一周的空白天数
        for (let i = 0; i < firstDay; i++) {
            currentWeek.push(0);
        }

        // 填充月份的天数
        for (let day = 1; day <= daysInMonth; day++) {
            currentWeek.push(day);

            if (currentWeek.length === 7) {
                weeks.push(currentWeek);
                currentWeek = [];
            }
        }

        // 填充最后一周的空白天数
        while (currentWeek.length < 7 && currentWeek.length > 0) {
            currentWeek.push(0);
        }

        if (currentWeek.length > 0) {
            weeks.push(currentWeek);
        }

        return weeks;
    }

    @Builder
    courseItem(item: PlanResponse) {
        Column() {
            Row() {
                Column() {
                    Row() {
                        Text(item.medicine_name)
                            .fontSize(18)
                            .fontWeight(600)
                            .fontColor('#111111')
                            .maxLines(1)
                            .width('auto')
                            .constraintSize({ maxWidth: '50%' })
                            .textOverflow({ overflow: TextOverflow.Ellipsis })

                        Text(`${item.amount} ${item.type}`)
                            .margin({ left: '10vp' })
                            .fontSize(14)
                            .fontColor($r('sys.color.brand'))
                            .backgroundColor('#E6F3FF')
                            .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                            .borderRadius(4)
                    }

                    Text(`${item.plan_time} 不限`)
                        .margin({ top: '6vp' })
                        .fontSize(14)
                        .fontColor('#999999')
                }
                .alignItems(HorizontalAlign.Start)

                Button(item.is_checked ? '撤销打卡' : '打卡')
                    .type(ButtonType.Capsule)
                    .fontSize(15)
                    .fontColor($r('sys.color.comp_background_list_card'))
                    .backgroundColor(item.is_checked ? '#FF9500' : '#34C759')
                    .padding({ left: 20, right: 20 })
                    .onClick(() => {
                        // TODO: 打卡逻辑
                        // item.is_checked = item.is_checked ? 0 : 1;
                        console.info('is_checked: ', item.is_checked)
                        AlertDialog.show({
                            message: item.is_checked ? `确定要撤销这次打卡吗？` : `要开始打卡了吗？`,
                            buttons: [
                                { value: '取消', action: () => {} },
                                { value: '确认', action: async () => {
                                    try {
                                        const data = {
                                            id: item.record_id,
                                            actual_time: this.formatDateTimeWithSelectedDate(),
                                            is_checked: item.is_checked === 0 ? 1 : 0,
                                            plan_id: item.plan_id,
                                        } as PutRecordRequest

                                        const res = await recordManager.updateRecordCheckIn(data)
                                        if (res) {
                                            await this.loadData();
                                            promptAction.showToast({
                                                message: '打卡成功',
                                                duration: 2000
                                            });
                                        } else {
                                            promptAction.showToast({
                                                message: '打卡失败，请重试',
                                                duration: 2000
                                            });
                                        }

                                    } catch (error) {
                                        console.error('打卡失败:', error);
                                        promptAction.showToast({
                                            message: '操作失败，请重试',
                                            duration: 2000
                                        });
                                    }
                                } }
                            ]
                        })
                    })
            }
            .justifyContent(FlexAlign.SpaceBetween)
            .width('100%')
            .padding(15)
        }
    }
}