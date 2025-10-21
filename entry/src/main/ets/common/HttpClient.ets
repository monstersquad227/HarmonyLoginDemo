import http from '@ohos.net.http';
import { loginApiService } from '../api/LoginApiService';
import { LoginManager } from '../manager/LoginManager';

// 简单的HTTP响应接口
export interface HttpClientApiResponse {
    code: number;
    message: string;
    result: Object | null;
}

// 简单的HTTP客户端
export class HttpClient {
    private static instance: HttpClient;
    private baseURL: string = 'http://api.monstersquad.cn:15080/medicine';
    // private loginManager: LoginManager = LoginManager.getInstance();

    private constructor() {}

    public static getInstance(): HttpClient {
        if (!HttpClient.instance) {
            HttpClient.instance = new HttpClient();
        }
        return HttpClient.instance;
    }

    // 添加一个私有方法获取 LoginManager
    private getLoginManager(): LoginManager {
        return LoginManager.getInstance();
    }

    // 设置基础URL
    setBaseURL(url: string): void {
        this.baseURL = url;
    }

  // GET请求
    async get(url: string): Promise<HttpClientApiResponse> {
        const httpRequest = http.createHttp();
        const token = this.getLoginManager().getterToken();
        console.log(`[HTTP] Using Token: ${token}`);

        try {
            const fullUrl = url.startsWith('http') ? url : `${this.baseURL}${url}`;
      
            console.log(`[HTTP GET] ${fullUrl}`);
      
            const response = await httpRequest.request(fullUrl, {
                method: http.RequestMethod.GET,
                header: {
                    'Content-Type': 'application/json',
                    'token': this.getLoginManager().getterToken()
                },
                connectTimeout: 10000,
                readTimeout: 10000
            });

            console.log(`[HTTP] Response Status: ${response.responseCode}`);
            console.log(`[HTTP] Response Data:`, response.result);

            return this.handleResponse(response);
      
        } catch (error) {
            console.error('[HTTP] GET request failed:', error);
            return this.handleError(error);
        } finally {
            httpRequest.destroy();
        }
    }

    // POST请求
    async post(url: string, data: Object): Promise<HttpClientApiResponse> {
        const httpRequest = http.createHttp();
    
        try {
            const fullUrl = url.startsWith('http') ? url : `${this.baseURL}${url}`;
      
            console.log(`[HTTP POST] ${fullUrl}`);
            console.log(`[HTTP] Data:`, data);
      
            const response = await httpRequest.request(fullUrl, {
                method: http.RequestMethod.POST,
                header: {
                    'Content-Type': 'application/json',
                    'token': this.getLoginManager().getterToken()
                },
                extraData: JSON.stringify(data),
                connectTimeout: 10000,
                readTimeout: 10000
            });

            console.log(`[HTTP] Response Status: ${response.responseCode}`);
            console.log(`[HTTP] Response Data:`, response.result);

            return this.handleResponse(response);
      
        } catch (error) {
            console.error('[HTTP] POST request failed:', error);
            return this.handleError(error);
        } finally {
            httpRequest.destroy();
        }
    }

  // 处理响应
    private handleResponse(response: http.HttpResponse): HttpClientApiResponse {
        // const { responseCode, result } = response;
        const result = response.result
        const responseCode = response.responseCode
    
        let data: Object | null = null;
        try {
            if (typeof result === 'string') {
                data = JSON.parse(result);
            } else {
                data = result as Object;
            }
        } catch {
            data = result as Object;
        }

        const success = responseCode >= 200 && responseCode < 300;

        return {
            code: responseCode,
            message: success ? 'Success' : 'Request failed',
            result: success ? data : null,
            // success
        };
    }

    // 处理错误
    private handleError(error: Object): HttpClientApiResponse {
        return {
            code: -1,
            message: 'Network error',
            result: null,
            // success: false
        };
    }
}

// 导出单例实例
export const httpClient = HttpClient.getInstance();