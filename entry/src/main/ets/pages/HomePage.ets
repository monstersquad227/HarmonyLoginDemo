@Component
export struct HomePage {
  @State currentDate: Date = new Date();
  @State selectedDate: Date = new Date();

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
    const year = this.currentDate.getFullYear();
    const month = String(this.currentDate.getMonth() + 1).padStart(2, '0');
    const day = String(this.currentDate.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
  }

  // 上一天
  previousDay() {
    const newDate = new Date(this.currentDate);
    newDate.setDate(newDate.getDate() - 1);
    this.currentDate = newDate;
  }

  // 下一天
  nextDay() {
    const newDate = new Date(this.currentDate);
    newDate.setDate(newDate.getDate() + 1);
    this.currentDate = newDate;
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
        Button('<')
          .width(40)
          .height(40)
          .backgroundColor('#F0F0F0')
          .fontColor('#333333')
          .onClick(() => {
            this.previousDay();
          })

        Text(this.formatDateHeader())
          .fontSize(18)
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)

        Button('>')
          .width(40)
          .height(40)
          .backgroundColor('#F0F0F0')
          .fontColor('#333333')
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
            .fontColor('#666666')
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
                                day > 0 && this.isToday(day) ? '#FFE6E6' : 'transparent')
                .fontColor(day > 0 && this.isSelectedDate(day) ? '#FFFFFF' : 
                          day > 0 && this.isToday(day) ? '#FF4444' : '#333333')
                .borderRadius(4)
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
      .padding({ left: 20, right: 20 })

      // 底部按钮
      Column() {
        Button('今日任务')
          .width('80%')
          .height(50)
          .margin({ top: 30 })
          .onClick(() => {
            // 这里可以添加按钮点击逻辑
          })

        Button('添加事件')
          .width('80%')
          .height(50)
          .margin({ top: 15 })
          .backgroundColor('#FF6B35')
          .onClick(() => {
            // 这里可以添加按钮点击逻辑
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)

    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
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
}