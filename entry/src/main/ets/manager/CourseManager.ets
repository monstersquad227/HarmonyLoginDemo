import { courseApiService, CourseResponse, CreateCourseRequest,
    DeleteCourseRequest,
    PutCourseRequest,
    RestoreCourseRequest} from "../api/CourseApiService";


export class CourseManager {
    private static instance: CourseManager;
    private constructor() {};

    public static getInstance(): CourseManager {
        if (!CourseManager.instance) {
            CourseManager.instance = new CourseManager();
        }
        return CourseManager.instance;
    }

    /**
     * 获取方案列表
     */
    async getCourseList(): Promise<CourseResponse[]> {
        try {
            return await courseApiService.getCourseList()
        } catch (err) {
            console.error('方案加载失败:', err)
            return []
        }
    }

    /**
     * 创建方案
     */
    async createCourse(data: CreateCourseRequest): Promise<void> {
        try {
            return await courseApiService.postCourse(data);
        } catch (err) {
            console.error('方案添加失败', err);
            return;
        }
    }

    /**
     * 更新方案
     */
    async updateCourse(data: PutCourseRequest): Promise<void> {
        try {
            return await courseApiService.putCourse(data);
        } catch (err) {
            console.error('方案修改失败', err);
            return;
        }
    }

    /**
     * 删除方案
     */
    async removeCourse(data: DeleteCourseRequest): Promise<void> {
        try {
            return await courseApiService.deleteCourse(data);
        } catch (err) {
            console.error('方案删除失败', err);
            return;
        }
    }

    /**
     * 删除方案
     */
    async restoreCourse(data: RestoreCourseRequest): Promise<void> {
        try {
            return await courseApiService.postRestoreCourse(data)
        } catch (err) {
            console.error('方案恢复失败', err);
            return;
        }
    }
}

export const courseManager = CourseManager.getInstance();