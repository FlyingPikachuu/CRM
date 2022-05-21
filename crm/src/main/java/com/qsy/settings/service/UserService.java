package com.qsy.settings.service;

import com.qsy.settings.pojo.User;

import java.util.List;
import java.util.Map;

/**
 * @author qsy
 * @create 2022/3/29 - 19:42
 */
public interface UserService {
    User queryByLoginActAndLoginPwd(Map<String,Object> map);
    List<User> queryAllUser();
    int addUser(User user);

    List<User> queryUserByConditionForPage(Map<String,Object> map);
    int queryCountOfUserByCondition(Map<String,Object> map);

    int editLockStateOfUserById(Map<String,Object> map);

    //修改密码
    int editPwdById(Map<String,Object> map);

    User queryUserById(String id);

    //分配角色，将用户roleno修改为新值
    int editRoleNoByRoleNo(String roleno,String id);
    int editRoleNoById(String id);
    int editUserById(User user);
    int editPersonalInfoById(User user);



}
