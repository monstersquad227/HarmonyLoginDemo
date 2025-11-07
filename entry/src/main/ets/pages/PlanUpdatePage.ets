import { PutCourseRequest } from "../api/CourseApiService";
import { JSON } from "@kit.ArkTS";
import { courseManager } from "../manager/CourseManager";
import { VibrationUtil } from "../common/VibrationUtil";

interface GeneratedObjectLiteralInterface_1 {
    medicineName: string;
    mode: number;
    dailyCount: number;
    intervalDays: number;
    intervalCount: number;
    amount: string;
    unit: string;
    medicineType: number;
    medicineTiming: number;
    dailyTimes: string[];
    intervalTimes: string[];
}

@Component
export struct PlanUpdatePage {
    @State courseID: number = 0;
    @State medicineName: string = '';
    @State mode: number = 0; // 0:每日, 1:间隔
    @State dailyCount: number = 0;
    @State intervalDays: number = 2;
    @State intervalCount: number = 1;
    @State amount: string = '';
    @State unit: string = '';
    @State medicineType: number = 0; // 0:内服, 1:外用
    @State medicineTiming: number = 0;
    @State dailyTimes: string[] = [];
    @State intervalTimes: string[] = ['08:00'];
    @StorageProp('planNavStack') planNavStackObj: Object | null = null;

    private updateTimeCount(count: number, isDaily: boolean = true): void {
        if (isDaily) {
            const diff = count - this.dailyTimes.length;
            if (diff > 0) {
                this.dailyTimes = [...this.dailyTimes, ...Array(diff).fill('08:00')];
            } else if (diff < 0) {
                this.dailyTimes = this.dailyTimes.slice(0, count);
            }
        } else {
            const diff = count - this.intervalTimes.length;
            if (diff > 0) {
                this.intervalTimes = [...this.intervalTimes, ...Array(diff).fill('08:00')];
            } else if (diff < 0) {
                this.intervalTimes = this.intervalTimes.slice(0, count);
            }
        }
    }

    private pickTime(index: number, isDaily: boolean = true): void {
        const date = new Date();
        this.getUIContext().showTimePickerDialog({
            useMilitaryTime: true,
            selected: date,
            onAccept: (value: TimePickerResult) => {
                const time = `${String(value.hour).padStart(2, '0')}:${String(value.minute).padStart(2, '0')}`;
                if (isDaily) {
                    this.dailyTimes[index] = time;
                } else {
                    this.intervalTimes[index] = time;
                }
            }
        });
    }

    private getTimingOptions(): string[] {
        return ['不限', '饭前用药', '饭后用药', '随餐用药', '睡前用药'];
    }

    private validate(): boolean {
        if (!this.medicineName.trim()) {
            AlertDialog.show({ message: '请输入药品名' });
            return false;
        }
        if (this.amount.trim() === '' || this.unit.trim() === '') {
            AlertDialog.show({ message: '请输入完整的用量信息' });
            return false;
        }
        if (this.mode === 0) {
            if (this.dailyTimes.some((time: string) => !time)) {
                AlertDialog.show({ message: '请设置所有服药时间点' });
                return false;
            }
        } else {
            if (this.intervalTimes.some((time: string) => !time)) {
                AlertDialog.show({ message: '请设置所有服药时间点' });
                return false;
            }
        }
        return true;
    }

    private async handleSave(): Promise<void> {
        if (!this.validate()) {
            return;
        }

        const data: PutCourseRequest = {
            course_id: this.courseID,
            user_id: Number(AppStorage.get('login_user_id')),
            medicine_name: this.medicineName, // 厄贝沙坦氢氟噻嗪片
            medicine_type: this.medicineType, // 0 外用； 1 内用
            medicine_timing: this.medicineTiming, // 0 不限; 1 饭前用药; 2 饭后用药; 3 随餐用药; 4 睡前用药;
            course_start_time: this.generateCourseStartTime(), // 开始日期  2025-05-27 19:00:00
            course_start_times: this.dailyTimes,
            amount: parseInt(this.amount), // 用药数量
            type: this.unit, // 剂量单位
            plan_time: this.generateTime(this.generateCourseStartTime()),
            frequency: this.dailyCount,
        };

        await courseManager.updateCourse(data)
        AppStorage.setOrCreate('shouldRefreshCourse', true);
        this.popBack();
    }

    private popBack(): void {
        const stack = AppStorage.get<NavPathStack>('planNavStack');
        if (stack) {
            stack.pop();
        }
    }

    private splitTimeString(timeStr: string): string[] {
        return timeStr.split(',');
    }

    private generateCourseStartTime(): string {
        const date = new Date();
        let yearStr = date.getFullYear().toString()
        let year = String(yearStr).padStart(2, '0')
        let monthStr = (date.getMonth() + 1).toString()
        let month = String(monthStr).padStart(2, '0')
        let dayStr = date.getDate().toString()
        let day = String(dayStr).padStart(2, '0')
        let time = this.dailyTimes[0]
        return `${year}-${month}-${day} ${time}`
    }

    private generateTime(date: string): string {
        let time = date.split(' ')
        if (time.length !== 2) {
            return '';
        }
        let timePart = time[1];
        let timeParts = timePart.split(':');
        if (timeParts.length < 2) {
            return '';
        }
        return `${timeParts[0]}:${timeParts[1]}`;
    }

    build() {
        NavDestination() {
            Column() {
                Scroll() {
                    Column() {
                        List({ space: 14 }) {
                            this.buildMedicineNameAndModeSwitchCard()
                            this.buildDailyModeCard()
                            this.buildDosageCard()
                            this.buildMedicineTypeAndTimingCard()
                        }
                    }
                    .width('100%')
                }
                .layoutWeight(1)
                .backgroundColor('#F7F8FA')

                // 底部保存按钮固定
                this.buildSaveButton()
            }
            .width('100%')
            .height('100%')
            .backgroundColor('#F7F8FA')
        }
        .title('修改用药方案')
        .onReady((context: NavDestinationContext) => {
            // 正确的方式：直接从 pathStack 获取参数
            const params = context.pathStack.getParamByName('PlanUpdatePage') as PutCourseRequest[];

            console.info("PlanUpdatePage: received params", JSON.stringify(params));

            // params 是数组，取第一个元素
            if (params && params.length > 0) {
                const data = params[0];

                this.courseID = data.course_id;
                this.medicineName = data.medicine_name;
                this.medicineType = data.medicine_type;
                this.medicineTiming = data.medicine_timing || 0;
                this.dailyTimes = this.splitTimeString(data.plan_time)
                this.dailyCount = data.frequency ;
                this.amount = data.amount?.toString();
                this.unit = data.type;

                // 根据 dailyCount 更新时间数组
                if (this.dailyCount > 0) {
                    this.updateTimeCount(this.dailyCount, true);
                }
            }
        })
        .onBackPressed(() => {
            // 触发震动反馈
            VibrationUtil.medium();
            return false;
        })
    }

    @Builder
    buildMedicineNameAndModeSwitchCard() {
        ListItem() {
            Column({ space: 16 }) {
                // 药品名
                Column({ space: 8 }) {
                    Text('药品名')
                        .fontWeight(FontWeight.Bold)
                        .fontSize(16)
                        .fontColor('#111111')
                        .alignSelf(ItemAlign.Start)

                    TextInput({
                        placeholder: '请输入药品名',
                        text: this.medicineName
                    })
                        .width('100%')
                        .border({ width: 1, color: '#E0E0E0', radius: 8 })
                        .backgroundColor('#FAFAFA')
                        .padding({ left: 12, right: 12, top: 10, bottom: 10 })
                        .onChange((value: string) => {
                            this.medicineName = value;
                        })
                }

                // 服药频率
                Column({ space: 8 }) {
                    Text('服药频率')
                        .fontWeight(FontWeight.Bold)
                        .fontSize(16)
                        .fontColor('#111111')
                        .alignSelf(ItemAlign.Start)

                    Row() {
                        Button('每日')
                            .layoutWeight(1)
                            .height(42)
                            .stateEffect(this.mode === 0)
                            .backgroundColor(this.mode === 0 ? '#007DFF' : '#FFFFFF')
                            .fontColor(this.mode === 0 ? '#FFFFFF' : '#007DFF')
                            .fontSize(15)
                            .border({ width: 1, color: '#007DFF', radius: 8 })
                            .onClick(() => { this.mode = 0; })
                    }
                    .width('100%')
                }
            }
            .width('100%')
            .padding(16)
        }
        .width('92%')
        .margin({ left: '4%', right: '4%', top: 12 })
        .backgroundColor($r('sys.color.comp_background_list_card'))
        .borderRadius(12)
        .shadow({ radius: 8, color: '#12000000', offsetX: 0, offsetY: 2 })
    }

    @Builder
    buildDailyModeCard() {
        if (this.mode === 0) {
            ListItem() {
                Column({ space: 16 }) {
                    // 每日次数
                    Column({ space: 8 }) {
                        Text('每日次数')
                            .fontWeight(FontWeight.Bold)
                            .fontSize(16)
                            .fontColor('#111111')
                            .alignSelf(ItemAlign.Start)

                        TextInput({
                            text: String(this.dailyCount)
                        })
                            .width('100%')
                            .border({ width: 1, color: '#E0E0E0', radius: 8 })
                            .backgroundColor('#FAFAFA')
                            .padding({ left: 12, right: 12, top: 10, bottom: 10 })
                            .type(InputType.Number)
                            .onChange((value: string) => {
                                const count = parseInt(value) || 1;
                                this.dailyCount = Math.max(1, count);
                                this.updateTimeCount(this.dailyCount, true);
                            })
                    }

                    // 服药时间点
                    Column({ space: 10 }) {
                        Text('服药时间点')
                            .fontWeight(FontWeight.Bold)
                            .fontSize(16)
                            .fontColor('#111111')
                            .alignSelf(ItemAlign.Start)

                        ForEach(this.dailyTimes, (time: string, index: number) => {
                            Row() {
                                Text(`第 ${index + 1} 次`)
                                    .fontSize(15)
                                    .fontColor('#666666')
                                    .width(70)

                                Button(time || '请选择时间')
                                    .layoutWeight(1)
                                    .height(40)
                                    .border({ width: 1, color: '#E0E0E0', radius: 8 })
                                    .fontColor('#333333')
                                    .fontSize(15)
                                    .backgroundColor('#FAFAFA')
                                    .onClick(() => { this.pickTime(index, true); })
                            }
                            .width('100%')
                        })
                    }
                }
                .width('100%')
                .padding(16)
            }
            .width('92%')
            .margin({ left: '4%', right: '4%' })
            .backgroundColor($r('sys.color.comp_background_list_card'))
            .borderRadius(12)
            .shadow({ radius: 8, color: '#12000000', offsetX: 0, offsetY: 2 })
        }
    }

    @Builder
    buildDosageCard() {
        ListItem() {
            Column({ space: 8 }) {
                Text('每次用量')
                    .fontWeight(FontWeight.Bold)
                    .fontSize(16)
                    .fontColor('#111111')
                    .alignSelf(ItemAlign.Start)

                Row({ space: 10 }) {
                    TextInput({
                        placeholder: '数量',
                        text: this.amount
                    })
                        .layoutWeight(1)
                        .border({ width: 1, color: '#E0E0E0', radius: 8 })
                        .backgroundColor('#FAFAFA')
                        .padding({ left: 12, right: 12, top: 10, bottom: 10 })
                        .type(InputType.Number)
                        .onChange((value: string) => {
                            this.amount = value;
                        })

                    TextInput({
                        placeholder: '单位',
                        text: this.unit
                    })
                        .layoutWeight(1)
                        .border({ width: 1, color: '#E0E0E0', radius: 8 })
                        .backgroundColor('#FAFAFA')
                        .padding({ left: 12, right: 12, top: 10, bottom: 10 })
                        .onChange((value: string) => {
                            this.unit = value;
                        })
                }
                .width('100%')
            }
            .width('100%')
            .padding(16)
        }
        .width('92%')
        .margin({ left: '4%', right: '4%' })
        .backgroundColor($r('sys.color.comp_background_list_card'))
        .borderRadius(12)
        .shadow({ radius: 8, color: '#12000000', offsetX: 0, offsetY: 2 })
    }

    @Builder
    buildMedicineTypeAndTimingCard() {
        ListItem() {
            Column({ space: 16 }) {
                // 用药方式
                Column({ space: 8 }) {
                    Text('用药方式')
                        .fontWeight(FontWeight.Bold)
                        .fontSize(16)
                        .fontColor('#111111')
                        .alignSelf(ItemAlign.Start)

                    Row({ space: 24 }) {
                        Row({ space: 6 }) {
                            Radio({ group: 'medicineType', value: '0' })
                                .checked(this.medicineType === 0)
                                .onChange((checked: boolean) => {
                                    if (checked) this.medicineType = 0;
                                })
                            Text('内服')
                                .fontSize(15)
                                .fontColor('#333333')
                        }

                        Row({ space: 6 }) {
                            Radio({ group: 'medicineType', value: '1' })
                                .checked(this.medicineType === 1)
                                .onChange((checked: boolean) => {
                                    if (checked) this.medicineType = 1;
                                })
                            Text('外用')
                                .fontSize(15)
                                .fontColor('#333333')
                        }
                    }
                    .width('100%')
                }

                // 用药时机
                Column({ space: 8 }) {
                    Text('用药时机')
                        .fontWeight(FontWeight.Bold)
                        .fontSize(16)
                        .fontColor('#111111')
                        .alignSelf(ItemAlign.Start)

                    Select([
                        { value: '不限' },
                        { value: '饭前用药' },
                        { value: '饭后用药' },
                        { value: '随餐用药' },
                        { value: '睡前用药' }
                    ])
                        .width('100%')
                        .border({ width: 1, color: '#E0E0E0', radius: 8 })
                        .backgroundColor('#FAFAFA')
                        .onSelect((index: number) => {
                            this.medicineTiming = index;
                        })
                        .value(this.getTimingOptions()[this.medicineTiming])
                }
            }
            .width('100%')
            .padding(16)
        }
        .width('92%')
        .margin({ left: '4%', right: '4%' })
        .backgroundColor($r('sys.color.comp_background_list_card'))
        .borderRadius(12)
        .shadow({ radius: 8, color: '#12000000', offsetX: 0, offsetY: 2 })
    }

    @Builder
    buildSaveButton() {
        Button('保存')
            .width('92%')
            .height(48)
            .margin({ left: '4%', right: '4%', top: 12, bottom: 16 })
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor($r('sys.color.comp_background_list_card'))
            .backgroundColor($r('sys.color.brand'))
            .borderRadius(24)
            .onClick(() => {
                // 触发震动反馈
                VibrationUtil.medium();
                this.handleSave();
            })
    }
}