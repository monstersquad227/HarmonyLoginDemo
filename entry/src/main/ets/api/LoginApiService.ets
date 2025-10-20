import { HttpClient, httpClient, HttpClientApiResponse } from '../common/HttpClient';

// 创建登陆请求接口
export interface CreateLoginRequest {
    authorization_code: string
}

//
export interface LoginResponse {

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
     * @param authorizationCode 华为授权码
     * @returns Promise<LoginResponse>
     */
    async login(data: CreateLoginRequest): Promise<HttpClientApiResponse> {
        return httpClient.post('/user/loginV2', data)
    }

}

// 导出单例实例
export const loginApiService = LoginApiService.getInstance();