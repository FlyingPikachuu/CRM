package com.qsy.workbench.service.impl;

import com.qsy.workbench.dao.ContactMapper;
import com.qsy.workbench.pojo.Contact;
import com.qsy.workbench.service.ContactService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * @author qsy
 * @create 2022/5/3 - 15:22
 */
@Service
public class ContactServiceImpl implements ContactService {
    @Autowired
    private ContactMapper contactMapper;
    @Override
    public List<Contact> queryContactForSaveTran(String fullname) {
        return contactMapper.selectContactForSaveTran(fullname);
    }
}
