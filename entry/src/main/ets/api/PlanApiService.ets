import { httpClient } from "../common/HttpClient"

// 用药方案数据
export interface PlanResponse {
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

// Api接口返回数据
interface ApiResponse {
    code: number;
    message: string;
    result: PlanResponse[];
}


export class PlanApiService {
    private static instance: PlanApiService;
    private constructor() {};

    public static getInstance(): PlanApiService {
        if (!PlanApiService.instance) {
            PlanApiService.instance = new PlanApiService;
        }
        return PlanApiService.instance;
    };

    /**
     * 获取方案列表
     * @param date 获取用药方案 格式: YYYY-MM-DD
     * @returns Promise<PlanResponse>
     */
    async getPlanList(date: string): Promise<PlanResponse[]> {
        // 修复: 使用正确的 key 获取 user_id
        const userId = AppStorage.get<string>('login_user_id') || '';

        if (!userId) {
            console.error('User ID not found in AppStorage');
            throw new Error('用户未登录');
        }
        const res = await httpClient.get('/plan/'+ userId +'?date='+date);
        console.info('Plan API raw response:', JSON.stringify(res));
        const apiResponse = res.result as ApiResponse;
        if (apiResponse && apiResponse.code === 0 && apiResponse.result) {
            // 返回 API 响应中的 result
            return apiResponse.result as PlanResponse[];
        }
        throw new Error('获取用药方案失败: ' + (apiResponse?.message || 'Unknown error'));
    }
}

// 导出单例实例
export const planApiService = PlanApiService.getInstance();