package com.qsy.workbench.service;

import com.qsy.workbench.pojo.ActivityRemark;

import java.util.List;

/**
 * @author qsy
 * @create 2022/4/5 - 9:00
 */
public interface ActivityRemarkService {
    List<ActivityRemark> queryActivityRemarkForDetailByActivityId(String id);

    int addActivityRemark(ActivityRemark activityRemark);

    int deleteActivityRemarkById(String id);

    int editActivityRemark(ActivityRemark activityRemark);



}
