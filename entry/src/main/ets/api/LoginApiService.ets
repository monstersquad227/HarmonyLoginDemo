import { httpClient } from '../common/HttpClient';

// 创建登陆请求接口
export interface CreateLoginRequest {
    authorization_code: string
}

// 后端返回的结构
interface ApiResponse {
    code: number;
    message: string;
    result: LoginResponse;
}
interface LoginResponse {
    token: string;
    user: LoginUserInfo;
}
// LoginUserInfo
interface LoginUserInfo {
    id: number;
    phone_num: string;
    huawei_id: string;
    password: string;
    created_at: string;
    updated_at: string
}

export class LoginApiService {
    private static instance: LoginApiService;

    private constructor() {}

    public static getInstance(): LoginApiService {
        if (!LoginApiService.instance) {
            LoginApiService.instance = new LoginApiService()
        }
        return LoginApiService.instance
    }

    /**
     * 用户登录
     * @param data 登录请求数据
     * @returns Promise<LoginResponse>
     */
    async login(data: CreateLoginRequest): Promise<LoginResponse> {
        const res = await httpClient.post('/user/loginV2', data);
        console.info('Login API raw response:', JSON.stringify(res));
        // HttpClient 的 result 里包含了实际的 API 响应
        const apiResponse = res.result as ApiResponse;
        if (apiResponse && apiResponse.code === 0 && apiResponse.result) {
            // 返回 API 响应中的 result
            return apiResponse.result as LoginResponse;
        }
        throw new Error('登录失败: ' + (apiResponse?.message || 'Unknown error'));
    }
}

// 导出单例实例
export const loginApiService = LoginApiService.getInstance();