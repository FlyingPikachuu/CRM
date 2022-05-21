package com.qsy.interceptor;

import com.qsy.settings.pojo.Permission;
import com.qsy.settings.pojo.User;
import com.qsy.settings.service.PermissionService;
import com.qsy.settings.service.RolePermissionRelationService;
import com.qsy.utils.Constants;
import com.qsy.utils.MyStringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.ui.Model;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.List;

/**
 * @author qsy
 * @create 2022/5/16 - 14:53
 */
@Component
public class MenuInterceptor implements HandlerInterceptor {
    @Autowired
    private PermissionService permissionService;
    @Autowired
    private RolePermissionRelationService rolePermissionRelationService;
        @Override
        public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
            //判断用户是否登录
            //如果用户没用登录成功，则跳转到登录页面
          int p=0;
          int k=0;
            Model model = null;

            HttpSession session = request.getSession();
            User user = (User) session.getAttribute(Constants.SESSION_USER);
            List<Permission> list= (List<Permission>) session.getAttribute(Constants.SESSION_PERMISSION_LIST);
            List<Permission> list2= (List<Permission>) session.getAttribute(Constants.SESSION_USER_PERMISSION_LIST);

            if(user==null){
                response.sendRedirect(request.getContextPath());//重定向时，url必须加项目名称
                return false;
            }else{
                String url = request.getServletPath();
                System.out.println(url);
                for (int i = 0; i < list.size(); i++) {
                    System.out.println(list.get(i).getDoUrl());
                    if(url.contains((list.get(i).getDoUrl()))){
                        for (int j = 0; j < list2.size(); j++) {
                            k++;
                            System.out.println(list2.get(j).getDoUrl());
                            if(url.contains(list2.get(j).getDoUrl())){
                                return true;
                            }
                        }
                    }
                    p++;
                }
                if(p>0 && k==list2.size()){
                    response.getWriter().write("Sorry,You don't have permission");
                    return false;
                }
                //若请求不属于权限列表则请求为公开权限，通过
                if(list.size()==p){
                    return true;
                }
                response.getWriter().write("Sorry,You don't have permission");
                return  false;
            }


        }

        @Override
        public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {

        }

        @Override
        public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
        }
    }

