import { httpClient, HttpClientApiResponse } from '../common/HttpClient';

// 文章数据接口
export interface Post {
    id: number;
    title: string;
    body: string;
    userId: number;
}

// 用户数据接口
export interface User {
    id: number;
    name: string;
    username: string;
    email: string;
    phone: string;
}

// 创建文章请求接口
export interface CreatePostRequest {
    title: string;
    body: string;
    userId: number;
}

// 文章API类
export class PostApi {
    private static instance: PostApi;

    private constructor() {}

    public static getInstance(): PostApi {
        if (!PostApi.instance) {
            PostApi.instance = new PostApi();
        }
        return PostApi.instance;
    }

    // 获取所有文章
    async getAllPosts(): Promise<HttpClientApiResponse> {
        return httpClient.get('/posts');
    }

    // 获取单个文章
    async getPostById(id: number): Promise<HttpClientApiResponse> {
        return httpClient.get(`/posts/${id}`);
    }

    // 创建文章
    async createPost(postData: CreatePostRequest): Promise<HttpClientApiResponse> {
        return httpClient.post('/posts', postData);
    }

    // 获取所有用户
    async getAllUsers(): Promise<HttpClientApiResponse> {
        return httpClient.get('/users');
    }

    // 获取用户信息
    async getUserById(id: number): Promise<HttpClientApiResponse> {
        return httpClient.get(`/users/${id}`);
    }
}

// 导出单例实例
export const postApi = PostApi.getInstance();