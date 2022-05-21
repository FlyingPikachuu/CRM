package com.qsy.settings.service.impl;


import com.qsy.settings.dao.DicValueMapper;
import com.qsy.settings.pojo.DicValue;
import com.qsy.settings.service.DicValueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * @author qsy
 * @create 2022/4/14 - 9:04
 */
@Service
public class DicValueServiceImpl implements DicValueService {

    @Autowired
    private DicValueMapper dicValueMapper;

    @Override
    public List<DicValue> queryDicValueByTypeCode(String typeCode) {
        return dicValueMapper.selectDicValueByTypeCode(typeCode);
    }

    @Override
    public List<DicValue> queryDicValueForPageByCondition(Map<String, Object> map) {
        return  dicValueMapper.selectDicValueForPageByCondition(map);
    }

    @Override
    public int queryCountOfDicValueByCondition(Map<String, Object> map) {
        return dicValueMapper.selectCountOfDicValueByCondition(map);
    }

    @Override
    public int addDicValue(DicValue dicValue) {
        return dicValueMapper.insertDicValue(dicValue);
    }

    @Override
    public DicValue queryDicValueById(String id) {
        return dicValueMapper.selectDicValueById(id);
    }

    @Override
    public int editDicValue(DicValue dicValue) {
        return dicValueMapper.updateDicValue(dicValue);
    }

    @Override
    public void deleteDicValueById(String[] id) {
        dicValueMapper.deleteDicValueById(id);
    }

    @Override
    public DicValue queryDicValueByTypeCodeAndOrderNo(String typeCode, String orderNo) {
        return dicValueMapper.selectDicValueByTypeCodeAndOrderNo(typeCode,orderNo);
    }
}
