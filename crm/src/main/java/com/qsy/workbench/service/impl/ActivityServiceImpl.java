package com.qsy.workbench.service.impl;

import com.qsy.workbench.dao.ActivityMapper;
import com.qsy.workbench.pojo.Activity;
import com.qsy.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * @author qsy
 * @create 2022/4/1 - 13:59
 */
@Service
public class ActivityServiceImpl implements ActivityService {
    @Autowired
    private ActivityMapper activityMapper;
    @Override
    public int addActivity(Activity activity) {
        return activityMapper.insertActivity(activity);
    }

    @Override
    public List<Activity> queryActivityByConditionForPage(Map<String, Object> map) {
        return activityMapper.selectActivityByConditionForPage(map);
    }

    @Override
    public int queryCountOfActivityByCondition(Map<String, Object> map) {
        return activityMapper.selectCountOfActivityByCondition(map);
    }

    @Override
    public int deleteActivityById(String[] ids) {
        return activityMapper.deleteActivityById(ids);
    }

    @Override
    public Activity queryActivityById(String id) {
        return activityMapper.selectActivityById(id);
    }

    @Override
    public int saveEditActivityById(Activity activity) {
        return  activityMapper.updateActivityById(activity);
    }

    @Override
    public List<Activity> queryAllActivity() {
        return activityMapper.selectAllActivity();
    }

    @Override
    public int addActivityByList(List<Activity> activityList) {
        return activityMapper.insertActivityByList(activityList);
    }

    @Override
    public Activity queryActivityForDetailById(String id) {
        return activityMapper.selectActivityForDetailById(id);
    }

    @Override
    public List<Activity> queryActivityForClueDetailByClueId(String clueId) {
        return activityMapper.selectActivityForClueDetailByClueId(clueId);
    }

    @Override
    public List<Activity> queryActivityForDetailByNameExpClueId(Map<String, Object> map) {
        return activityMapper.selectActivityForDetailByNameExpClueId(map);
    }

    @Override
    public List<Activity> queryActivityForBundByIds(String[] Ids) {
        return activityMapper.selectActivityForBundByIds(Ids);
    }

    @Override
    public List<Activity> queryActivityFroConvertByNameClueId(Map<String, Object> map) {
        return activityMapper.selectActivityFroConvertByNameClueId(map);
    }
}
