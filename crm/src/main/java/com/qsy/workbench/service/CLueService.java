package com.qsy.workbench.service;

import com.qsy.workbench.pojo.Clue;

import java.util.List;
import java.util.Map;

/**
 * @author qsy
 * @create 2022/4/14 - 9:37
 */

public interface CLueService {
    int addClue(Clue clue);

    //分页查询线索信息
    List<Clue> queryClueForPageByCondition(Map<String,Object> map);

    //查询线索总条数
    int queryCountOfClueByCondition(Map<String,Object> map);

    Clue queryClueForDetailById(String id);
}
