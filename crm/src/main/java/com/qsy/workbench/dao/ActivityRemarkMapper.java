package com.qsy.workbench.dao;

import com.qsy.workbench.pojo.ActivityRemark;

import java.util.List;

public interface ActivityRemarkMapper {
    int deleteByPrimaryKey(String id);



    int insertSelective(ActivityRemark row);

    ActivityRemark selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(ActivityRemark row);

    int updateByPrimaryKey(ActivityRemark row);

    //查询所有备注
    List<ActivityRemark> selectActivityRemarkForDetailByActivityId(String id);

    //添加一条备注
    int insertActivityRemark(ActivityRemark activityRemark);

    //删除一条备注
    int deleteActivityRemarkById(String id);

    //修改一条备注
    int updateActivityRemark(ActivityRemark activityRemark);
}