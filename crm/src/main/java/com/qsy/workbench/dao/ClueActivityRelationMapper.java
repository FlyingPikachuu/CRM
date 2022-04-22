package com.qsy.workbench.dao;

import com.qsy.workbench.pojo.ClueActivityRelation;

import java.util.List;

public interface ClueActivityRelationMapper {
    int deleteByPrimaryKey(String id);

    int insert(ClueActivityRelation row);

    int insertSelective(ClueActivityRelation row);

    ClueActivityRelation selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(ClueActivityRelation row);

    int updateByPrimaryKey(ClueActivityRelation row);

    //批量保存市场活动和线索关联关系
    int insertClueActivityRelation(List<ClueActivityRelation> list);

    //接触关联关系
    int deleteClueActivityRelationByActivityIdClueId(ClueActivityRelation clueActivityRelation);
}