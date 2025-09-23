import http from '@ohos.net.http';

// 简单的HTTP响应接口
export interface SimpleApiResponse {
  code: number;
  message: string;
  data: Object | null;
  success: boolean;
}

// 简单的HTTP客户端
export class SimpleHttpClient {
  private static instance: SimpleHttpClient;
  private baseURL: string = 'https://jsonplaceholder.typicode.com';

  private constructor() {}

  public static getInstance(): SimpleHttpClient {
    if (!SimpleHttpClient.instance) {
      SimpleHttpClient.instance = new SimpleHttpClient();
    }
    return SimpleHttpClient.instance;
  }

  // 设置基础URL
  setBaseURL(url: string): void {
    this.baseURL = url;
  }

  // GET请求
  async get(url: string): Promise<SimpleApiResponse> {
    const httpRequest = http.createHttp();
    
    try {
      const fullUrl = url.startsWith('http') ? url : `${this.baseURL}${url}`;
      
      console.log(`[HTTP GET] ${fullUrl}`);
      
      const response = await httpRequest.request(fullUrl, {
        method: http.RequestMethod.GET,
        header: {
          'Content-Type': 'application/json'
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
  async post(url: string, data: Object): Promise<SimpleApiResponse> {
    const httpRequest = http.createHttp();
    
    try {
      const fullUrl = url.startsWith('http') ? url : `${this.baseURL}${url}`;
      
      console.log(`[HTTP POST] ${fullUrl}`);
      console.log(`[HTTP] Data:`, data);
      
      const response = await httpRequest.request(fullUrl, {
        method: http.RequestMethod.POST,
        header: {
          'Content-Type': 'application/json'
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
  private handleResponse(response: http.HttpResponse): SimpleApiResponse {
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
      data: success ? data : null,
      success
    };
  }

  // 处理错误
  private handleError(error: Object): SimpleApiResponse {
    return {
      code: -1,
      message: 'Network error',
      data: null,
      success: false
    };
  }
}

// 导出单例实例
export const simpleHttpClient = SimpleHttpClient.getInstance();