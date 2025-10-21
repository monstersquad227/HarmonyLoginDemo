import { CreateLoginRequest, loginApiService } from "../api/LoginApiService";

export interface UserInfo {
    username: string;
    password: string;
    loginTime: number;
}

/**
 * API 服务类
 * 统一管理所有接口调用
 */
export class LoginManager {
    private static instance: LoginManager;
    private readonly LOGIN_TOKEN = 'login_token';
    private readonly LOGIN_USER_ID = 'login_user_id';
    private readonly LOGIN_HUAWEI_ID = 'login_huawei_id';
    private  readonly LOGIN_PHONE = 'login_phone';

    private readonly LOGIN_EXPIRY_DAYS = 20;
    private readonly USERNAME_KEY = 'login_username';
    private readonly PASSWORD_KEY = 'login_password';
    private readonly LOGIN_TIME_KEY = 'login_time';

    private constructor() {}

    public static getInstance(): LoginManager {
        if (!LoginManager.instance) {
            LoginManager.instance = new LoginManager();
        }
        return LoginManager.instance;
    }

    // 初始化PersistentStorage
    init(): void {
        try {
            // 初始化PersistentStorage的键值
            PersistentStorage.persistProp(this.LOGIN_TOKEN, '')
            PersistentStorage.persistProp(this.LOGIN_USER_ID, '')
            PersistentStorage.persistProp(this.LOGIN_HUAWEI_ID, '')
            PersistentStorage.persistProp(this.LOGIN_PHONE, '')

            PersistentStorage.persistProp(this.USERNAME_KEY, '');
            PersistentStorage.persistProp(this.PASSWORD_KEY, '');
            PersistentStorage.persistProp(this.LOGIN_TIME_KEY, 0);
        } catch (error) {
            console.error('Failed to initialize PersistentStorage:', error);
        }
    }

    // 用户登录
    async login(authorizationCode: string): Promise<boolean> {
        // console.info("authorizationCode: "+ authorizationCode)
        const postData: CreateLoginRequest = {
            authorization_code: authorizationCode
        }
        try {
            // console.info("Calling loginApiService.login...");
            const data = await loginApiService.login(postData);

            // console.info('Login API response:', JSON.stringify(data));
            if (data) {
                // 保存数据
                AppStorage.setOrCreate(this.LOGIN_TOKEN, data.token);
                AppStorage.setOrCreate(this.LOGIN_USER_ID, data.user.id.toString());
                AppStorage.setOrCreate(this.LOGIN_HUAWEI_ID, data.user.huawei_id)
                AppStorage.setOrCreate(this.LOGIN_PHONE, data.user.phone_num)

                AppStorage.setOrCreate(this.USERNAME_KEY, data.user.phone_num);
                AppStorage.setOrCreate(this.PASSWORD_KEY, data.user.id.toString());
                AppStorage.setOrCreate(this.LOGIN_TIME_KEY, Date.now());

                // console.info('Login data saved successfully');
                return true;
            } else {
                // console.error('Login response data invalid');
                return false;
            }
        } catch (error) {
            console.error('Login failed with error:', error);
            return false; // 确保返回 false 而不是抛出异常
        }
    }

    // 检查是否已登录且未过期
    isLoggedIn(): boolean {
        try {
            const userInfo = this.getUserInfo();
            if (!userInfo) {
                return false;
            }

            const currentTime = Date.now();
            const loginTime = userInfo.loginTime;
            const daysDiff = (currentTime - loginTime) / (1000 * 60 * 60 * 24);

            return daysDiff <= this.LOGIN_EXPIRY_DAYS;
        } catch (error) {
            console.error('Failed to check login status:', error);
            return false;
        }
    }

    // 获取用户信息
    getUserInfo(): UserInfo | null {
        try {
            const username = AppStorage.get<string>(this.USERNAME_KEY) || '';
            const password = AppStorage.get<string>(this.PASSWORD_KEY) || '';
            const loginTime = AppStorage.get<number>(this.LOGIN_TIME_KEY) || 0;

            if (username && password && loginTime) {
                return {
                    username: username,
                    password: password,
                    loginTime: loginTime
                };
            }
            return null;
        } catch (error) {
            console.error('Failed to get user info:', error);
            return null;
        }
    }

    // 登出
    logout(): void {
        try {
            // 清除登录信息
            AppStorage.setOrCreate(this.USERNAME_KEY, '');
            AppStorage.setOrCreate(this.PASSWORD_KEY, '');
            AppStorage.setOrCreate(this.LOGIN_TIME_KEY, 0);
        } catch (error) {
            console.error('Failed to logout:', error);
        }
    }

    // 获取剩余登录天数
    getRemainingDays(): number {
        try {
            const userInfo = this.getUserInfo();
            if (!userInfo) {
                return 0;
            }

            const currentTime = Date.now();
            const loginTime = userInfo.loginTime;
            const daysDiff = (currentTime - loginTime) / (1000 * 60 * 60 * 24);
            const remainingDays = this.LOGIN_EXPIRY_DAYS - daysDiff;

            return Math.max(0, Math.ceil(remainingDays));
        } catch (error) {
            console.error('Failed to get remaining days:', error);
            return 0;
        }
    }
}