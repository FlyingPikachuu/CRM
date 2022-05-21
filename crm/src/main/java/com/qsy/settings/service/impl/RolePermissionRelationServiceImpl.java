package com.qsy.settings.service.impl;

import com.qsy.settings.dao.RolePermissionRelationMapper;
import com.qsy.settings.pojo.RolePermissionRelation;
import com.qsy.settings.service.RolePermissionRelationService;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author qsy
 * @create 2022/5/13 - 22:15
 */
@Service
public class RolePermissionRelationServiceImpl implements RolePermissionRelationService {
    @Autowired
    private RolePermissionRelationMapper rolePermissionRelationMapper;
    @Override
    public String queryPidByRoleId(String roleId) {
        return rolePermissionRelationMapper.selectPidByRoleId(roleId);
    }

    @Override
    public void assignPermission(RolePermissionRelation rolePermissionRelation) {
        String roleId = rolePermissionRelation.getRoleId();
        RolePermissionRelation rpr = rolePermissionRelationMapper.selectRPRByRoleId(roleId);
        if(rpr==null){
            rolePermissionRelationMapper.insertRPR(rolePermissionRelation);
        }else{
            rolePermissionRelationMapper.updateRPRByRoleId(rolePermissionRelation);
        }
    }

    @Override
    public List<String> queryPidByRoleIds(String[] roleIds) {
        return rolePermissionRelationMapper.selectPidByRoleIds(roleIds);
    }
}
