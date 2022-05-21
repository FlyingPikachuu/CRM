package com.qsy.workbench.service.impl;

import com.qsy.workbench.dao.ContactMapper;
import com.qsy.workbench.dao.ContactRemarkMapper;
import com.qsy.workbench.pojo.ContactRemark;
import com.qsy.workbench.service.ContactRemarkService;
import com.qsy.workbench.service.ContactService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author qsy
 * @create 2022/5/8 - 8:28
 */
@Service
public class ContactRemarkServiceImpl implements ContactRemarkService {
    @Autowired
    private ContactRemarkMapper contactRemarkMapper;
    @Override
    public List<ContactRemark> queryContactRemarkForDetailByContactId(String contactId) {
        return contactRemarkMapper.selectContactRemarkForDetailByContactId(contactId);
    }

    @Override
    public int addContactRemark(ContactRemark contactRemark) {
        return contactRemarkMapper.insertContactRemark(contactRemark);
    }

    @Override
    public int deleteContactRemarkById(String id) {
        return contactRemarkMapper.deleteContactRemarkById(id);
    }

    @Override
    public int editContactRemark(ContactRemark contactRemark) {
        return contactRemarkMapper.updateContactRemark(contactRemark);
    }
}
