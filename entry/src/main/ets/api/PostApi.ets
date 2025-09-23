import { simpleHttpClient, SimpleApiResponse } from '../common/SimpleHttpClient';

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
  async getAllPosts(): Promise<SimpleApiResponse> {
    return simpleHttpClient.get('/posts');
  }

  // 获取单个文章
  async getPostById(id: number): Promise<SimpleApiResponse> {
    return simpleHttpClient.get(`/posts/${id}`);
  }

  // 创建文章
  async createPost(postData: CreatePostRequest): Promise<SimpleApiResponse> {
    return simpleHttpClient.post('/posts', postData);
  }

  // 获取所有用户
  async getAllUsers(): Promise<SimpleApiResponse> {
    return simpleHttpClient.get('/users');
  }

  // 获取用户信息
  async getUserById(id: number): Promise<SimpleApiResponse> {
    return simpleHttpClient.get(`/users/${id}`);
  }
}

// 导出单例实例
export const postApi = PostApi.getInstance();