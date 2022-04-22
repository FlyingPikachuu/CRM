package com.qsy.settings.service;

import com.qsy.settings.pojo.DicValue;

import java.util.List;

/**
 * @author qsy
 * @create 2022/4/14 - 9:03
 */
public interface DicValueService {
    List<DicValue> queryDicValueByTypeCode(String typeCode);
}
