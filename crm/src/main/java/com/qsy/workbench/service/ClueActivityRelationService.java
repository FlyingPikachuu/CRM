package com.qsy.workbench.service;

import com.qsy.workbench.pojo.ClueActivityRelation;

import java.util.List;

/**
 * @author qsy
 * @create 2022/4/15 - 17:24
 */
public interface ClueActivityRelationService {
    int addClueActivityRelation(List<ClueActivityRelation> list);

    int deleteClueActivityRelationByActivityIdClueId(ClueActivityRelation clueActivityRelation);

}
