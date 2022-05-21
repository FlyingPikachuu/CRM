package com.qsy.workbench.dao;

import com.qsy.workbench.pojo.ContactRemark;
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
    int insertContactRemarkByList(List<ContactRemark> corList);

    //查询所有备注
    List<ContactRemark> selectContactRemarkForDetailByContactId(String contactId);

    //添加一条备注
    int insertContactRemark(ContactRemark contactRemark);

    //删除一条备注
    int deleteContactRemarkById(String id);

    //修改一条备注
    int updateContactRemark(ContactRemark contactRemark);


    //根据contactId删除备注信息
    int deleteContactRemarkByContactId(String[] contactId);
}