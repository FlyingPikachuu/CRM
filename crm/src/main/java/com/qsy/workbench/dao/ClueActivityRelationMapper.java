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

    //解除关联关系,根据clueId和activityId删除线索和市场活动的关联关系
    int deleteClueActivityRelationByActivityIdClueId(ClueActivityRelation clueActivityRelation);

    //根据ClueId查询关联记录
    List<ClueActivityRelation> selectClueActivityRelationByClueId(String clueId);

    //根据ClueId删除关联关系
    int deleteClueActivityRelationByClueId(String id);
}