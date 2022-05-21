package com.qsy.workbench.controller;

import com.qsy.settings.pojo.DicValue;
import com.qsy.settings.pojo.User;
import com.qsy.settings.service.DicValueService;
import com.qsy.settings.service.UserService;
import com.qsy.utils.Constants;
import com.qsy.utils.IDUtils;
import com.qsy.utils.ReturnInfoObject;
import com.qsy.workbench.pojo.*;
import com.qsy.workbench.service.*;
import com.qsy.workbench.service.ContactActivityRelationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.*;

/**
 * @author qsy
 * @create 2022/4/25 - 10:00
 */
@Controller
public class ContactController {
    @Autowired
    private UserService userService;
    @Autowired
    private DicValueService dicValueService;
    @Autowired
    private CustomerService customerService;
    @Autowired
    private ContactService contactService;
    @Autowired
    private ContactRemarkService contactRemarkService;
    @Autowired
    private TransactionService transactionService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ContactActivityRelationService contactActivityRelationService;
    @RequestMapping("/workbench/contact/index.do")
    public String index(Model model){
        List<User> userList = userService.queryAllUser();
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        List<DicValue> appellationList = dicValueService.queryDicValueByTypeCode("appellation");

        model.addAttribute("sourceList",sourceList);
        model.addAttribute("appellationList",appellationList);
        model.addAttribute("userList",userList);
        return "workbench/contact/index";
    }

    @RequestMapping("/workbench/contact/queryContactByConditionForPage.do")
    @ResponseBody
    public  Object queryContactByConditionForPage(@RequestParam Map<String,Object> map){
        int pageNo =Integer.parseInt(map.get("pageNo").toString());
        int  pageSize = Integer.parseInt(map.get("pageSize").toString());
        System.out.println(pageNo+","+pageSize);
        map.put("beginNo",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);
        List<Contact> cotList = contactService.queryContactByConditionForPage(map);
        int totalRows = contactService.queryCountOfContactByCondition(map);

        HashMap<String, Object> retMap = new HashMap<>();
        retMap.put("cotList",cotList);
        retMap.put("totalRows",totalRows);

        return retMap;

    }

    //根据输入的客户名称查询完整客户名称
    @RequestMapping("/workbench/contact/queryCustomerNameByName.do")
    @ResponseBody
    public Object queryCustomerNameByName(String customerName){
        List<String> customerNameList = customerService.queryCustomerNameByName(customerName);
        return customerNameList;
    }

    //添加联系人
    @RequestMapping("/workbench/contact/addContact.do")
    @ResponseBody
    public Object addContact(@RequestParam Map<String,Object> map, HttpSession session){
        System.out.println(map.get("customerName"));
        map.put(Constants.SESSION_USER,session.getAttribute(Constants.SESSION_USER));
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        try {
            contactService.saveContact(map);
            returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        } catch (Exception e) {
            returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnInfoObject.setMessage("系统忙，请重试···");
        }
        return returnInfoObject;
    }

    //查询指定联系人信息
    @RequestMapping("/workbench/contact/queryContactByIdForEdit.do")
    @ResponseBody
    public Object queryContactByIdForEdit(String id){
        Contact contact = contactService.queryContactById(id);
        return contact;
    }

    @RequestMapping("/workbench/contact/editContact.do")
    @ResponseBody
    public  Object editContact(@RequestParam Map<String,Object> map, HttpSession session){
        System.out.println(map.get("customerName"));
        map.put(Constants.SESSION_USER,session.getAttribute(Constants.SESSION_USER));
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        try {
            contactService.editContact(map);
            returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        } catch (Exception e) {
            returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnInfoObject.setMessage("系统忙，请重试···");
        }
        return returnInfoObject;
    }

    //删除联系人
    @RequestMapping("/workbench/contact/deleteContact.do")
    @ResponseBody
    public Object deleteContact(String[] ids){
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        try {
            contactService.deleteContact(ids);
            returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        } catch (Exception e) {
            e.printStackTrace();
            returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnInfoObject.setMessage("系统忙，请稍后重试···");
        }
        return  returnInfoObject;
    }
    @RequestMapping("/workbench/contact/toDetail.do/{id}")
    public String toDetail(@PathVariable String id,Model model){
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        List<DicValue> appellationList = dicValueService.queryDicValueByTypeCode("appellation");
        List<User> userList = userService.queryAllUser();
        Contact cot = contactService.queryContactByIdForDetail(id);
        List<ContactRemark> cotrList = contactRemarkService.queryContactRemarkForDetailByContactId(id);
        List<Transaction> tranList = transactionService.queryTranByContactId(id);
        ResourceBundle bundle = ResourceBundle.getBundle("possibility");
        for (Transaction t : tranList) {
            String stage = t.getStage();
            String possibility = bundle.getString(stage);
            t.setPossibility(possibility);
        }
        List<Activity> aList = activityService.queryActivityForContactDetailByContactId(id);

        model.addAttribute("sourceList",sourceList);
        model.addAttribute("appellationList",appellationList);
        model.addAttribute("userList",userList);
        model.addAttribute("cot",cot);
        model.addAttribute("cotrList",cotrList);
        model.addAttribute("tranList",tranList);
        model.addAttribute("aList",aList);
        return "workbench/contact/detail";
    }

    //模糊查询未关联的市场活动
    @RequestMapping("/workbench/contact/queryActivityForDetailByNameExpContactId.do")
    @ResponseBody
    public Object queryActivityForDetailByNameExpContactId(@RequestParam Map<String,Object> map){
        List<Activity> aList = activityService.queryActivityForDetailByNameExpContactId(map);
        return aList;
    }

    @RequestMapping("/workbench/contact/addRelation.do")
    @ResponseBody
    public Object addRelation(String[] activityId,String contactId){

        ReturnInfoObject returnInfoObject=new ReturnInfoObject();
        ContactActivityRelation car=null;
        List<ContactActivityRelation> relationList = new ArrayList<>();
        for (String ai : activityId) {
            car=new ContactActivityRelation();
            car.setId(IDUtils.getId());
            car.setActivityId(ai);
            car.setContactId(contactId);
            relationList.add(car);
        }
        System.out.println(relationList);
        try {
            int ret = contactActivityRelationService.addContactActivityRelation(relationList);
            if(ret>0){
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                List<Activity> activityList = activityService.queryActivityForBundByIds(activityId);
                returnInfoObject.setReturnData(activityList);
            }
            else{
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

    @RequestMapping("/workbench/contact/deleteRelation.do")
    @ResponseBody
    public Object deleteRelation(ContactActivityRelation contactActivityRelation){
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        try {
            int ret = contactActivityRelationService.deleteContactActivityRelationByActivityIdContactId(contactActivityRelation);
            if(ret>0){
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }
            else{
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
}
