package com.qsy;


import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.qsy.settings.dao.UserMapper;
import com.qsy.settings.pojo.Permission;
import com.qsy.settings.service.RolePermissionRelationService;
import com.qsy.utils.Constants;
import com.qsy.utils.MyStringUtils;
import com.qsy.workbench.dao.ActivityMapper;
import com.qsy.settings.pojo.User;
import com.qsy.workbench.pojo.Customer;
import com.qsy.workbench.pojo.PieVO;
import com.qsy.workbench.pojo.Transaction;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.util.*;

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

    @Test
    public void test5(){

        HashMap<String, Object> m = new HashMap<>();
        int a=1;
        m.put("sum",a+1+1);
        m.put("b",a);
        System.out.println(m);
    }

    @Test
    public void test6(){
        int a = 123;
        Object obj  = a;
        Integer b = (int) obj;
        System.out.println(b instanceof Integer);
    }

    @Test
    public  void test7(){
        String a ="1";
        Customer customer =null;
        if((a!=""||!a.trim().equals(""))&&customer==null){
            System.out.println("success");
        }
        System.out.println(Constants.PERMISSION_DETAIL_URL+1);
    }
    @Test
    public void test0(){
        Transaction transaction = new Transaction();
        transaction.setStage("资质审查");
        ArrayList<Transaction> tList = new ArrayList<>();
        tList.add(transaction);
        Transaction transaction1 = new Transaction();
        transaction1.setStage("1");
        tList.add(transaction1);
        System.out.println(tList.size());
        List<Transaction> list = new ArrayList<>();
        Iterator<Transaction> iterator = tList.iterator();

        while(iterator.hasNext()){
            Transaction t = iterator.next();
            if(t.getStage()=="1"){
                iterator.remove();
            }

        }
        System.out.println(tList.size());
//        for (Transaction transaction1 : tList) {
//            System.out.println(transaction1.getStage());
//
//        }
//        for (Transaction transaction1 : list) {
//            System.out.println(transaction1.getStage());
//        }
    }
    @Test
    public  void testJson() throws JsonProcessingException {
        ObjectMapper mapper = new ObjectMapper();
        ArrayList<Permission> permissions = new ArrayList<>();
        Permission permission = new Permission();
        permission.setId(1);
        Permission permission1 = new Permission();
        permission1.setId(2);
        permissions.add(permission);
        permissions.add(permission1);
        String s = mapper.writeValueAsString(permissions);
        System.out.println(s);
    }
    @Test
    public void testStringUtil(){
        String s1 = "1,2,3";
        String s2 = "1,2,3,4,5";
        String s3 = "1,2,3,4,5,6";
        ArrayList<String> stringList = new ArrayList<>();
        stringList.add(s1);
        stringList.add(s2);
        stringList.add(s3);
        ArrayList<String> strings = new ArrayList<>();
        strings.add(s1);
        System.out.println(MyStringUtils.stringListUnionRet(stringList));
        System.out.println(MyStringUtils.stringListUnionRet(strings));

//        String union = MyStringUtils.getUnion(s1, s2, ",");
//        System.out.println(union);
    }
    @Test
    public void testSet(){

       //set元素唯一性，去重测试
        HashSet<String> set = new HashSet<String>();
        String[] s = {"1","s1"};
        String[] s1 = {"2","s2"};
        String[] s2 = {"1","2","3"};
        String[] s3 = {"3","4","5"};
        System.out.println(s3);
//        Collections.addAll(set, s);
//        Collections.addAll(set,"a1","a2");
//        Collections.addAll(set,s1);
//        Collections.addAll(set,s2);
//        Collections.addAll(set,s3);
//        System.out.println(set);
//        //Collection<? extends E> c E为指定的泛型，c为集合名称，上限——E或E的子类
//       //多态
//        LinkedList<String> l1=new LinkedList<>();//定义泛型
//        l1.add("1");//添加元素
//        l1.add("2");//添加元素
//        System.out.println(l1);
//        System.out.println();
//        LinkedList<Object>l2=new LinkedList<Object>(l1);//可以看到这里的构造方法传 //入的参数是l1,l1所用的泛型是不同于l2的，具体的说：l1所用的泛型是l2所用泛型的子类即//String是Object的子类
//        System.out.print(l2);
            }

            @Test
    public void test123(){
//                String s1= "1,2,3,4,5,27,6,7,8,9";
//                String s2 = "1,2,27";
//                String s3 = "1,6,8,28";
//                List<String> stringList = new ArrayList<>();
//                stringList.add(s1);
//                stringList.add(s2);
//                stringList.add(s3);
//                String retString1 = MyStringUtils.getUnion(s1,s2,",");
//                System.out.println(retString1);
//                String retString2 = MyStringUtils.getUnion(retString1,s3,",");
//                System.out.println(retString2);
//                System.out.println(new Date().ge);
    }

}
