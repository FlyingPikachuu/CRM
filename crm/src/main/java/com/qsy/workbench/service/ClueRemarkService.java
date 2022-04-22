package com.qsy.workbench.service;

import com.qsy.workbench.pojo.ClueRemark;

import java.util.List;

/**
 * @author qsy
 * @create 2022/4/15 - 14:28
 */
public interface ClueRemarkService  {
    List<ClueRemark> queryClueRemarkForDetailByClueId(String clueId);

    int addClueRemark(ClueRemark clueRemark);

    int editClueRemark(ClueRemark clueRemark);

    int deleteClueRemarkById(String id);
}
