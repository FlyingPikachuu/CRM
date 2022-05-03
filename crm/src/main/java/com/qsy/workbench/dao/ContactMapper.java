package com.qsy.workbench.dao;

import com.qsy.workbench.pojo.Contact;

import java.util.List;

public interface ContactMapper {
    int deleteByPrimaryKey(String id);

    int insert(Contact row);

    int insertSelective(Contact row);

    Contact selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Contact row);

    int updateByPrimaryKey(Contact row);

    //添加一条联系人记录
    int insertContact(Contact contact);

    List<Contact> selectContactForSaveTran(String name);
}