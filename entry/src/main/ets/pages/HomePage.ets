import { PlanResponse } from "../api/PlanApiService";
import { planManager } from "../manager/PlanManager";
import { emitter } from "@kit.BasicServicesKit";
import { recordManager } from "../manager/RecordManager";
import { PutRecordRequest } from "../api/RecordApiService";
import { promptAction } from "@kit.ArkUI";
import { vibrator } from "@kit.SensorServiceKit";
import { VibrationUtil } from "../common/VibrationUtil";

interface validateCheckInResponse {
    isValid: boolean;
    message: string;
}

@Entry
@Component
export struct HomePage {
    @State currentDate: Date = new Date();
    @State selectedDate: Date = new Date();
    @State planData: PlanResponse[] = [];
    @State isRefreshing: boolean = false;

    // 定义事件 ID（与 MainTabs 中一致）
    private readonly SWITCH_TAB_EVENT_ID = 1001;
    private readonly REFRESH_HOME_EVENT_ID = 2001;

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

        // 订阅tab切换事件
        emitter.on({ eventId: this.REFRESH_HOME_EVENT_ID }, async () => {
            console.info('HomePage received refresh event from tab switch');
            await this.loadData();
        });
        // 初始加载
        this.selectedDate = new Date(this.currentDate);
        await this.loadData();
    }

    aboutToDisappear() {
        // 取消订阅
        emitter.off(this.SWITCH_TAB_EVENT_ID);
        emitter.off(this.REFRESH_HOME_EVENT_ID);
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

    // 上一个月
    async previousMonth() {
        const newDate = new Date(this.currentDate);
        const currentDay = newDate.getDate();
        newDate.setMonth(newDate.getMonth() - 1);
        // 如果日期发生了意外变化（如1月31日变成3月3日），修正到上月最后一天
        if (newDate.getDate() !== currentDay) {
            newDate.setDate(0); // 设置为上个月的最后一天
        }
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

    // 下一个月
    async nextMonth() {
        const newDate = new Date(this.currentDate);
        const currentDay = newDate.getDate();
        newDate.setMonth(newDate.getMonth() + 1);
        // 如果日期发生了意外变化，修正到当月最后一天
        if (newDate.getDate() < currentDay) {
            newDate.setDate(0); // 设置为当月的最后一天
        }
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
        this.currentDate = this.selectedDate
        await this.loadData();
    }

    // 验证打卡条件
    validateCheckIn(item: PlanResponse): validateCheckInResponse {
        const today = new Date();
        // const selectedDate = this.selectedDate;

        // 判断1: 不能打不是今日的卡（打卡和撤销打卡都需要验证）
        // const isSameDay = today.getFullYear() === selectedDate.getFullYear() &&
        //     today.getMonth() === selectedDate.getMonth() &&
        //     today.getDate() === selectedDate.getDate();
        //
        // if (!isSameDay) {
        //     return { isValid: false, message: item.is_checked === 1 ? '只能撤销今日的打卡' : '只能打今日的卡' };
        // }

        // 如果是撤销打卡，只需验证日期，无需验证时间
        // if (item.is_checked === 1) {
        //     return { isValid: true, message: '' };
        // }

        // 判断2: 在计划打卡时间前15分钟内才可以打卡
        // 解析 plan_time 格式 "HH:mm"
        const planTimeParts = item.plan_time.split(':');
        if (planTimeParts.length !== 2) {
            return { isValid: false, message: '计划时间格式错误' };
        }

        const planHour = parseInt(planTimeParts[0]);
        const planMinute = parseInt(planTimeParts[1]);

        // 创建计划时间的 Date 对象
        const planDateTime = new Date(
            today.getFullYear(),
            today.getMonth(),
            today.getDate(),
            planHour,
            planMinute,
            0
        );

        // 计算提前15分钟的时间
        const earliestCheckInTime = new Date(planDateTime.getTime() - 15 * 60 * 1000);

        // 当前时间
        const now = new Date();

        if (now < earliestCheckInTime) {
            // const minutesUntil = Math.ceil((earliestCheckInTime.getTime() - now.getTime()) / (60 * 1000));
            return {
                isValid: false,
                message: `请在规定时间内打卡`
            };
        }

        return { isValid: true, message: '' };
    }

    // 检查是否是过去的日期（用于按钮置灰）
    isPastDate(selectedDate: Date): boolean {
        const today = new Date();
        today.setHours(0, 0, 0, 0);
        const selected = new Date(selectedDate);
        selected.setHours(0, 0, 0, 0);

        return selected < today;
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
                    // 触发震动反馈
                    VibrationUtil.medium()
                    await this.previousMonth();
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
                        // 触发震动反馈
                        VibrationUtil.medium()
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
                    // 触发震动反馈
                    VibrationUtil.medium()
                    await this.nextMonth();
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
                                        // 触发震动反馈
                                        VibrationUtil.medium()
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
                    // 触发震动反馈
                    VibrationUtil.medium()
                    await this.handleRefresh();
                })
            } else {
                Refresh({ refreshing: this.isRefreshing }) {
                    Text('暂无用药方案')
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

                Button(
                  item.is_checked
                      ? (this.isPastDate(this.selectedDate) ? '已打卡' : '已打卡')
                      : (this.isPastDate(this.selectedDate) ? '未打卡' : '打卡'))
                    .type(ButtonType.Capsule)
                    .fontSize(15)
                    .fontColor(this.isPastDate(this.selectedDate)
                        ? (item.is_checked ? (item.record_status === 1 ? '#FF9500' : '#34C759') : '#FF3B30')
                        : $r('sys.color.comp_background_list_card'))
                    .backgroundColor(this.isPastDate(this.selectedDate) ? '#E5E5E5' :
                        (item.is_checked ? '#FF9500' : '#34C759'))
                    .enabled(!this.isPastDate(this.selectedDate))
                    .opacity(this.isPastDate(this.selectedDate) ? 0.8 : 1)
                    .padding({ left: 20, right: 20 })
                    .onClick(() => {
                        // 触发震动反馈
                        VibrationUtil.medium()

                        // 验证打卡条件
                        const validationResult = this.validateCheckIn(item);
                        if (!validationResult.isValid) {
                            promptAction.showToast({
                                message: validationResult.message,
                                duration: 2000
                            });
                            return;
                        }
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