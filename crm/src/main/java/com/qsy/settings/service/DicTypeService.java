package com.qsy.settings.service;

import com.qsy.settings.pojo.DicType;
import com.qsy.settings.pojo.DicValue;

import java.util.List;
import java.util.Map;

/**
 * @author qsy
 * @create 2022/5/10 - 10:33
 */
public interface DicTypeService {
    List<DicType> queryDicTypeForPageByCondition(Map<String, Object> map);
    int  queryCountOfDicTypeByCondition(Map<String,Object> map);

    List<DicType> queryAllDicType();

    //添加数据字典类型
    int addDicType(DicType dicType);
    //查询字典类型根据code
    DicType queryDicTypeByCode(String code);
    //修改数据字典
    int editDicType(Map<String,Object> map);
    //删除数据字典类型
    void deleteDicTypeByCode(String[] Code);
}