import preferences from '@ohos.data.preferences';

export interface UserInfo {
  username: string;
  password: string;
  loginTime: number;
}

export class LoginManager {
  private static instance: LoginManager;
  private preferences: preferences.Preferences | null = null;
  private readonly LOGIN_EXPIRY_DAYS = 20;
  private readonly PREFERENCES_NAME = 'login_preferences';

  private constructor() {}

  public static getInstance(): LoginManager {
    if (!LoginManager.instance) {
      LoginManager.instance = new LoginManager();
    }
    return LoginManager.instance;
  }

  // 初始化preferences
  async init(context: Context): Promise<void> {
    try {
      this.preferences = await preferences.getPreferences(context, this.PREFERENCES_NAME);
    } catch (error) {
      console.error('Failed to initialize preferences:', error);
    }
  }

  // 用户登录
  async login(username: string, password: string): Promise<boolean> {
    // 这里可以添加实际的登录验证逻辑
    // 为了演示，我们假设用户名和密码都不为空就登录成功
    if (username && password) {
      const userInfo: UserInfo = {
        username: username,
        password: password,
        loginTime: Date.now()
      };
      
      await this.saveUserInfo(userInfo);
      return true;
    }
    return false;
  }

  // 检查是否已登录且未过期
  async isLoggedIn(): Promise<boolean> {
    try {
      const userInfo = await this.getUserInfo();
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
  async getUserInfo(): Promise<UserInfo | null> {
    try {
      if (!this.preferences) {
        return null;
      }

      const username = await this.preferences.get('username', '') as string;
      const password = await this.preferences.get('password', '') as string;
      const loginTime = await this.preferences.get('loginTime', 0) as number;

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

  // 保存用户信息
  private async saveUserInfo(userInfo: UserInfo): Promise<void> {
    try {
      if (!this.preferences) {
        return;
      }

      await this.preferences.put('username', userInfo.username);
      await this.preferences.put('password', userInfo.password);
      await this.preferences.put('loginTime', userInfo.loginTime);
      await this.preferences.flush();
    } catch (error) {
      console.error('Failed to save user info:', error);
    }
  }

  // 登出
  async logout(): Promise<void> {
    try {
      if (!this.preferences) {
        return;
      }

      await this.preferences.clear();
      await this.preferences.flush();
    } catch (error) {
      console.error('Failed to logout:', error);
    }
  }

  // 获取剩余登录天数
  async getRemainingDays(): Promise<number> {
    try {
      const userInfo = await this.getUserInfo();
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