package com.qsy.settings.controller;

import com.qsy.settings.pojo.Permission;
import com.qsy.settings.pojo.Role;
import com.qsy.settings.service.*;
import com.qsy.utils.*;
import com.qsy.settings.pojo.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author qsy
 * @create 2022/3/28 - 19:29
 */
@Controller
public class LoginController {

    @Autowired
    private UserService userService;
    @Autowired
    private DeptService deptService;
    @Autowired
    private PermissionService permissionService;
    @Autowired
    private RolePermissionRelationService rolePermissionRelationService;
    @Autowired
    private RoleService roleService;
    /*
    * 理论上，给Controller 方法分配url: http://127.0.0.1:8080/crm/
      为了简便，协议://ip:port/应用名称 将这些省去，用/代表应用根目录下的/
    * */
    @RequestMapping("/")
    public String index(){
        //请求转发到欢迎页
        return  "index";
    }
    /*
    * URL要和Controller方法处理完请求，响应信息返回的页面的资源目录保持一致*/
    @RequestMapping("/settings/qx/user/toLogin.do")
    public String toLogin(){
        //请求转发到登录页面
        return "settings/qx/user/login";
    }
    @RequestMapping("/settings/qx/user/login.do")
    @ResponseBody
    public Object login(String loginAct, String loginPwd, String isRemPwd, HttpServletRequest request, HttpServletResponse response, HttpSession session){
        //封装参数
        Map<String, Object> map = new HashMap<>();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);

        //service调用方法
        User user = userService.queryByLoginActAndLoginPwd(map);

        //响应信息
        ReturnInfoObject returnInfoObject = new ReturnInfoObject();
        if(user==null){
            returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnInfoObject.setMessage("用户名或者密码错误");
        }
        else{
            if(DateUtils.formatDateTime(new Date()).compareTo(user.getExpireTime())>0)
            {
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnInfoObject.setMessage("用户已过期");
            }
            else if("0".equals(user.getLockState())){
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnInfoObject.setMessage("用户状态已被锁定");
            }
            else if(!user.getAllowIps().contains(request.getRemoteAddr())){
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnInfoObject.setMessage("用户ip被禁用");
            }else if(user.getRoleno()==null||user.getRoleno().equals("")){
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnInfoObject.setMessage("用户没有权限");
            }
            else{
                //登录成功
                returnInfoObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                String roleName= "";
                List<Role> roleList = roleService.queryAssignedRole(user.getRoleno().split(","));
                for (int i = 0; i < roleList.size() ; i++) {
                    if(i<roleList.size()-1){
                        roleName+=roleList.get(i).getName()+",";
                    }else{
                        roleName+=roleList.get(i).getName();
                    }
                }
                user.setRoleName(roleName);
                user.setLoginTime( String.valueOf(new Date().getTime()));

                //把user保存到session中
                session.setAttribute(Constants.SESSION_USER,user);
//                String roleno = user.getRoleno();
//                String[] split = roleno.split(",");
//                List<String> strings = rolePermissionRelationService.queryPidByRoleIds(split);
//                String s = MyStringUtils.stringListUnionRet(strings);
//                List<Permission> userPermissionList = permissionService.queryPermissionByIds(s.split(","));
//                //把user的permissionList保存到session中
//                session.setAttribute(Constants.SESSION_USER_PERMISSION_LIST,userPermissionList);
//
//                List<Permission> allPermissionList = permissionService.queryAllPermission();
//                session.setAttribute(Constants.SESSION_PERMISSION_LIST,allPermissionList);

                //如果需要记住密码，则往客户端返回cookie，保存在客户端，待下次发出请求时传给后端
                if("true".equals(isRemPwd)){
                    Cookie cookie = new Cookie("loginAct", user.getLoginAct());
                    cookie.setMaxAge(10*24*60*60);
                    response.addCookie(cookie);
                    Cookie cookie2 = new Cookie("loginPwd", user.getLoginPwd());
                    cookie2.setMaxAge(10*24*60*60);
                    response.addCookie(cookie2);
                }else{
                    //把没过期的cookie删除
                    Cookie cookie = new Cookie("loginAct", "1");
                    cookie.setMaxAge(0);
                    response.addCookie(cookie);
                    Cookie cookie2 = new Cookie("loginPwd", "2");
                    cookie2.setMaxAge(0);
                    response.addCookie(cookie2);
                }

            }
        }
        return  returnInfoObject;
    }
    //跳转到业务主页面
    @RequestMapping("/workbench/index.do")
    public String workBenchIndex(){
        return "workbench/index";
    }

    //安全退出
    @RequestMapping("/settings/qx/user/logout.do")
    public String logout(HttpServletResponse response,HttpSession session){
        //销毁cookie
        Cookie cookie = new Cookie("loginAct", "1");
        cookie.setMaxAge(0);
        response.addCookie(cookie);
        Cookie cookie2 = new Cookie("loginPwd", "2");
        cookie2.setMaxAge(0);
        response.addCookie(cookie2);
        //销毁session
        session.invalidate();
        return "redirect:/";//借助springMVC来重定向     response.sendRedirect("/crm/");
    }


}
