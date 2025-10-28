import { httpClient } from "../common/HttpClient";

// 用药记录数据
export interface RecordResponse {
    actual_time: string,
    contents: RecordResponseContents[]
}

export interface RecordResponseContents {
    id: number,
    medicine_name: string,
    memo?: string,
    status: number,
    is_checked: number,
}

// 打卡
export interface PutRecordRequest {
    id: number,
    actual_time: string,
    is_checked: number,
    plan_id: number,
}
interface PutRecordApiResponse {
    code: number;
    message: string;
    result: boolean;
}


// Api接口返回数据
interface ApiResponse {
    code: number;
    message: string;
    result: RecordResponse[];
}

export class RecordApiService {
    private static instance: RecordApiService;
    private  constructor() {};

    public static getInstance(): RecordApiService  {
        if (!RecordApiService.instance) {
            RecordApiService.instance = new RecordApiService();
        }
        return RecordApiService.instance;
    }

    /**
     * 获取方案记录列表
     * @param date 获取用药方案 格式: YYYY-MM-DD
     * @returns Promise<PlanResponse>
     */
    async getRecordList(): Promise<RecordResponse[]> {
        const userId = AppStorage.get<string>('login_user_id') || '';
        if (!userId) {
            console.error('User ID not found in AppStorage');
            throw new Error('用户未登录');
        }
        const res = await httpClient.get('/record/'+ userId);
        const apiResponse = res.result as ApiResponse;
        if (apiResponse && apiResponse.code === 0 && apiResponse.result) {
            // 返回 API 响应中的 result
            return apiResponse.result as RecordResponse[];
        }
        throw new Error('获取用药方案失败: ' + (apiResponse?.message || 'Unknown error'));
    }

    /**
     * 更新方案打卡
     * @param data
     * @returns Promise<bool>
     */
    async putRecordCheckIn(data: PutRecordRequest): Promise<boolean> {
        const userId = AppStorage.get<string>('login_user_id') || '';
        if (!userId) {
            console.error('User ID not found in AppStorage');
            throw new Error('用户未登录');
        }
        const res = await httpClient.put('/record/'+ userId, data);
        const apiResponse = res.result as PutRecordApiResponse;
        if (apiResponse && apiResponse.code === 0 && apiResponse.result) {
            // 返回 API 响应中的 result
            return apiResponse.result as boolean;
        }
        throw new Error('更新打卡失败: ' + (apiResponse?.message || 'Unknown error'));
    }

}

export const recordApiService = RecordApiService.getInstance();