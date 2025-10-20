interface ListPlanData {
    plan_id: number,
    is_checked: number
    medicine_name: string,
    medicine_timing?: number,
    amount: number,
    type: string,
    plan_time: string,
    record_id: number
}

@Entry
@Component
export struct HomePage {
    @State currentDate: Date = new Date();
    @State selectedDate: Date = new Date();

    @State planData: ListPlanData[] = [
        {
            plan_id: 1001,
            is_checked: 0,
            medicine_name: '板蓝根',
            medicine_timing: 0,
            amount: 1,
            type: '粒',
            plan_time: '08:00',
            record_id: 101,
        },
        {
            plan_id: 1002,
            is_checked: 1,
            medicine_name: '维生素C',
            medicine_timing: 0,
            amount: 2,
            type: '粒',
            plan_time: '12:00',
            record_id: 102,
        },
        {
            plan_id: 1003,
            is_checked: 1,
            medicine_name: '板蓝根xxxxxxxxxxxxuuuuuuuuiiiiiiiuuuuiiiiiuuuuiiiiii',
            medicine_timing: 0,
            amount: 1,
            type: '粒',
            plan_time: '18:00',
            record_id: 103,
        }
    ]

    aboutToAppear() {
        this.selectedDate = new Date(this.currentDate);
    }

    // 获取月份的天数
    getDaysInMonth(year: number, month: number): number {
        return new Date(year, month + 1, 0).getDate();
    }

    // 获取月份第一天是星期几
    getFirstDayOfMonth(year: number, month: number): number {
        return new Date(year, month, 1).getDay();
    }

    // 格式化日期显示
    formatDateHeader(): string {
        const year = this.selectedDate.getFullYear();
        const month = String(this.selectedDate.getMonth() + 1).padStart(2, '0');
        const day = String(this.selectedDate.getDate()).padStart(2, '0');
        return `${year}-${month}-${day}`;
    }

    // 上一天
    previousDay() {
        const newDate = new Date(this.currentDate);
        newDate.setDate(newDate.getDate() - 1);
        this.currentDate = newDate;
        this.selectedDate = newDate;
    }

    goToToday() {
        const today = new Date();
        this.currentDate = today;
        this.selectedDate = new Date(today);
    }

    // 下一天
    nextDay() {
        const newDate = new Date(this.currentDate);
        newDate.setDate(newDate.getDate() + 1);
        this.currentDate = newDate;
        this.selectedDate = newDate;
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
    onDateClick(day: number) {
        this.selectedDate = new Date(this.currentDate.getFullYear(), this.currentDate.getMonth(), day);
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
                .onClick(() => {
                    this.previousDay();
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
                    .onClick(() => {
                        this.goToToday()
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
                .onClick(() => {
                    this.nextDay();
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
                                .onClick(() => {
                                    if (day > 0) {
                                        this.onDateClick(day);
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
                List({ space: '14.00vp' }) {
                    ForEach(this.planData, (item: ListPlanData) => {
                        ListItem() {
                            this.courseItem(item)
                        }
                        .width('92%')
                        .margin({ left: '4%', right: '4%' })
                        .backgroundColor('#FFFFFF')
                        .borderRadius(12)
                        .shadow({ radius: 8, color: '#12000000', offsetX: 0, offsetY: 2 })
                    })
                }
                .layoutWeight(1)
                .margin({ top: '8.00vp', bottom: '16.00vp' })
            } else {
                Text('明日再来')
                    .fontSize(16)
                    .fontColor('#999999')
                    .margin({ top: 40 })
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
    courseItem(item: ListPlanData) {
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
                            .fontColor('#007DFF')
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
                    .fontColor('#FFFFFF')
                    .backgroundColor(item.is_checked ? '#FF9500' : '#34C759')
                    .padding({ left: 20, right: 20 })
                    .onClick(() => {
                        // TODO: 打卡逻辑
                        item.is_checked = item.is_checked ? 0 : 1;
                    })
            }
            .justifyContent(FlexAlign.SpaceBetween)
            .width('100%')
            .padding(15)
        }
    }
}