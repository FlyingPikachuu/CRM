package com.qsy.interceptor;

import com.qsy.settings.pojo.User;
import com.qsy.utils.Constants;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @author qsy
 * @create 2022/3/30 - 12:31
 */
public class LoginInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        //判断用户是否登录
        //如果用户没用登录成功，则跳转到登录页面
        User user = (User) request.getSession().getAttribute(Constants.SESSION_USER);
        if(user==null){
            response.sendRedirect(request.getContextPath());//重定向时，url必须加项目名称
            return false;
        }
        return true;
    }

    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
    }
}
