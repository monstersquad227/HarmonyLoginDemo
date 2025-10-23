import { httpClient } from "../common/HttpClient"

export interface CourseResponse {
    course_id: number,
    medicine_name: string
    medicine_image: string
    medicine_type: number
    medicine_timing?: number
    course_start_time: string
    frequency: number,
    plan_times: string,
    type: string,
    amount: number
}

interface CreateCourseRequest {
    user_id: number; // 1
    medicine_name: string; // 厄贝沙坦氢氟噻嗪片
    medicine_image: string; // ''
    medicine_type: number; // 0 外用； 1 内用
    medicine_timing: number; // 0 不限; 1 饭前用药; 2 饭后用药; 3 随餐用药; 4 睡前用药;
    course_start_time: string; // 开始日期  2025-05-27 19:00:00
    course_start_times: string[];
    status: number; //方案状态 0 生效， 废弃； 创建时激活
    amount: number; // 用药数量
    type: string; // 剂量单位
    plan_time: string;
    frequency: number
}

// Api接口返回数据
interface ApiResponse {
    code: number;
    message: string;
    result: CourseResponse[];
}
export class CourseApiService {
    private static instance: CourseApiService;
    private constructor() {};

    public static getInstance(): CourseApiService {
        if (!CourseApiService.instance) {
            CourseApiService.instance = new CourseApiService();
        }
        return CourseApiService.instance;
    }

    /**
     * 获取方案列表
     * @param nil
     * @returns Promise<CourseResponse>
     */
    async getCourseList(): Promise<CourseResponse[]> {
        const res = await httpClient.get('/course');
        const apiResponse = res.result as ApiResponse;
        if (apiResponse && apiResponse.code === 0 && apiResponse.result) {
            // 返回 API 响应中的 result
            return apiResponse.result as CourseResponse[];
        }
        throw new Error('获取用药方案失败: ' + (apiResponse?.message || 'Unknown error'));
    }

    /**
     * 添加方案列表
     * @param CourseResponse
     * @returns Promise<CourseResponse>
     */
}

export const courseApiService = CourseApiService.getInstance();