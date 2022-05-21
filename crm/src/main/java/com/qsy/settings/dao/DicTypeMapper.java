package com.qsy.settings.dao;

import com.qsy.settings.pojo.DicType;

import java.util.List;
import java.util.Map;

public interface DicTypeMapper {
    int deleteByPrimaryKey(String code);

    int insert(DicType row);

    int insertSelective(DicType row);

    DicType selectByPrimaryKey(String code);

    int updateByPrimaryKeySelective(DicType row);

    int updateByPrimaryKey(DicType row);

    //查询所有数据字典类型
    List<DicType> selectDicTypeForPageByCondition(Map<String,Object> map);
    int  selectCountOfDicTypeByCondition(Map<String,Object> map);

    List<DicType> selectAllDicType();

    //添加数据字典类型
    int insertDicType(DicType dicType);
    //查询字典类型根据code
    DicType selectDicTypeByCode(String code);
    //修改数据字典
    int updateDicType(Map<String,Object> map);
    //删除数据字典类型
    int deleteDicTypeByCode(String[] code);
}