package com.qsy.settings.dao;

import com.qsy.settings.pojo.DicType;
import com.qsy.settings.pojo.DicValue;
import org.apache.ibatis.annotations.Param;

import javax.management.Query;
import java.util.List;
import java.util.Map;

public interface DicValueMapper {
    int deleteByPrimaryKey(String id);

    int insert(DicValue row);

    int insertSelective(DicValue row);

    DicValue selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(DicValue row);

    int updateByPrimaryKey(DicValue row);

    List<DicValue> selectDicValueByTypeCode(String typeCode);

    List<DicValue> selectDicValueForPageByCondition(Map<String, Object> map);

    int selectCountOfDicValueByCondition(Map<String, Object> map);

    //添加数据字典值
    int insertDicValue(DicValue dicValue);

    //查询字典值根据id
    DicValue selectDicValueById(String id);

    //修改数据值
    int updateDicValue(DicValue dicValue);

    //删除数据字典值根据Id
    int deleteDicValueById(String[] id);

    //删除数据字典值根据typeCode
    int deleteDicValueByTypeCode(String[] typeCode);

    //查询字典值根据typeCode和orderNo
    DicValue selectDicValueByTypeCodeAndOrderNo(@Param("typeCode") String typeCode, @Param("orderNo") String orderNo);
}