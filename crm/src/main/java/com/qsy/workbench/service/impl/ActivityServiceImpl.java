package com.qsy.workbench.service.impl;

import com.qsy.workbench.dao.ActivityMapper;
import com.qsy.workbench.pojo.Activity;
import com.qsy.workbench.pojo.FunnelVO;
import com.qsy.workbench.pojo.LBVO;
import com.qsy.workbench.pojo.PieVO;
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
    public List<Activity> queryActivityForConvertByNameClueId(Map<String, Object> map) {
        return activityMapper.selectActivityForConvertByNameClueId(map);
    }

    @Override
    public List<Activity> queryActivityForSaveTran(String name) {
        return activityMapper.selectActivityForSaveTran(name);
    }

    @Override
    public List<Activity> queryActivityForContactDetailByContactId(String contactId) {
        return activityMapper.selectActivityForContactDetailByContactId(contactId);
    }

    @Override
    public List<Activity> queryActivityForDetailByNameExpContactId(Map<String, Object> map) {
        return activityMapper.selectActivityForDetailByNameExpContactId(map);
    }

    @Override
    public List<LBVO> queryActivityGroupByOwner(Map<String, Object> map) {
        return activityMapper.selectActivityGroupByOwner(map);
    }

    @Override
    public List<LBVO> queryCountOfActivityByCreateMonth() {
        return activityMapper.selectCountOfActivityByCreateMonth();
    }

    @Override
    public List<LBVO> queryCountOfActivityInProgressGroupByOwner() {
        return activityMapper.selectCountOfActivityInProgressGroupByOwner();
    }

    @Override
    public List<LBVO> queryCountOfActivityByOwnerAndCreate() {
        return activityMapper.selectCountOfActivityByOwnerAndCreate();
    }

    @Override
    public List<Integer> queryMaxOfCreateActivityInAYear() {
        return activityMapper.selectMaxOfCreateActivityInAYear();
    }

    @Override
    public PieVO queryCountOfRelationActivity(Map<String,Object> map) {
        return activityMapper.selectCountOfRelationActivity(map);
    }

    @Override
    public int queryCountOfNewActivity(Map<String, Object> map) {
        return activityMapper.selectCountOfNewActivity(map);
    }

    @Override
    public List<Activity> queryActivityByIds(String[] ids) {
        return activityMapper.selectActivityByIds(ids);
    }
}
