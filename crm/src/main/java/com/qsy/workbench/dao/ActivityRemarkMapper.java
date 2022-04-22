package com.qsy.workbench.dao;

import com.qsy.workbench.pojo.ActivityRemark;

import java.util.List;

public interface ActivityRemarkMapper {
    int deleteByPrimaryKey(String id);



    int insertSelective(ActivityRemark row);

    ActivityRemark selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(ActivityRemark row);

    int updateByPrimaryKey(ActivityRemark row);

    List<ActivityRemark> selectActivityRemarkForDetailByActivityId(String id);

    int insertActivityRemark(ActivityRemark activityRemark);

    int deleteActivityRemarkById(String id);

    //修改市场活动备注
    int updateActivityRemark(ActivityRemark activityRemark);
}