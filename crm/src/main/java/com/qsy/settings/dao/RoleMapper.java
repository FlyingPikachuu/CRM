package com.qsy.settings.dao;

import com.qsy.settings.pojo.Role;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface RoleMapper {
    int deleteByPrimaryKey(String code);

    int insert(Role row);

    int insertSelective(Role row);

    Role selectByPrimaryKey(String code);

    int updateByPrimaryKeySelective(Role row);

    int updateByPrimaryKey(Role row);

    List<Role> selectAllRole();

    int insertRole(Role role);

    Role selectRoleByCode(String code);
    int updateRoleByCode(Map<String,Object> map);
    int deleteRoleByCode(String[] ids);

    //查找未分配的角色
    List<Role> selectNotAssignedRole(String[] codes);

    //查找已分配的角色
    List<Role> selectAssignedRole(String[] codes);


}