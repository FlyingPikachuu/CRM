package com.qsy.settings.controller;

import com.qsy.settings.dao.UserMapper;
import com.qsy.settings.pojo.User;
import com.qsy.settings.service.UserService;
import com.qsy.utils.Constants;
import com.qsy.utils.DateUtils;
import com.qsy.utils.IDUtils;
import com.qsy.utils.ReturnInfoObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author qsy
 * @create 2022/4/20 - 11:15
 */
@Controller
public class QxController {
    @Autowired
    private UserService userService;

    @RequestMapping("/settings/qx/index.do")
    public String index(){
        return "/settings/qx/index";
    }
    @RequestMapping("/settings/qx/permission/index.do")
    public String permissionIndex(){
        return "/settings/qx/permission/index";
    }
    @RequestMapping("/settings/qx/role/index.do")
    public String roleIndex(){
        return "/settings/qx/role/index";
    }
    //跳转到用户管理页面
    @RequestMapping("/settings/qx/user/index.do")
    public String user(Model model){
        List<User> userList = userService.queryAllUser();
        model.addAttribute("userList",userList);
        return "settings/qx/user/index";
    }
    @RequestMapping("/settings/qx/user/detail.do")
    public String detail(){
        return "settings/qx/user/detail";
    }

    @RequestMapping("/settings/qx/user/addUser.do")
    @ResponseBody
    public Object addUser(User user, HttpSession session){
        User users = (User) session.getAttribute(Constants.SESSION_USER);
        user.setId(IDUtils.getId());
        user.setCreateBy(users.getId());
        user.setCreatetime(DateUtils.formatDateTime(new Date()));


        ReturnInfoObject returnInfoObject = new ReturnInfoObject();

        try {
            int var = userService.addUser(user);
            if(var>0){
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }
            else{
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnInfoObject.setMessage("系统忙");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnInfoObject.setMessage("系统忙");
        }

        return returnInfoObject;
    }
    @RequestMapping("/settings/qx/user/queryUserByConditionForPage.do")
    @ResponseBody
    public Object queryUserByConditionForPage(String name,String deptno,String lockState,String startDateTime,
                                              String endDateTime,int pageNo,int pageSize){
        System.out.println(lockState);
        Map<String, Object> map = new HashMap<>();
        map.put("name",name);
        map.put("deptno",deptno);
        map.put("lockState",lockState);
        map.put("startDateTime",startDateTime);
        map.put("endDateTime",endDateTime);
        map.put("beginNo",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);

        List<User> userList = userService.queryUserByConditionForPage(map);
        int totalRows= userService.queryCountOfUserByCondition(map);

        //根据查询结果生成响应信息
        Map<String, Object> retMap = new HashMap<>();
        retMap.put("userList",userList);
        retMap.put("totalRows",totalRows);
        return retMap;
    }

    @RequestMapping("/settings/qx/user/editLockState.do")
    @ResponseBody//启动/禁用用户
    public Object editLockState(String lockState,String id){
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        HashMap<String, Object> map = new HashMap<>();
        map.put("id",id);
        System.out.println("前台"+lockState);
        if(lockState.equals("1")||lockState.equals(null)) {
            lockState = "0";
        }
        else{
            lockState="1";
        }
        map.put("lockState",lockState);
        System.out.println(map);
        try {
            int ret = userService.editLockStateOfUserById(map);
            if(ret>0){
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }else {
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
