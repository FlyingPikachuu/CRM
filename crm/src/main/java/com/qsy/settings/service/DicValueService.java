package com.qsy.settings.service;

import com.qsy.settings.pojo.DicValue;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

/**
 * @author qsy
 * @create 2022/4/14 - 9:03
 */
public interface DicValueService {
    List<DicValue> queryDicValueByTypeCode(String typeCode);

    List<DicValue> queryDicValueForPageByCondition(Map<String,Object> map);
    int  queryCountOfDicValueByCondition(Map<String,Object> map);
    //添加数据字典类型
    int addDicValue(DicValue dicValue);
    //查询字典类型根据id
    DicValue queryDicValueById(String id);
    //修改数据字典
    int editDicValue(DicValue dicValue);
    //删除数据字典类型
    void deleteDicValueById(String[] id);

    DicValue queryDicValueByTypeCodeAndOrderNo(String typeCode,String orderNo);

}
