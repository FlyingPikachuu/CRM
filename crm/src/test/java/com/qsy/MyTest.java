package com.qsy;


import com.qsy.settings.dao.UserMapper;
import com.qsy.workbench.dao.ActivityMapper;
import com.qsy.settings.pojo.User;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.util.HashMap;
import java.util.Map;

/**
 * @author qsy
 * @create 2022/4/2 - 8:58
 */
public class MyTest {
    @Test
    public void test(){
        ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
        UserMapper userMapper = context.getBean("userMapper", UserMapper.class);
        Map<String,Object> map = new HashMap<>();
        map.put("endDateTime","2022-03-11 17:03:11");
        map.put("beginNo",0);
        map.put("pageSize",10);
        for (User user : userMapper.selectUserByConditionForPage(map)) {
            System.out.println(user);
        }

    }

    @Test
    public void test1() {
        ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
        ActivityMapper activityMapper = context.getBean("activityMapper", ActivityMapper.class);
        String[] strings = {"a640442a1c6645b0be8f96dab7de4aa3"};
        activityMapper.deleteActivityById(strings);
    }
    @Test
    public void test3(){
        String a= new String("abc");
        System.out.println(a);
        if(a.equals("abc")){
            a="1";
        }

        System.out.println(a);

        String str2 = "1+2-3+5-64*25+25/65";
        String[] array = str2.split("/\\+|-|\\*|/");
        for (String s : array) {
            System.out.println(s);
        }

        char[] c = new char[100];
        a="10";
        double d=10.5;

        System.out.println(Integer.parseInt(a));
    }
}
