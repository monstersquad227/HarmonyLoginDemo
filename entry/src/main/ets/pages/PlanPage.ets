import { PlanUpdatePage } from "./PlanUpdatePage";

// 计划页数据类型定义
interface ListCourseData {
    course_id: number;
    medicine_name: string;
    frequency: number;                 // 每日次数
    medicine_timing: string;           // 用药时机（如不限/饭前/饭后）
    medicine_type: string;             // 用药类型（如内服/外用）
    course_start_time: string;         // 开始日期（YYYY-MM-DD）
    plan_times: number;                // 计划总次数（如需）
    type: string;                      // 方案类型（备用字段）
    amount: string;                    // 每次用量描述
}

// 删除回调包装类型
interface DeletedWrapper {
    callback: () => Promise<void> | void;
}

@Entry
@Component
export struct PlanPage {
    // 示例数据；实际项目中可通过API/Manager加载
    @State courseData: ListCourseData[] = [
        {
            course_id: 1001,
            medicine_name: '板蓝根',
            frequency: 2,
            medicine_timing: '不限',
            medicine_type: '内服',
            course_start_time: '2025-06-29',
            plan_times: 0,
            type: 'default',
            amount: '每次2片'
        },
        {
            course_id: 1001,
            medicine_name: '板蓝根',
            frequency: 2,
            medicine_timing: '不限',
            medicine_type: '内服',
            course_start_time: '2025-06-29',
            plan_times: 0,
            type: 'default',
            amount: '每次2片'
        },
        {
            course_id: 1001,
            medicine_name: '板蓝根',
            frequency: 2,
            medicine_timing: '不限',
            medicine_type: '内服',
            course_start_time: '2025-06-29',
            plan_times: 0,
            type: 'default',
            amount: '每次2片'
        },
        {
            course_id: 1001,
            medicine_name: '板蓝根',
            frequency: 2,
            medicine_timing: '不限',
            medicine_type: '内服',
            course_start_time: '2025-06-29',
            plan_times: 0,
            type: 'default',
            amount: '每次2片'
        },
        {
            course_id: 1001,
            medicine_name: '板蓝根',
            frequency: 2,
            medicine_timing: '不限',
            medicine_type: '内服',
            course_start_time: '2025-06-29',
            plan_times: 0,
            type: 'default',
            amount: '每次2片'
        },
        {
            course_id: 1001,
            medicine_name: '板蓝根',
            frequency: 2,
            medicine_timing: '不限',
            medicine_type: '内服',
            course_start_time: '2025-06-29',
            plan_times: 0,
            type: 'default',
            amount: '每次2片'
        }
    ];
    @StorageLink('editingCourse') editingCourse: Object | null = null;
    private navPathStack: NavPathStack = new NavPathStack();

    // 刷新数据（示例）
    async refreshCourseData() {
        // 这里可以调用Manager层重新拉取数据
        // 目前做一个简单提示或日志
        console.log('refreshCourseData called');
    }

    // 文案转换（可按业务调整）
    translateMedicineTime(value: string): string {
        // 可根据业务枚举做更完整映射
        return value;
    }

    translateType(value: string): string {
        return value;
    }

    splitDate(dateStr: string): string {
        // 传入 'YYYY-MM-DD'，直接展示或做格式化
        return dateStr;
    }

    // 修改方案：写入AppStorage并导航到编辑页
    onModifyScheme(item: ListCourseData) {
        AppStorage.setOrCreate('editingCourse', item as Object);
        this.navPathStack.pushPath({ name: 'PlanUpdatePage' });
    }

    // 结束用药（示例）
    async onEndMedicine(item: ListCourseData, onDeleted?: DeletedWrapper) {
        AlertDialog.show({
            message: '确定结束 ' + item.medicine_name + ' 用药吗？',
            buttons: [
                { value: '取消', action: () => {} },
                { value: '确定', action: async () => {
                    // TODO: 调用删除接口或Manager逻辑
                    console.log('结束用药: ', item.course_id);
                    if (onDeleted) {
                        await onDeleted.callback();
                    }
                }
                }
            ]
        });
    }

    build() {
        Navigation(this.navPathStack) {
            // 页面容器
            Scroll() {
                Column() {
                    // 列表区域
                    List({ space: '14.00vp' }) {
                        ForEach(this.courseData, (item: ListCourseData) => {
                            ListItem() {
                                this.PlanItem(item, { callback: async () => await this.refreshCourseData() })
                            }
                            .width('92%')
                            .margin({ left: '4%', right: '4%' })
                            .backgroundColor('#FFFFFF')
                            .borderRadius(12)
                            .shadow({ radius: 8, color: '#12000000', offsetX: 0, offsetY: 2 })
                        })
                    }
                    .margin({ top: '8.00vp', bottom: '16.00vp' })
                }
                .justifyContent(FlexAlign.Start)
                .align(Alignment.TopStart)
                .padding(10)
                .width('100%')
                .backgroundColor('#F7F8FA')
            }
            .height('92%')

            Column() {
                Button('添加方案')
                    .width('100%')
            }
            .height('8%')
            .width('92%')
            .margin({ left: '4%', right: '4%' })
            .padding(10)
            .backgroundColor('#F7F8FA')
        }
        .navDestination(this.navDestinationBuilder)
    }

    // 子项UI构建器
    @Builder
    PlanItem(item: ListCourseData, onDeletedWrapper?: DeletedWrapper) {
        Column() {
            // 顶部标题与副标题
            Column() {
                Text(item.medicine_name)
                    .fontSize('18.00vp')
                    .fontWeight(FontWeight.Medium)
                    .fontColor('#1F2329')
                    .alignSelf(ItemAlign.Start)

                Text(this.splitDate(item.course_start_time) + ' 开始')
                    .fontSize('16.00vp')
                    .fontColor('#8A8F98')
                    .alignSelf(ItemAlign.Start)
                    .margin({ top: '4.00vp' })
            }
            .width('100%')
            .padding({ top: '14.00vp', left: '16.00vp', right: '16.00vp' })

            // 信息标签区
            Row() {
                // 次数 + 时机标签
                Text('每日 ' + item.frequency + ' 次')
                    .fontSize('14.00vp')
                    .fontColor('#2E6AE6')
                    .backgroundColor('#EEF5FF')
                    .borderRadius(12)
                    .padding({ left: '8.00vp', right: '8.00vp', top: '4.00vp', bottom: '4.00vp' })

                Text(this.translateMedicineTime(item.medicine_timing))
                    .fontSize('14.00vp')
                    .fontColor('#6B7280')
                    .backgroundColor('#F0F2F5')
                    .borderRadius(12)
                    .padding({ left: '8.00vp', right: '8.00vp', top: '4.00vp', bottom: '4.00vp' })
                    .margin({ left: '8.00vp' })

                Blank().layoutWeight(1)

                // 类型标签右侧展示
                Text(this.translateType(item.medicine_type))
                    .fontSize('14.00vp')
                    .fontColor('#10B981')
                    .backgroundColor('#E8FBF4')
                    .borderRadius(12)
                    .padding({ left: '8.00vp', right: '8.00vp', top: '4.00vp', bottom: '4.00vp' })
            }
            .width('100%')
            .padding({ left: '16.00vp', right: '16.00vp', top: '8.00vp' })

            // 分隔线（微弱）
            Divider()
                .color('#F0F2F5')
                .margin({ left: '16.00vp', right: '16.00vp', top: '10.00vp', bottom: '8.00vp' })

            // 按钮区
            Row() {
                Button('修改方案')
                    .height('34.00vp')
                    .width('50%')
                    .backgroundColor('#FFFFFF')
                    .border({ width: 1, color: '#E5E7EB', radius: 8 })
                    .fontColor('#2E6AE6')
                    .onClick(() => {
                        this.onModifyScheme(item);
                    })

                Button('结束用药')
                    .height('34.00vp')
                    .width('50%')
                    .backgroundColor('#FFFFFF')
                    .border({ width: 1, color: '#E5E7EB', radius: 8 })
                    .fontColor('#EF4444')
                    .onClick(async () => {
                        await this.onEndMedicine(item, onDeletedWrapper);
                    })
                    .margin({ left: '10.00vp' })
            }
            .width('100%')
            .padding({ left: '16.00vp', right: '16.00vp', bottom: '14.00vp' })
        }
    }

    @Builder
    navDestinationBuilder(name: string, param: Object) {
        if (name === 'PlanUpdatePage') {
            PlanUpdatePage()
        }
    }
}