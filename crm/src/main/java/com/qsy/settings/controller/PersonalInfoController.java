package com.qsy.settings.controller;

import com.qsy.settings.pojo.Dept;
import com.qsy.settings.pojo.Role;
import com.qsy.settings.pojo.User;
import com.qsy.settings.service.RoleService;
import com.qsy.settings.service.UserService;
import com.qsy.utils.Constants;
import com.qsy.utils.DateUtils;
import com.qsy.utils.ReturnInfoObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.List;

/**
 * @author qsy
 * @create 2022/5/17 - 10:41
 */
@Controller
public class PersonalInfoController {
    @Autowired
    private UserService userService;
    @Autowired
    private RoleService roleService;
    @RequestMapping("/settings/personalInfo/main.do")
    public  String main(){
        return "settings/personalInfo/main";
    }
    @RequestMapping("/settings/personalInfo/index.do")
    public String index(HttpSession session, Model model){
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        String roleName= user.getRoleName();
        model.addAttribute("user",user);
        model.addAttribute("roleName",roleName);
        return "settings/personalInfo/index";
    }
    @RequestMapping("/settings/personalInfo/editPersonalInfoById.do")
    @ResponseBody
    public  Object editPersonalInfoById(User user,HttpSession session){
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        User users = (User) session.getAttribute(Constants.SESSION_USER);
        user.setEditBy(users.getId());
        user.setEditTime(DateUtils.formatDateTime(new Date()));
        try {
            int var = userService.editPersonalInfoById(user);
            if(var>0){
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }
            else {
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnInfoObject.setMessage("系统忙,请稍后重试···");
            }
        } catch (Exception e) {
            e.printStackTrace();
            returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnInfoObject.setMessage("系统忙,请稍后重试···");
        }

        return returnInfoObject;
    }
}
