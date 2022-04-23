package com.qsy.workbench.dao;

import com.qsy.workbench.pojo.ClueRemark;

import java.util.List;

public interface ClueRemarkMapper {
    int deleteByPrimaryKey(String id);

    int insert(ClueRemark row);

    int insertSelective(ClueRemark row);

    ClueRemark selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(ClueRemark row);

    int updateByPrimaryKey(ClueRemark row);

    //查询线索明细页面的全部备注
    List<ClueRemark> selectClueRemarkForDetailByClueId(String clueId);

    //添加一条线索
    int insertClueRemark(ClueRemark clueRemark);

    int updateClueRemark(ClueRemark clueRemark);

    int deleteClueRemarkById(String id);

    //查询指定线索下全部备注
    List<ClueRemark> selectClueRemarkForConvertByClueId(String clueId);

    int deleteClueRemarkByClueId(String clueId);

}