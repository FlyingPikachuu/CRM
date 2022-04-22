package com.qsy.settings.dao;

import com.qsy.settings.pojo.DicValue;

import java.util.List;

public interface DicValueMapper {
    int deleteByPrimaryKey(String id);

    int insert(DicValue row);

    int insertSelective(DicValue row);

    DicValue selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(DicValue row);

    int updateByPrimaryKey(DicValue row);

    List<DicValue> selectDicValueByTypeCode(String typeCode);
}