package com.qsy.workbench.service;

import com.qsy.workbench.pojo.Clue;
import com.qsy.workbench.pojo.FunnelVO;
import com.qsy.workbench.pojo.LBVO;
import com.qsy.workbench.pojo.PieVO;

import java.util.List;
import java.util.Map;

/**
 * @author qsy
 * @create 2022/4/14 - 9:37
 */

public interface ClueService {
    int addClue(Clue clue);

    //分页查询线索信息
    List<Clue> queryClueForPageByCondition(Map<String,Object> map);

    //查询线索总条数
    int queryCountOfClueByCondition(Map<String,Object> map);

    Clue queryClueForDetailById(String id);

    //保存线索转换
    void saveConvertClue(Map<String,Object> map);

    Clue queryClueById(String id);
    //根据id修改指定线索
    int editClueById(Clue clue);
    //根据ids批量删除线索
    void deleteClue(String[] ids);

    //根据线索来源查询线索数量
    List<FunnelVO> queryCountOfClueBySource();
    //根据线索状态查询线索数量
    List<FunnelVO> queryCountOfClueByState();
    //查询当月创建线索TOP10
    List<LBVO> queryCountOfClueByOwnerAndCreate();
    //查询当年每月创建线索数量
    List<LBVO> queryCountOfClueByCreateMonth();
    List<Integer> queryMaxOfCreateClueInAYear();

    PieVO queryCountOfClue(Map<String,Object> map);

    int queryCountOfNewClue(Map<String,Object> map);

}
