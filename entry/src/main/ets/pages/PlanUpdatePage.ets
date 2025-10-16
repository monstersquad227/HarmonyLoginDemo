interface OptionItem {
    value: string;
}

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
    @State medicineName: string = '板蓝根';
    @State mode: number = 0; // 0:每日, 1:间隔
    @State dailyCount: number = 3;
    @State intervalDays: number = 2;
    @State intervalCount: number = 1;
    @State amount: string = '';
    @State unit: string = '';
    @State medicineType: number = 0; // 0:内服, 1:外用
    @State medicineTiming: number = 0;
    @State dailyTimes: string[] = ['08:00', '12:00', '18:00'];
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

    private handleSave(): void {
        if (!this.validate()) {
            return;
        }

        const saveData: GeneratedObjectLiteralInterface_1 = {
            medicineName: this.medicineName,
            mode: this.mode,
            dailyCount: this.dailyCount,
            intervalDays: this.intervalDays,
            intervalCount: this.intervalCount,
            amount: this.amount,
            unit: this.unit,
            medicineType: this.medicineType,
            medicineTiming: this.medicineTiming,
            dailyTimes: this.dailyTimes,
            intervalTimes: this.intervalTimes
        };

        console.log('保存数据:', saveData);
        AppStorage.setOrCreate('shouldRefreshCourse', true);
        this.popBack();
    }

    private popBack(): void {
        // const stack = this.planNavStackObj as any;
        // if (stack && stack.pop) {
        //     stack.pop();
        // } else {
        //     router.back();
        // }
    }

    // private getSelectOptions(): OptionItem[] {
    //     return this.getTimingOptions().map((value: string) => ({ value }));
    // }

    build() {
        NavDestination() {
            Scroll() {
                Column() {
                    List({ space: 14 }) {
                        this.buildMedicineNameCard()
                        this.buildModeSwitchCard()
                        this.buildDailyModeCard()
                        this.buildIntervalModeCard()
                        this.buildDosageCard()
                        this.buildMedicineTypeCard()
                        this.buildTimingCard()
                        this.buildSaveButton()
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

    @Builder
    buildModeSwitchCard() {
        ListItem() {
            Row() {
                Column({ space: 20 }) {
                    Text('服药频率模式')
                        .fontWeight(FontWeight.Bold)
                        .fontSize(16)

                    Row() {
                        Button('每日')
                            .layoutWeight(1)
                            .stateEffect(this.mode === 0)
                            .backgroundColor(this.mode === 0 ? '#2e6ae6' : '#FFFFFF')
                            .fontColor(this.mode === 0 ? '#FFFFFF' : '#2e6ae6')
                            .border({ width: 1, color: '#2e6ae6', radius: 8 })
                            .onClick(() => { this.mode = 0; })

                        Button('间隔')
                            .layoutWeight(1)
                            .stateEffect(this.mode === 1)
                            .backgroundColor(this.mode === 1 ? '#2e6ae6' : '#FFFFFF')
                            .fontColor(this.mode === 1 ? '#FFFFFF' : '#2e6ae6')
                            .border({ width: 1, color: '#2e6ae6', radius: 8 })
                            .onClick(() => { this.mode = 1; })
                    }
                    .width('100%')
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

    @Builder
    buildDailyModeCard() {
        if (this.mode === 0) {
            ListItem() {
                Row() {
                    Column({ space: 20 }) {
                        Text('每日次数')
                            .fontWeight(FontWeight.Bold)
                            .fontSize(16)

                        TextInput({
                            text: String(this.dailyCount)
                        })
                            .width('100%')
                            .border({ width: 1, color: '#e5e7eb', radius: 8 })
                            .padding(10)
                            .onChange((value: string) => {
                                const count = parseInt(value) || 1;
                                this.dailyCount = Math.max(1, count);
                                this.updateTimeCount(this.dailyCount, true);
                            })

                        Text('服药时间点')
                            .fontWeight(FontWeight.Bold)
                            .fontSize(16)

                        ForEach(this.dailyTimes, (time: string, index: number) => {
                            Row() {
                                Text(`第${index + 1}次时间`)
                                    .fontSize(14)
                                    .layoutWeight(1)

                                Button(time || '请选择时间')
                                    .layoutWeight(2)
                                    .border({ width: 1, color: '#e5e7eb', radius: 8 })
                                    .fontColor('#000000')
                                    .backgroundColor('#F2F2F2')
                                    .onClick(() => { this.pickTime(index, true); })
                            }
                            .width('100%')
                            .margin({ bottom: 10 })
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

    @Builder
    buildIntervalModeCard() {
        if (this.mode === 1) {
            ListItem() {
                Row() {
                    Column({ space: 20 }) {
                        Row() {
                            Column({ space: 10 }) {
                                Text('每隔几天')
                                    .fontWeight(FontWeight.Bold)
                                    .fontSize(16)

                                TextInput({
                                    text: String(this.intervalDays)
                                })
                                    .width('100%')
                                    .border({ width: 1, color: '#e5e7eb', radius: 8 })
                                    .padding(10)
                                    .onChange((value: string) => {
                                        this.intervalDays = parseInt(value) || 1;
                                    })
                            }
                            .layoutWeight(1)

                            Column({ space: 10 }) {
                                Text('每次次数')
                                    .fontWeight(FontWeight.Bold)
                                    .fontSize(16)

                                TextInput({
                                    text: String(this.intervalCount)
                                })
                                    .width('100%')
                                    .border({ width: 1, color: '#e5e7eb', radius: 8 })
                                    .padding(10)
                                    .onChange((value: string) => {
                                        const count = parseInt(value) || 1;
                                        this.intervalCount = Math.max(1, count);
                                        this.updateTimeCount(this.intervalCount, false);
                                    })
                            }
                            .layoutWeight(1)
                        }
                        .width('100%')

                        Text('服药时间点')
                            .fontWeight(FontWeight.Bold)
                            .fontSize(16)

                        ForEach(this.intervalTimes, (time: string, index: number) => {
                            Row() {
                                Text(`第${index + 1}次时间`)
                                    .fontSize(14)
                                    .layoutWeight(1)

                                Button(time || '请选择时间')
                                    .layoutWeight(2)
                                    .border({ width: 1, color: '#e5e7eb', radius: 8 })
                                    .fontColor('#000000')
                                    .backgroundColor('#F2F2F2')
                                    .onClick(() => { this.pickTime(index, false); })
                            }
                            .width('100%')
                            .margin({ bottom: 10 })
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

    @Builder
    buildDosageCard() {
        ListItem() {
            Row() {
                Column({ space: 20 }) {
                    Text('每次用量与单位')
                        .fontWeight(FontWeight.Bold)
                        .fontSize(16)

                    Row() {
                        TextInput({
                            placeholder: '数量',
                            text: this.amount
                        })
                            .layoutWeight(1)
                            .border({ width: 1, color: '#e5e7eb', radius: 8 })
                            .padding(10)
                            .onChange((value: string) => {
                                this.amount = value;
                            })

                        TextInput({
                            placeholder: '单位',
                            text: this.unit
                        })
                            .layoutWeight(1)
                            .border({ width: 1, color: '#e5e7eb', radius: 8 })
                            .padding(10)
                            .margin({ left: 10 })
                            .onChange((value: string) => {
                                this.unit = value;
                            })
                    }
                    .width('100%')
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

    @Builder
    buildMedicineTypeCard() {
        ListItem() {
            Row() {
                Column({ space: 20 }) {
                    Text('用药方式')
                        .fontWeight(FontWeight.Bold)
                        .fontSize(16)

                    Row() {
                        Radio({ group: 'medicineType', value: '0', })
                            .checked(this.medicineType === 0)
                            .onChange((checked: boolean) => {
                                if (checked) this.medicineType = 0;
                            })
                        Text('内服')
                            .fontSize(14)
                            .margin({ left: 5 })

                        Radio({ group: 'medicineType', value: '1', })
                            .checked(this.medicineType === 1)
                            .onChange((checked: boolean) => {
                                if (checked) this.medicineType = 1;
                            })
                        Text('外用')
                            .fontSize(14)
                            .margin({ left: 5 })
                    }
                    .width('100%')
                    .justifyContent(FlexAlign.Start)
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

    @Builder
    buildTimingCard() {
        ListItem() {
            Row() {
                Column({ space: 20 }) {
                    Text('用药时机')
                        .fontWeight(FontWeight.Bold)
                        .fontSize(16)

                    Select([
                        { value: '不限' },
                        { value: '饭前用药' },
                        { value: '饭后用药' },
                        { value: '随餐用药' },
                        { value: '睡前用药' }
                    ])
                        .width('100%')
                        .border({ width: 1, color: '#e5e7eb', radius: 8 })
                        .onSelect((index: number) => {
                            this.medicineTiming = index;
                        })
                        .value(this.getTimingOptions()[this.medicineTiming])
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

    @Builder
    buildSaveButton() {
        ListItem() {
            Row() {
                Button('保存')
                    .width('100%')
                    .height(42)
                    .fontSize(15)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#2e6ae6')
                    .backgroundColor('#FFFFFF')
                    .border({ width: 1, color: '#2e6ae6', radius: 8 })
                    .onClick(() => { this.handleSave(); })
            }
            .width('100%')
            .padding(10)
        }
        .width('92%')
        .margin({ left: '4%', right: '4%', bottom: 20 })
        .backgroundColor('#FFFFFF')
        .borderRadius(12)
        .shadow({ radius: 8, color: '#12000000', offsetX: 0, offsetY: 2 })
    }
}