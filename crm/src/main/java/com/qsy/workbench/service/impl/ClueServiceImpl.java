package com.qsy.workbench.service.impl;

import com.qsy.workbench.dao.ClueMapper;
import com.qsy.workbench.pojo.Clue;
import com.qsy.workbench.service.CLueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * @author qsy
 * @create 2022/4/14 - 9:38
 */
@Service
public class ClueServiceImpl implements CLueService {

    @Autowired
    private ClueMapper clueMapper;

    @Override
    public int addClue(Clue clue) {
        return clueMapper.insertClue(clue);
    }

    @Override
    public List<Clue> queryClueForPageByCondition(Map<String, Object> map) {
        return clueMapper.selectClueForPageByCondition(map);
    }

    @Override
    public int queryCountOfClueByCondition(Map<String, Object> map) {
        return clueMapper.selectCountOfClueByCondition(map);
    }

    @Override
    public Clue queryClueForDetailById(String id) {
        return clueMapper.selectClueForDetailById(id);
    }
}
