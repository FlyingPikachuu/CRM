package com.qsy.settings.dao;

import com.qsy.settings.pojo.User;
import org.apache.ibatis.annotations.Param;
import org.springframework.web.bind.annotation.PathVariable;

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

    //根据id查询用户信息
    User selectUserById(String id);
    //修改密码
    int updatePwdById(Map<String,Object> map);
    //因为修改部门，根据部门代码修改用户代码为新代码
    int updateUserDeptNoByCode(@Param("deptno") String deptno,@Param("oldDeptno") String oldDeptno);
    //因为删除部门，根据部门no删除user
    int deleteUserByDeptNO(String[] code);

    //因为角色修改，修改用户roleno为新值
    int updateUserByRoleNo(@Param("code") String code,@Param("oldCode") String oldCode);
    //因为角色删除，批量修改用户roleno为空
    int updateRoleNoToNull(String[] code);

    //分配角色，将用户roleno修改为新值
    int updateRoleNoByRoleNo(@Param("roleno") String roleno, @Param("id") String id);

    //撤销分配，将指定用户roleno置为新值
    int updateRoleNoById(String id);

    //修改用户信息
    int updateUserById(User user);
    //修改个人信息
    int updatePersonalInfoById(User user);
}