import { CourseResponse, DeleteCourseRequest, PutCourseRequest } from "../api/CourseApiService";
import { courseManager } from "../manager/CourseManager";
import { PlanUpdatePage } from "./PlanUpdatePage";
import { promptAction } from "@kit.ArkUI";
import { PlanAddPage } from "./PlanAddPage";
import { emitter } from "@kit.BasicServicesKit";
import { VibrationUtil } from "../common/VibrationUtil";

@Entry
@Component
export struct PlanPage {
    @State courseData: CourseResponse[] = [];
    @State isRefreshing: boolean = false;
    @StorageLink('shouldRefreshCourse') @Watch('onShouldRefreshChanged') shouldRefreshCourse: boolean = false;
    @StorageLink('editingCourse') editingCourse: Object | null = null;
    private navPathStack: NavPathStack = new NavPathStack();
    private readonly REFRESH_PLAN_EVENT_ID = 2002;

    async aboutToAppear() {
        // 初始化时存储 navPathStack
        AppStorage.setOrCreate('planNavStack', this.navPathStack);
        // 订阅 Tab 切换刷新事件
        emitter.on({ eventId: this.REFRESH_PLAN_EVENT_ID }, async () => {
            console.info('PlanPage received refresh event from tab switch');
            await this.loadData();
        });
        await this.loadData();
    }

    aboutToDisappear() {
        // 取消订阅
        emitter.off(this.REFRESH_PLAN_EVENT_ID);
    }

    // 监听刷新标记变化
    async onShouldRefreshChanged() {
        console.info('shouldRefreshCourse changed to:', this.shouldRefreshCourse);
        if (this.shouldRefreshCourse) {
            await this.loadData();
            // 延迟重置，确保刷新完成
            setTimeout(() => {
                this.shouldRefreshCourse = false;
            }, 3000);
        }
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

    async handleRefresh() {
        this.isRefreshing = true;
        try {
            await this.loadData();
            // promptAction.showToast({
            //     message: '刷新成功',
            //     duration: 1500
            // });
        } finally {
            this.isRefreshing = false;
        }
    }

    // 文案转换
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
    // onModifyScheme(item: CourseResponse) {
    //     this.navPathStack.pushPath({ name: 'PlanUpdatePage' });
    // }

    // 结束用药（示例）
    async onEndMedicine(item: CourseResponse) {
        AlertDialog.show({
            message: '确定结束 ' + item.medicine_name + ' 用药吗？',
            buttons: [
                { value: '取消', action: () => { console.log('取消结束用药'); } },
                { value: '确定', fontColor: '#FF3B30', action: async () => {
                    try {
                        console.log('结束用药: ', item.course_id);
                        // 调用 API 删除/结束用药
                        const request: DeleteCourseRequest =  {
                            id: item.course_id,
                            status: 1
                        }
                        await courseManager.removeCourse(request)
                        // 刷新列表
                        await this.loadData();
                        // 提示成功
                        promptAction.showToast({
                            message: '已结束用药',
                            duration: 2000
                        });
                    } catch (error) {
                        console.error('结束用药失败:', error);
                        promptAction.showToast({
                            message: '操作失败，请重试',
                            duration: 2000
                        });
                    }
                }
                }
            ]
        });
    }

    // 新增：恢复方案
    async onRestoreCourse(item: CourseResponse) {
        AlertDialog.show({
            message: '确定恢复 ' + item.medicine_name + ' 用药方案吗？',
            buttons: [
                { value: '取消', action: () => { console.log('取消恢复方案'); } },
                { value: '确定', fontColor: $r('sys.color.brand'), action: async () => {
                    try {
                        console.log('恢复方案: ', item.course_id);
                        // TODO: 调用恢复方案的 API
                        // 示例：await courseManager.restoreCourse(item.course_id)

                        // 临时修改本地状态用于演示
                        // item.status = 0;

                        await this.loadData();
                        promptAction.showToast({
                            message: '方案已恢复',
                            duration: 2000
                        });
                    } catch (error) {
                        console.error('恢复方案失败:', error);
                        promptAction.showToast({
                            message: '操作失败，请重试',
                            duration: 2000
                        });
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
                    Refresh({ refreshing: this.isRefreshing}) {
                        List({ space: '14.00vp' }) {
                            ForEach(this.courseData, (item: CourseResponse) => {
                                ListItem() {
                                    this.PlanItem(item)
                                }
                                .width('92%')
                                .margin({ left: '4%', right: '4%' })
                                .backgroundColor($r('sys.color.comp_background_list_card'))
                                .borderRadius(12)
                                .shadow({ radius: 8, color: '#12000000', offsetX: 0, offsetY: 2 })
                            })
                        }
                        .margin({ top: '12.00vp' })
                    }
                    .layoutWeight(1)
                    .onRefreshing(async () => {
                        // 触发震动反馈
                        VibrationUtil.light()

                        await this.handleRefresh();
                    })
                } else {
                    Refresh({ refreshing: this.isRefreshing }) {
                        Column() {
                            Text('暂无用药方案')
                                .fontSize(16)
                                .fontColor('#999999')
                            Text('点击下方按钮添加')
                                .fontSize(14)
                                .fontColor('#CCCCCC')
                                .margin({ top: 8 })
                        }
                        .margin({ top: 40})
                        .justifyContent(FlexAlign.Center)
                    }
                    .layoutWeight(1)
                    .onRefreshing(async () => {
                        // 触发震动反馈
                        VibrationUtil.light()

                        await this.handleRefresh();
                    })
                }

                // 底部按钮
                Button('添加方案')
                    .width('92%')
                    .height(48)
                    .margin({ left: '4%', right: '4%', top: 12, bottom: 16 })
                    .backgroundColor($r('sys.color.brand'))
                    .fontColor($r('sys.color.comp_background_list_card'))
                    .fontSize(16)
                    .borderRadius(24)
                    .onClick(() => {
                        // TODO: 添加方案逻辑
                        console.log('添加方案');
                        // 触发震动反馈
                        VibrationUtil.light()

                        this.navPathStack.pushPath({ name: 'PlanAddPage' })
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
    PlanItem(item: CourseResponse) {
        Column() {
            // 置灰部分
            Column() {
                // 顶部标题与副标题
                Column() {
                    Row() {
                        Text(item.medicine_name)
                            .fontSize(18)
                            .fontWeight(FontWeight.Bold)
                            .fontColor(item.status === 1 ? '#999999' : '#111111')
                            .alignSelf(ItemAlign.Start)

                        // 不可用状态标签
                        if (item.status === 1) {
                            Text('已停用')
                                .fontSize(12)
                                .fontColor('#FF3B30')
                                .backgroundColor('#FFE5E5')
                                .borderRadius(4)
                                .padding({ left: 8, right: 8, top: 2, bottom: 2 })
                        }
                    }
                    .width('100%')

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
                        .fontColor(item.status === 1 ? '#999999' : $r('sys.color.brand'))
                        .backgroundColor(item.status === 1 ? '#F5F5F5' : '#E6F3FF')
                        .borderRadius(4)
                        .padding({ left: 8, right: 8, top: 4, bottom: 4 })

                    // 时机标签
                    Text(this.translateMedicineTime(item.medicine_timing?.toString()))
                        .fontSize(14)
                        .fontColor('#666666')
                        .backgroundColor('#F5F5F5')
                        .borderRadius(4)
                        .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                        .margin({ left: 8 })

                    Blank().layoutWeight(1)

                    // 类型标签右侧展示
                    Text(this.translateType(item.medicine_type.toString()))
                        .fontSize(14)
                        .fontColor(item.status === 1 ? '#999999' : '#34C759')
                        .backgroundColor(item.status === 1 ? '#F5F5F5' : '#E8F8ED')
                        .borderRadius(4)
                        .padding({ left: 8, right: 8, top: 4, bottom: 4 })
                }
                .width('100%')
                .padding({ left: 16, right: 16, top: 12 })
            }
            .width('100%')
            .opacity(item.status === 1 ? 0.5 : 1)

            // 分隔线
            Divider()
                .color('#F0F0F0')
                .margin({ left: 16, right: 16, top: 14, bottom: 12 })

            // 按钮区
            if (item.status === 0) {
                Row() {
                    Button('修改方案')
                        .height(38)
                        .layoutWeight(1)
                        .backgroundColor($r('sys.color.comp_background_list_card'))
                        .border({ width: 1, color: '#E0E0E0', radius: 8 })
                        .fontColor($r('sys.color.brand'))
                        .fontSize(15)
                        .onClick(() => {
                            // 触发震动反馈
                            VibrationUtil.medium()

                            // this.onModifyScheme(item);
                            this.navPathStack.pushPath({ name: 'PlanUpdatePage', param: {
                                course_id: item.course_id,
                                medicine_name: item.medicine_name,
                                medicine_type: item.medicine_type,
                                medicine_timing: item.medicine_timing,
                                course_start_time: item.course_start_time,
                                amount: item.amount,
                                type: item.type,
                                plan_time: item.plan_times.toString(),
                                frequency: item.frequency
                            } as PutCourseRequest });
                        })

                    Button('结束用药')
                        .height(38)
                        .layoutWeight(1)
                        .backgroundColor($r('sys.color.comp_background_list_card'))
                        .border({ width: 1, color: '#E0E0E0', radius: 8 })
                        .fontColor('#FF3B30')
                        .fontSize(15)
                        .onClick(async () => {
                            // 触发震动反馈
                            VibrationUtil.medium()

                            await this.onEndMedicine(item);
                        })
                        .margin({ left: 12 })
                }
                .width('100%')
                .padding({ left: 16, right: 16, bottom: 16 })
            } else {
                // 不可用状态：只显示恢复按钮
                Row() {
                    Button('恢复方案')
                        .height(38)
                        .width('100%')
                        .backgroundColor($r('sys.color.comp_background_list_card'))
                        .fontColor($r('sys.color.brand'))
                        .fontSize(15)
                        .border({ width: 1, color: '#E0E0E0', radius: 8 })
                        .onClick(async () => {
                            // 触发震动反馈
                            VibrationUtil.light()

                            await this.onRestoreCourse(item);
                        })
                }
                .width('100%')
                .padding({ left: 16, right: 16, bottom: 16 })
            }

        }
    }

    @Builder
    navDestinationBuilder(name: string) {
        if (name === 'PlanUpdatePage') {
            PlanUpdatePage()
        } else if (name === 'PlanAddPage') {
            PlanAddPage()
        }
    }
}