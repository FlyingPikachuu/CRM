package com.qsy.settings.dao;

import com.qsy.settings.pojo.User;

import java.util.List;
import java.util.Map;

public interface UserMapper {
    int deleteByPrimaryKey(String id);


    int insertSelective(User row);

    User selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(User row);

    int updateByPrimaryKey(User row);

    User selectByLoginActAndLoginPwd(Map<String,Object> map);

    List<User> selectAllUser();

    //创建用户
    int insertUser(User user);

    //根据条件分页查询用户列表
    List<User> selectUserByConditionForPage(Map<String,Object> map);

    //根据条件查询用户的总条数
    int selectCountOfUserByCondition(Map<String,Object> map);

    //修改用户lockState实现用户状态修改
    int updateLockStateOfUserById(Map<String,Object> map);
}