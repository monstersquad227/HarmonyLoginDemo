import { courseApiService, CourseResponse } from "../api/CourseApiService";


export class CourseManager {
    private static instance: CourseManager;
    private constructor() {};

    public static getInstance(): CourseManager {
        if (!CourseManager.instance) {
            CourseManager.instance = new CourseManager();
        }
        return CourseManager.instance;
    }

    async getCourseList(): Promise<CourseResponse[]> {
        try {
            return await courseApiService.getCourseList()
        } catch (err) {
            console.error('加载方案列表失败:', err)
            return []
        }
    }
}

export const courseManager = CourseManager.getInstance();