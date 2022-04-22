package com.qsy.workbench.service.impl;

import com.qsy.workbench.dao.ClueActivityRelationMapper;
import com.qsy.workbench.pojo.ClueActivityRelation;
import com.qsy.workbench.service.ClueActivityRelationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author qsy
 * @create 2022/4/15 - 17:25
 */
@Service
public class ClueActivityRelationServiceImpl implements ClueActivityRelationService {

    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;


    @Override
    public int addClueActivityRelation(List<ClueActivityRelation> list) {
        return clueActivityRelationMapper.insertClueActivityRelation(list);
    }

    @Override
    public int deleteClueActivityRelationByActivityIdClueId(ClueActivityRelation clueActivityRelation) {
        return clueActivityRelationMapper.deleteClueActivityRelationByActivityIdClueId(clueActivityRelation);
    }
}
