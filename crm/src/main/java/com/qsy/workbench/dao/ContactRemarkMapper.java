package com.qsy.workbench.dao;

import com.qsy.workbench.pojo.ContactRemark;

import java.util.List;

public interface ContactRemarkMapper {
    int deleteByPrimaryKey(String id);

    int insert(ContactRemark row);

    int insertSelective(ContactRemark row);

    ContactRemark selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(ContactRemark row);

    int updateByPrimaryKey(ContactRemark row);

    //转换中，批量添加联系人备注
    int insertContactRemark(List<ContactRemark> corList);
}