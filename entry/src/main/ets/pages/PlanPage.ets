import { CourseResponse } from "../api/CourseApiService";
import { courseManager } from "../manager/CourseManager";
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
    @State courseData: CourseResponse[] = [];
    // @State courseData: ListCourseData[] = [
    //     {
    //         course_id: 1001,
    //         medicine_name: '板蓝根',
    //         frequency: 2,
    //         medicine_timing: '不限',
    //         medicine_type: '内服',
    //         course_start_time: '2025-06-29',
    //         plan_times: 0,
    //         type: 'default',
    //         amount: '每次2片'
    //     },
    //     {
    //         course_id: 1002,
    //         medicine_name: '阿莫西林胶囊',
    //         frequency: 3,
    //         medicine_timing: '饭后',
    //         medicine_type: '内服',
    //         course_start_time: '2025-06-25',
    //         plan_times: 0,
    //         type: 'default',
    //         amount: '每次1粒'
    //     },
    //     {
    //         course_id: 1003,
    //         medicine_name: '维生素C',
    //         frequency: 1,
    //         medicine_timing: '不限',
    //         medicine_type: '内服',
    //         course_start_time: '2025-06-20',
    //         plan_times: 0,
    //         type: 'default',
    //         amount: '每次2片'
    //     }
    // ];
    @StorageLink('editingCourse') editingCourse: Object | null = null;
    private navPathStack: NavPathStack = new NavPathStack();


    async aboutToAppear() {
        await this.loadData();
    }

    async loadData() {
        try {
            this.courseData = await courseManager.getCourseList();
            console.info('Plan data loaded:', this.courseData.length);
        } catch (error) {
            console.error('Failed to load course data:', error);
            this.courseData = [];
        }
    }
    // 刷新数据（示例）
    async refreshCourseData() {
        console.log('refreshCourseData called');
    }

    // 文案转换（可按业务调整）
    translateMedicineTime(value: string): string {
        switch (value) {
            case '1':
                return '饭前用药';
            case '2':
                return '饭后用药';
            case '3':
                return '随餐用药';
            case '4':
                return '睡前用药';
            default:
                return '不限';
        }
    }

    translateType(value: string): string {
        switch (value) {
            case '1':
                return '外服';
            default:
                return '内服';
        }
    }

    splitDate(dateStr: string): string {
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
            Column() {
                // 列表区域
                if (this.courseData.length > 0) {
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
                    .layoutWeight(1)
                    .margin({ top: '12.00vp' })
                } else {
                    Column() {
                        Text('暂无用药方案')
                            .fontSize(16)
                            .fontColor('#999999')
                        Text('点击下方按钮添加')
                            .fontSize(14)
                            .fontColor('#CCCCCC')
                            .margin({ top: 8 })
                    }
                    .layoutWeight(1)
                    .justifyContent(FlexAlign.Center)
                }

                // 底部按钮
                Button('添加方案')
                    .width('92%')
                    .height(48)
                    .margin({ left: '4%', right: '4%', top: 12, bottom: 16 })
                    .backgroundColor('#007DFF')
                    .fontColor('#FFFFFF')
                    .fontSize(16)
                    .borderRadius(24)
                    .onClick(() => {
                        // TODO: 添加方案逻辑
                        console.log('添加方案');
                    })
            }
            .width('100%')
            .height('100%')
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
                    .fontSize(18)
                    .fontWeight(FontWeight.Bold)
                    .fontColor('#111111')
                    .alignSelf(ItemAlign.Start)

                Text(this.splitDate(item.course_start_time) + ' 开始')
                    .fontSize(14)
                    .fontColor('#999999')
                    .alignSelf(ItemAlign.Start)
                    .margin({ top: 6 })
            }
            .width('100%')
            .padding({ top: 16, left: 16, right: 16 })

            // 信息标签区
            Row() {
                // 次数标签
                Text('每日 ' + item.frequency + ' 次')
                    .fontSize(14)
                    .fontColor('#007DFF')
                    .backgroundColor('#E6F3FF')
                    .borderRadius(4)
                    .padding({ left: 8, right: 8, top: 4, bottom: 4 })

                // 时机标签
                Text(this.translateMedicineTime(item.medicine_timing))
                    .fontSize(14)
                    .fontColor('#666666')
                    .backgroundColor('#F5F5F5')
                    .borderRadius(4)
                    .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                    .margin({ left: 8 })

                Blank().layoutWeight(1)

                // 类型标签右侧展示
                Text(this.translateType(item.medicine_type))
                    .fontSize(14)
                    .fontColor('#34C759')
                    .backgroundColor('#E8F8ED')
                    .borderRadius(4)
                    .padding({ left: 8, right: 8, top: 4, bottom: 4 })
            }
            .width('100%')
            .padding({ left: 16, right: 16, top: 12 })

            // 分隔线
            Divider()
                .color('#F0F0F0')
                .margin({ left: 16, right: 16, top: 14, bottom: 12 })

            // 按钮区
            Row() {
                Button('修改方案')
                    .height(38)
                    .layoutWeight(1)
                    .backgroundColor('#FFFFFF')
                    .border({ width: 1, color: '#E0E0E0', radius: 8 })
                    .fontColor('#007DFF')
                    .fontSize(15)
                    .onClick(() => {
                        this.onModifyScheme(item);
                    })

                Button('结束用药')
                    .height(38)
                    .layoutWeight(1)
                    .backgroundColor('#FFFFFF')
                    .border({ width: 1, color: '#E0E0E0', radius: 8 })
                    .fontColor('#FF3B30')
                    .fontSize(15)
                    .onClick(async () => {
                        await this.onEndMedicine(item, onDeletedWrapper);
                    })
                    .margin({ left: 12 })
            }
            .width('100%')
            .padding({ left: 16, right: 16, bottom: 16 })
        }
    }

    @Builder
    navDestinationBuilder(name: string, param: Object) {
        if (name === 'PlanUpdatePage') {
            PlanUpdatePage()
        }
    }
}