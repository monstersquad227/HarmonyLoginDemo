import { httpClient } from "../common/HttpClient"

export interface CourseResponse {
    course_id: number,
    medicine_name: string
    medicine_image: string
    medicine_type: number
    medicine_timing: number
    course_start_time: string
    frequency: number,
    plan_times: string,
    type: string,
    status: number,
    amount: number
}

export interface CreateCourseRequest {
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

interface CreateCourseApiResponse {
    code: number;
    message: string;
    result: boolean;
}

export interface DeleteCourseRequest {
    user_id?: number,
    medicine_name: string
}

interface DeleteCourseApiResponse {
    code: number;
    message: string;
    result: boolean;
}

export interface PutCourseRequest {
    course_id: number;
    user_id: number; // 1
    medicine_name: string; // 厄贝沙坦氢氟噻嗪片
    medicine_type: number; // 0 外用； 1 内用
    medicine_timing: number; // 0 不限; 1 饭前用药; 2 饭后用药; 3 随餐用药; 4 睡前用药;
    course_start_time: string; // 开始日期  2025-05-27 19:00:00
    course_start_times: string[];
    amount: number; // 用药数量
    type: string; // 剂量单位
    plan_time: string;
    frequency: number
}

interface PutCourseApiResponse {
    code: number;
    message: string;
    result: boolean;
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
     * @param CreateCourseRequest
     * @returns Promise<CourseResponse>
     */
    async postCourse(data: CreateCourseRequest): Promise<void> {
        const res = await httpClient.post('/course', data);
        const createCourseApiResponse = res.result as CreateCourseApiResponse;
        if (createCourseApiResponse && createCourseApiResponse.code === 0 && createCourseApiResponse.result) {
            // 返回 API 响应中的 result
            return ;
        }
        throw new Error('添加用药方案失败: ' + (createCourseApiResponse?.message || 'Unknown error'));
    }

    /**
     * 删除方案列表
     * @param DeleteCourseRequest
     * @returns Promise<>
     */
    async deleteCourse(data: DeleteCourseRequest): Promise<void> {
        const res = await httpClient.delete('/course', data);
        const deleteCourseApiResponse = res.result as DeleteCourseApiResponse;
        if (deleteCourseApiResponse && deleteCourseApiResponse.code === 0 && deleteCourseApiResponse.result) {
            // 返回 API 响应中的 result
            return ;
        }
        throw new Error('删除方案列表失败: ' + (deleteCourseApiResponse?.message || 'Unknown error'));
    }

    /**
     * 修改方案列表
     * @param PutCourseRequest
     * @returns Promise<>
     */
    async putCourse(data: PutCourseRequest): Promise<void> {
        const res = await httpClient.put('/course', data);
        const putCourseApiResponse = res.result as PutCourseApiResponse;
        if (putCourseApiResponse && putCourseApiResponse.code === 0 && putCourseApiResponse.result) {
            // 返回 API 响应中的 result
            return ;
        }
        throw new Error('修改方案列表失败: ' + (putCourseApiResponse?.message || 'Unknown error'));
    }
}

export const courseApiService = CourseApiService.getInstance();