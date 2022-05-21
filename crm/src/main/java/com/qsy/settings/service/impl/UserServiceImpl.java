package com.qsy.settings.service.impl;

import com.qsy.settings.controller.QxController;
import com.qsy.settings.dao.DeptMapper;
import com.qsy.settings.dao.UserMapper;
import com.qsy.settings.pojo.Dept;
import com.qsy.settings.pojo.User;
import com.qsy.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * @author qsy
 * @create 2022/3/29 - 19:42
 */
@Service
public class UserServiceImpl implements UserService {
    @Autowired
    private UserMapper userMapper;
    @Override
    public User queryByLoginActAndLoginPwd(Map<String, Object> map) {
       return userMapper.selectByLoginActAndLoginPwd(map);
    }

    @Override
    public List<User> queryAllUser() {
        return userMapper.selectAllUser();
    }

    @Override
    public int  addUser(User user) {
        return userMapper.insertUser(user);
    }

    @Override
    public List<User> queryUserByConditionForPage(Map<String, Object> map) {
        return userMapper.selectUserByConditionForPage(map);
    }

    @Override
    public int queryCountOfUserByCondition(Map<String, Object> map) {
        return userMapper.selectCountOfUserByCondition(map);
    }

    @Override
    public int editLockStateOfUserById(Map<String,Object> map) {
        return userMapper.updateLockStateOfUserById(map);
    }

    @Override
    public int editPwdById(Map<String, Object> map) {
        return userMapper.updatePwdById(map);
    }

    @Override
    public User queryUserById(String id) {
        return userMapper.selectUserById(id);
    }

    @Override
    public int editRoleNoByRoleNo(String roleno,String id) {
        return userMapper.updateRoleNoByRoleNo(roleno,id);
    }

    @Override
    public int editRoleNoById(String id) {
        return  userMapper.updateRoleNoById(id);
    }

    @Override
    public int editUserById(User user) {
        return userMapper.updateUserById(user);
    }

    @Override
    public int editPersonalInfoById(User user) {
        return userMapper.updatePersonalInfoById(user);
    }


}
