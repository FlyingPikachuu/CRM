package com.qsy.workbench.service;

import com.qsy.workbench.pojo.Activity;

import java.util.List;
import java.util.Map;

/**
 * @author qsy
 * @create 2022/4/1 - 13:59
 */
public interface ActivityService {
    int addActivity(Activity activity);
    List<Activity> queryActivityByConditionForPage(Map<String,Object> map);

    int queryCountOfActivityByCondition(Map<String,Object> map);

    int deleteActivityById(String[] ids);
    Activity queryActivityById(String id);

    int saveEditActivityById(Activity activity);

    List<Activity> queryAllActivity();

    int addActivityByList(List<Activity> activityList);

    Activity queryActivityForDetailById(String id);

    List<Activity> queryActivityForClueDetailByClueId(String clueId);

    List<Activity> queryActivityForDetailByNameExpClueId(Map<String,Object> map);

    List<Activity> queryActivityForBundByIds(String[] Ids);

    List<Activity> queryActivityForConvertByNameClueId(Map<String,Object> map);

    List<Activity> queryActivityForSaveTran(String name);
}
