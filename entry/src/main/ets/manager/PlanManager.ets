import { planApiService, PlanApiService, PlanResponse } from "../api/PlanApiService";

export class PlanManager {
    private static instance: PlanManager;
    private constructor() {}

    public static getInstance(): PlanManager {
        if (!PlanManager.instance) {
            PlanManager.instance = new PlanManager();
        }
        return PlanManager.instance;
    }

    async getPlanList(date: string): Promise<PlanResponse[]> {
        try {
            return await planApiService.getPlanList(date)
        } catch (err) {
            console.error('加载方案列表失败:', err)
            return []
        }
    }
}

export const planManager = PlanManager.getInstance()