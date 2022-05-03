package com.qsy.workbench.dao;

import com.qsy.workbench.pojo.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityMapper {
    int deleteByPrimaryKey(String id);

    int insertSelective(Activity row);

    Activity selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Activity row);

    int updateByPrimaryKey(Activity row);

    int insertActivity(Activity activity);

    List<Activity> selectActivityByConditionForPage(Map<String, Object> map);

    int selectCountOfActivityByCondition(Map<String, Object> map);

    //根据ids批量删除记录
    int deleteActivityById(String[] ids);

    //根据id 查询活动信息显示到修改模态窗口
    Activity selectActivityById(String id);

    int updateActivityById(Activity activity);

    List<Activity> selectAllActivity();

    int insertActivityByList(List<Activity> activityList);

    //根据活动id查询活动明细
    Activity selectActivityForDetailById(String id);

    //根据clueId查询活动信息
    List<Activity> selectActivityForClueDetailByClueId(String clueId);

    //根据活动姓名模糊查询活动信息，除了已关联线索的活动
    List<Activity> selectActivityForDetailByNameExpClueId(Map<String, Object> map);

    //根据用户所选择关联的市场活动的Id查询市场活动，将新添加的关联活动追加在已关联活动列表
    List<Activity> selectActivityForBundByIds(String[] Ids);

    //根据活动名称模糊查询与指定线索已关联的活动信息
    List<Activity> selectActivityForConvertByNameClueId(Map<String, Object> map);

    //查询所有活动信息
    List<Activity> selectActivityForSaveTran(String name);
}