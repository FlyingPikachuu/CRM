package com.qsy.workbench.service;

import com.qsy.workbench.pojo.ContactRemark;

import java.util.List;

/**
 * @author qsy
 * @create 2022/5/8 - 8:29
 */
public interface ContactRemarkService {

    List<ContactRemark> queryContactRemarkForDetailByContactId(String contactId);

    //添加一条备注
    int addContactRemark(ContactRemark contactRemark);

    //删除一条备注
    int deleteContactRemarkById(String id);

    //修改一条备注
    int editContactRemark(ContactRemark contactRemark);
}
