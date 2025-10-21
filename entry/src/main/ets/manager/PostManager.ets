// import { postApi, Post, User, CreatePostRequest } from '../api/PostApi';
//
// // 文章管理器
// export class PostManager {
//     private static instance: PostManager;
//
//     private constructor() {}
//
//     public static getInstance(): PostManager {
//         if (!PostManager.instance) {
//             PostManager.instance = new PostManager();
//         }
//         return PostManager.instance;
//     }
//
//     // 加载所有文章
//     async loadAllPosts(): Promise<boolean> {
//         try {
//             const response = await postApi.getAllPosts();
//
//             // if (response.success && response.data) {
//             if (response.data) {
//               // 将数据存储到AppStorage
//               AppStorage.setOrCreate('postList', response.data);
//               console.log('文章列表加载成功');
//               return true;
//             } else {
//               console.error('加载文章列表失败:', response.message);
//               AppStorage.setOrCreate('postList', []);
//               return false;
//             }
//         } catch (error) {
//             console.error('加载文章列表异常:', error);
//             AppStorage.setOrCreate('postList', []);
//             return false;
//         }
//     }
//
//     // 加载单个文章详情
//     async loadPostDetail(postId: number): Promise<boolean> {
//         try {
//             const response = await postApi.getPostById(postId);
//
//             // if (response.success && response.data) {
//             if (response.data) {
//                   AppStorage.setOrCreate('currentPost', response.data);
//                 console.log('文章详情加载成功');
//                 return true;
//             } else {
//                 console.error('加载文章详情失败:', response.message);
//                 AppStorage.setOrCreate('currentPost', null);
//                 return false;
//             }
//         } catch (error) {
//             console.error('加载文章详情异常:', error);
//             AppStorage.setOrCreate('currentPost', null);
//             return false;
//         }
//     }
//
//     // 创建新文章
//     async createNewPost(title: string, body: string, userId: number): Promise<boolean> {
//         try {
//             const postData: CreatePostRequest = {
//                 title: title,
//                 body: body,
//                 userId: userId
//             };
//
//             const response = await postApi.createPost(postData);
//
//             if (response.data) {
//                 console.log('文章创建成功');
//                 // 重新加载文章列表
//                 await this.loadAllPosts();
//                 return true;
//             } else {
//                 console.error('创建文章失败:', response.message);
//                 return false;
//             }
//         } catch (error) {
//             console.error('创建文章异常:', error);
//             return false;
//         }
//     }
//
//     // 加载所有用户
//     async loadAllUsers(): Promise<boolean> {
//         try {
//             const response = await postApi.getAllUsers();
//
//             // if (response.success && response.data) {
//             if (response.data) {
//                 AppStorage.setOrCreate('userList', response.data);
//                 console.log('用户列表加载成功');
//                 return true;
//             } else {
//                 console.error('加载用户列表失败:', response.message);
//                 AppStorage.setOrCreate('userList', []);
//                 return false;
//             }
//         } catch (error) {
//             console.error('加载用户列表异常:', error);
//             AppStorage.setOrCreate('userList', []);
//             return false;
//         }
//     }
//
//     // 设置加载状态
//     setLoading(isLoading: boolean): void {
//         AppStorage.setOrCreate('isLoading', isLoading);
//     }
//
//     // 设置错误信息
//     setError(errorMessage: string): void {
//         AppStorage.setOrCreate('errorMessage', errorMessage);
//     }
//
//     // 清除错误信息
//     clearError(): void {
//         AppStorage.setOrCreate('errorMessage', '');
//     }
// }
//
// // 导出单例实例
// export const postManager = PostManager.getInstance();