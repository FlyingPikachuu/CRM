package com.qsy.workbench.controller;

import com.qsy.settings.pojo.User;
import com.qsy.utils.Constants;
import com.qsy.utils.DateUtils;
import com.qsy.utils.IDUtils;
import com.qsy.utils.ReturnInfoObject;
import com.qsy.workbench.pojo.ContactRemark;
import com.qsy.workbench.service.ContactRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;

/**
 * @author qsy
 * @create 2022/5/8 - 21:05
 */
@Controller
public class ContactRemarkController {
    @Autowired
    private ContactRemarkService contactRemarkService;
    
    @RequestMapping("/workbench/contact/addContactRemark.do")
    @ResponseBody
    public Object addContactRemark(ContactRemark contactRemark, HttpSession session){
        User user = (User)session.getAttribute(Constants.SESSION_USER);
        contactRemark.setId(IDUtils.getId());
        contactRemark.setCreateBy(user.getId());
        contactRemark.setCreateTime(DateUtils.formatDateTime(new Date()));
        contactRemark.setEditFlag(Constants.RETURN_EDIT_FLAG_NO_EDITED);

        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
       try {
            int ret = contactRemarkService.addContactRemark(contactRemark);
            if(ret>0){
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                returnInfoObject.setReturnData(contactRemark);
            }else{
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnInfoObject.setMessage("系统忙，请稍后重试···");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnInfoObject.setMessage("系统忙，请稍后重试···");
        }
        return returnInfoObject;
    }

    @RequestMapping("/workbench/contact/deleteContactRemark.do")
    @ResponseBody
    public Object deleteContactRemark(String id){
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
       try {
            int ret = contactRemarkService.deleteContactRemarkById(id);
            if(ret>0){
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }else{
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnInfoObject.setMessage("系统忙，请稍后重试···");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnInfoObject.setMessage("系统忙，请稍后重试···");
        }
        return returnInfoObject;
    }

    @RequestMapping("/workbench/Contact/editContactRemark.do")
    @ResponseBody
    public  Object editContactRemark(ContactRemark cr, HttpSession session){
        User user = (User)session.getAttribute(Constants.SESSION_USER);
       cr.setEditFlag(Constants.RETURN_EDIT_FLAG_HAVE_EDITED);
       cr.setEditBy(user.getId());
       cr.setEditTime(DateUtils.formatDateTime(new Date()));

        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
       try {
            int ret = contactRemarkService.editContactRemark(cr);
            if(ret>0){
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                returnInfoObject.setReturnData(cr);
            }else{
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnInfoObject.setMessage("系统忙，请稍后重试···");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnInfoObject.setMessage("系统忙，请稍后重试···");
        }
        return  returnInfoObject;
    }
}
