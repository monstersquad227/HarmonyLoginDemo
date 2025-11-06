import { vibrator } from "@kit.SensorServiceKit";

/**
 * 震动工具类
 */
export class VibrationUtil {
    /**
     * 轻微震动 - 用于按钮点击、Tab切换等
     */
    static light() {
        VibrationUtil.vibrate(10, 'touch');
    }

    /**
     * 中等震动 - 用于通知提醒
     */
    static medium() {
        VibrationUtil.vibrate(30, 'notification');
    }

    /**
     * 强烈震动 - 用于警告、重要提醒
     */
    static strong() {
        VibrationUtil.vibrate(50, 'alarm');
    }

    /**
     * 执行震动
     */
    private static vibrate(duration: number, usage: vibrator.Usage) {
        try {
            vibrator.startVibration({
                type: 'time',
                duration: duration
            }, {
                id: 0,
                usage: usage
            });
        } catch (err) {
            console.error('Vibration failed:', JSON.stringify(err));
        }
    }
}