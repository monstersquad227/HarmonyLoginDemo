export interface UserInfo {
  username: string;
  password: string;
  loginTime: number;
}

export class LoginManager {
  private static instance: LoginManager;
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
      PersistentStorage.persistProp(this.USERNAME_KEY, '');
      PersistentStorage.persistProp(this.PASSWORD_KEY, '');
      PersistentStorage.persistProp(this.LOGIN_TIME_KEY, 0);
    } catch (error) {
      console.error('Failed to initialize PersistentStorage:', error);
    }
  }

  // 用户登录
  login(username: string, password: string, authorization_code: string): boolean {
    // 这里可以添加实际的登录验证逻辑
    // 为了演示，我们假设用户名和密码都不为空就登录成功
    if (username && password) {
      const loginTime = Date.now();

      // 使用PersistentStorage保存登录信息
      AppStorage.setOrCreate(this.USERNAME_KEY, username);
      AppStorage.setOrCreate(this.PASSWORD_KEY, password);
      AppStorage.setOrCreate(this.LOGIN_TIME_KEY, loginTime);

      return true;
    }
    return false;
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