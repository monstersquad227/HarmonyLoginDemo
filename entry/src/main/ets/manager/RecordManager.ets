import { PutRecordRequest, recordApiService, RecordResponse } from "../api/RecordApiService";

export class RecordManager {
    private static instance: RecordManager;
    private constructor() {}

    public static getInstance(): RecordManager {
        if (!RecordManager.instance) {
            RecordManager.instance = new RecordManager();
        }
        return RecordManager.instance;
    }

     async getRecordList(): Promise<RecordResponse[]> {
        try {
            return await recordApiService.getRecordList()
        } catch (err) {
            console.error('加载记录列表失败:', err)
            return []
        }
    }

    async updateRecordCheckIn(data: PutRecordRequest): Promise<boolean> {
        try {
            return await recordApiService.putRecordCheckIn(data);
        } catch (err) {
            console.error('更新打卡失败:', err);
            return false;
        }
    }
}

export const recordManager = RecordManager.getInstance()