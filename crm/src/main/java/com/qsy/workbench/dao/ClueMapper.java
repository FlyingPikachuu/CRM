package com.qsy.workbench.dao;

import com.qsy.workbench.pojo.Clue;


import java.util.List;
import java.util.Map;

public interface ClueMapper {
    int deleteByPrimaryKey(String id);

    int insert(Clue row);

    int insertSelective(Clue row);

    Clue selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Clue row);

    int updateByPrimaryKey(Clue row);

    int insertClue(Clue clue);

    //分页查询线索信息
    List<Clue> selectClueForPageByCondition(Map<String,Object> map);

    //查询线索总条数
    int selectCountOfClueByCondition(Map<String,Object> map);

    //根据Id查询线索明细信息
    Clue selectClueForDetailById(String id);

    //根据Id查询线索信息（数据库内信息）
    Clue selectClueForConvertById(String id);

    //根据Id删除线索
    int deleteClue(String id);

}