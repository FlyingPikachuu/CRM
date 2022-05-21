package com.qsy.settings.service.impl;

import com.qsy.settings.dao.DicTypeMapper;
import com.qsy.settings.dao.DicValueMapper;
import com.qsy.settings.pojo.DicType;
import com.qsy.settings.service.DicTypeService;
import com.qsy.settings.service.DicValueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * @author qsy
 * @create 2022/5/10 - 10:33
 */
@Service
public class DicTypeServiceImpl implements DicTypeService {
    @Autowired
    private DicTypeMapper dicTypeMapper;
    @Autowired
    private DicValueMapper dicValueMapper;

    @Override
    public List<DicType> queryDicTypeForPageByCondition(Map<String, Object> map) {
        return  dicTypeMapper.selectDicTypeForPageByCondition(map);
    }

    @Override
    public int queryCountOfDicTypeByCondition(Map<String, Object> map) {
        return dicTypeMapper.selectCountOfDicTypeByCondition(map);
    }

    @Override
    public List<DicType> queryAllDicType() {
        return  dicTypeMapper.selectAllDicType();
    }

    @Override
    public int addDicType(DicType dicType) {
        return dicTypeMapper.insertDicType(dicType);
    }

    @Override
    public DicType queryDicTypeByCode(String code) {
        return dicTypeMapper.selectDicTypeByCode(code);
    }

    @Override
    public int editDicType(Map<String, Object> map) {
        return dicTypeMapper.updateDicType(map);
    }


    @Override
    public void deleteDicTypeByCode(String[] code) {
        dicValueMapper.deleteDicValueByTypeCode(code);
        dicTypeMapper.deleteDicTypeByCode(code);
    }
}
