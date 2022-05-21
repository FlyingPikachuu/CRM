package com.qsy.workbench.dao;

import com.qsy.workbench.pojo.Clue;
import com.qsy.workbench.pojo.FunnelVO;
import com.qsy.workbench.pojo.LBVO;
import com.qsy.workbench.pojo.PieVO;


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

    //根据id查询线索信息显示到修改模态窗口
    Clue selectClueById(String id);
    //根据id修改指定线索
    int updateClueById(Clue clue);
    //根据ids批量删除线索
    int deleteClueByIds(String[] ids);

    //图表统计
    //根据线索来源查询线索数量
    List<FunnelVO> selectCountOfClueBySource();
    //根据线索状态查询线索数量
    List<FunnelVO> selectCountOfClueByState();
    //查询当月职员已联系线索TOP10
    List<LBVO> selectCountOfClueByOwnerAndCreate();
    //查询当年每月创建线索数量
    List<LBVO> selectCountOfClueByCreateMonth();
    List<Integer> selectMaxOfCreateClueInAYear();

    //查询线索已联系率
    PieVO selectCountOfClue(Map<String,Object> map);
    int selectCountOfNewClue(Map<String,Object> map);
}