package com.qsy.settings.dao;

import com.qsy.settings.pojo.Dept;

import java.util.List;
import java.util.Map;

public interface DeptMapper {
    int deleteByPrimaryKey(String code);

    int insert(Dept row);

    int insertSelective(Dept row);

    Dept selectByPrimaryKey(String code);

    int updateByPrimaryKeySelective(Dept row);

    int updateByPrimaryKey(Dept row);

    List<Dept> selectAllDept();

    int insertDept(Dept dept);

    Dept selectDeptByCode(String code);
    int updateDeptByCode(Map<String,Object> map);
    int deleteDeptByCode(String[] code);

    //根据输入内容模糊查询部门名称
    List<String> selectDeptNameByName(String name);
    //根据部门名称查询指定部门
    Dept selectDeptByName(String name);


}