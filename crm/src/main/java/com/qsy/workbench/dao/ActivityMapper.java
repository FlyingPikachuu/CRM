package com.qsy.workbench.dao;

import com.qsy.workbench.pojo.Activity;
import com.qsy.workbench.pojo.FunnelVO;
import com.qsy.workbench.pojo.LBVO;
import com.qsy.workbench.pojo.PieVO;
import org.apache.ibatis.annotations.Select;

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

    //根据clueId查询已关联活动信息
    List<Activity> selectActivityForClueDetailByClueId(String clueId);

    //根据活动姓名模糊查询活动信息，除了已关联线索的活动
    List<Activity> selectActivityForDetailByNameExpClueId(Map<String, Object> map);

    //根据用户所选择关联的市场活动的Id查询市场活动，将新添加的关联活动追加在已关联活动列表
    List<Activity> selectActivityForBundByIds(String[] Ids);

    //根据活动名称模糊查询与指定线索已关联的活动信息
    List<Activity> selectActivityForConvertByNameClueId(Map<String, Object> map);

    //查询所有活动信息
    List<Activity> selectActivityForSaveTran(String name);

    //根据contactId查询与联系人已关联的市场活动
    List<Activity> selectActivityForContactDetailByContactId(String contactId);

    //根据活动姓名模糊查询活动信息，除了已关联线索的活动
    List<Activity> selectActivityForDetailByNameExpContactId(Map<String, Object> map);

    //根据所有人分组查询市场活动在指定时间段内的数量
    List<LBVO> selectActivityGroupByOwner(Map<String,Object> map);


    //根据所有人分组查询市场活动正在进行的数量
    List<LBVO> selectCountOfActivityInProgressGroupByOwner();
    //查询当月创建市场活动top10
    List<LBVO> selectCountOfActivityByOwnerAndCreate();
    //2022各月份创建市场活动数量统计
    List<LBVO> selectCountOfActivityByCreateMonth();
    List<Integer> selectMaxOfCreateActivityInAYear();


    //查询市场活动关联线索率
    PieVO selectCountOfRelationActivity(Map<String,Object> map);

    //查询指定日期内创建市场活动数量
    int selectCountOfNewActivity(Map<String,Object> map);

    //根据Id查询用户信息
    List<Activity> selectActivityByIds(String[] ids);
}