package com.qsy.workbench.service;

import com.qsy.workbench.pojo.Activity;
import com.qsy.workbench.pojo.FunnelVO;
import com.qsy.workbench.pojo.LBVO;
import com.qsy.workbench.pojo.PieVO;

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

    //根据contactId查询与联系人已关联的市场活动
    List<Activity> queryActivityForContactDetailByContactId(String contactId);

    //根据活动姓名模糊查询活动信息，除了已关联线索的活动
    List<Activity> queryActivityForDetailByNameExpContactId(Map<String, Object> map);

    List<LBVO> queryActivityGroupByOwner(Map<String,Object> nap);

    //2022各月份创建市场活动数量统计
    List<LBVO> queryCountOfActivityByCreateMonth();
    //根据所有人分组查询市场活动正在进行的数量
    List<LBVO> queryCountOfActivityInProgressGroupByOwner();
    List<LBVO> queryCountOfActivityByOwnerAndCreate();
    List<Integer> queryMaxOfCreateActivityInAYear();


    //查询市场活动关联线索率
    PieVO queryCountOfRelationActivity(Map<String,Object> map);

    int queryCountOfNewActivity(Map<String,Object> map);
    List<Activity> queryActivityByIds(String[] ids);
}
