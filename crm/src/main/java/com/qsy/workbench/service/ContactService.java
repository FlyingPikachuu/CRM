package com.qsy.workbench.service;

import com.qsy.workbench.pojo.Contact;

import java.util.List;

/**
 * @author qsy
 * @create 2022/5/3 - 15:21
 */
public interface ContactService {
    List<Contact> queryContactForSaveTran(String fullname);

}
